#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>

// Falcon includes
#include "../src/falcon.h"

// Drivers
#include "../../../../drivers/uart/uart.h"
#include "../../../../drivers/common/irq.h"

#define NTESTS 1
#define LOGN 9 // FN-512

// Compile-time macro to find the largest temporary buffer size required
#define MAX2(a, b) ((a) > (b) ? (a) : (b))
#define MAX3(a, b, c) MAX2(MAX2(a, b), c)
#define FALCON_MAX_TMP_SIZE MAX3(FALCON_TMPSIZE_KEYGEN(LOGN), \
                                 FALCON_TMPSIZE_SIGNDYN(LOGN), \
                                 FALCON_TMPSIZE_VERIFY(LOGN))

// Global UART instance
uart uart0;

// UART Helpers
void uart_putchar(char c) {
    uart_transmit_byte(&uart0, (uint8_t)c);
}

// Interrupt-driven getchar
volatile char rx_char = 0;
volatile int rx_ready = 0;

void fast_irq0_handler() {
    // Read the byte from the UART's receive register (clears the interrupt)
    char *rx_ptr = (char*)(uart0.base_addr) + UART_RX_ADDR_OFFSET;
    rx_char = *rx_ptr;
    rx_ready = 1;
    
    // Disable interrupts INSIDE the ISR
    DISABLE_FAST_IRQ(0);
    DISABLE_GLOBAL_IRQ();
}

char uart_getchar() {
    rx_ready = 0;
    
    // Enable interrupts to listen for the incoming trigger byte
    ENABLE_GLOBAL_IRQ();
    ENABLE_FAST_IRQ(0);
    
    // Block until the ISR sets rx_ready
    while (!rx_ready) {
        __asm__ volatile ("nop");
    }
    
    return rx_char;
}

void uart_puts(const char* str) {
    while (*str) {
        uart_putchar(*str++);
    }
}

void uart_put_uint32(uint32_t num) {
    if (num == 0) {
        uart_putchar('0');
        return;
    }
    char buf[12];
    int i = 0;
    while (num > 0) {
        buf[i++] = (num % 10) + '0';
        num /= 10;
    }
    while (i > 0) {
        uart_putchar(buf[--i]);
    }
}

// 64-bit print helper for cycle counts
void uart_put_uint64(uint64_t num) {
    if (num == 0) {
        uart_putchar('0');
        return;
    }
    char buf[22];
    int i = 0;
    while (num > 0) {
        buf[i++] = (num % 10) + '0';
        num /= 10;
    }
    while (i > 0) {
        uart_putchar(buf[--i]);
    }
}

// 64-bit Cycle Counting for RV32
static inline uint64_t read_cycle64(void)
{
    uint32_t hi0, lo, hi1;

    do {
        __asm__ volatile ("rdcycleh %0" : "=r"(hi0));
        __asm__ volatile ("rdcycle  %0" : "=r"(lo));
        __asm__ volatile ("rdcycleh %0" : "=r"(hi1));
    } while (hi0 != hi1);

    return ((uint64_t)hi0 << 32) | lo;
}

// Falcon Core Test
static int test_falcon(void)
{
    int ret;
    uint64_t start_cycles, end_cycles;

    // Initialize PRNG 
    shake256_context rng;
    shake256_init_prng_from_system(&rng); 

    static __attribute__((aligned(8))) uint8_t tmp[FALCON_MAX_TMP_SIZE]; 
    
    // Key buffers
    static uint8_t privkey[FALCON_PRIVKEY_SIZE(LOGN)];
    static uint8_t pubkey[FALCON_PUBKEY_SIZE(LOGN)];
    
    // Message and Signature buffers
    uint8_t msg[] = "Falcon Hardware-in-the-Loop Test on Hornet";
    size_t msg_len = sizeof(msg);
    static uint8_t sig[FALCON_SIG_COMPRESSED_MAXSIZE(LOGN)];
    size_t sig_len = sizeof(sig);

    // --- KEYGEN ---
    uart_puts("Generating keypair...\r\n");
    start_cycles = read_cycle64();
    ret = falcon_keygen_make(&rng, LOGN, 
                             privkey, sizeof(privkey), 
                             pubkey, sizeof(pubkey), 
                             tmp, sizeof(tmp));
    end_cycles = read_cycle64();
    
    if (ret != 0) {
        uart_puts("ERROR: Keypair generation failed\r\n");
        return -1;
    }
    
    uart_puts(" -> Cycles: ");
    uart_put_uint64(end_cycles - start_cycles);
    uart_puts("\r\n");

    // --- SIGN ---
    uart_puts("Signing message...\r\n");
    sig_len = sizeof(sig); // Reset sig_len in case NTESTS > 1
    start_cycles = read_cycle64();
    ret = falcon_sign_dyn(&rng, sig, &sig_len, FALCON_SIG_COMPRESSED, 
                          privkey, sizeof(privkey), 
                          msg, msg_len, 
                          tmp, sizeof(tmp));
    end_cycles = read_cycle64();
    
    if (ret != 0) {
        uart_puts("ERROR: Signature generation failed\r\n");
        return -1;
    }

    uart_puts(" -> Cycles: ");
    uart_put_uint64(end_cycles - start_cycles);
    uart_puts("\r\n");
    
    // --- VERIFY ---
    uart_puts("Verifying message...\r\n");
    start_cycles = read_cycle64();
    ret = falcon_verify(sig, sig_len, FALCON_SIG_COMPRESSED, 
                        pubkey, sizeof(pubkey), 
                        msg, msg_len, 
                        tmp, sizeof(tmp));
    end_cycles = read_cycle64();

    if(ret != 0) {
        uart_puts("ERROR: Verification failed\r\n");
        return -1;
    }
    
    uart_puts(" -> Cycles: ");
    uart_put_uint64(end_cycles - start_cycles);
    uart_puts("\r\n");
    uart_puts("Signature valid and messages match.\r\n");

    // --- FORGERY TEST ---
    uart_puts("Testing trivial forgeries...\r\n");
    sig[0] ^= 1; // Flip a bit in the signature
    ret = falcon_verify(sig, sig_len, FALCON_SIG_COMPRESSED, 
                        pubkey, sizeof(pubkey), 
                        msg, msg_len, 
                        tmp, sizeof(tmp));
    
    if(ret == 0) {
        uart_puts("ERROR: Trivial forgeries possible\r\n");
        return -1;
    }
    uart_puts("Forged signatures rejected correctly.\r\n");

    return 0;
}

// Main
int main(void) {
    // Initialize Interrupts and UART
    SET_MTVEC_VECTOR_MODE();
    uart_init(&uart0, (uint32_t *) 0x10008010);

    uart_puts("\r\nFPGA: HORNET UART INITIALIZED. Waiting for trigger...\r\n");

    // Block until the Python script sends the 'c' trigger byte
    while (uart_getchar() != 'c');

    unsigned int i;
    int r = 0;

    uart_puts("\r\n===============================\r\n");
    uart_puts("Falcon Digital Signature FPGA Hardware Test\r\n");
    uart_puts("===============================\r\n");

    for(i = 0; i < NTESTS; i++) {
        uart_puts("--- Running Test Iteration ");
        uart_put_uint32(i + 1);
        uart_puts(" ---\r\n");

        r |= test_falcon();
        
        if(r) {
            uart_puts("\r\nTEST FAILED\r\n");
            while(1) { __asm__ volatile ("nop"); }
        }
    }

    uart_puts("\r\nALL TESTS PASSED\r\n");

    uart_puts("FALCON_PRIVKEY_SIZE = ");
    uart_put_uint32(FALCON_PRIVKEY_SIZE(LOGN));
    uart_puts("\r\nFALCON_PUBKEY_SIZE = ");
    uart_put_uint32(FALCON_PUBKEY_SIZE(LOGN));
    uart_puts("\r\n");

    // Trap the CPU to prevent executing junk memory
    while(1) { 
        __asm__ volatile ("nop"); 
    }

    return 0;
}

// INTERRUPT HANDLERS
void mti_handler() {}
void exc_handler() {}
void mei_handler() {}
void msi_handler() {}
void fast_irq1_handler() {}