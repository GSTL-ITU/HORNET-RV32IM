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

// Global UART instance
uart uart0;

// UART Helpers
void uart_putchar(char c) {
    uart_transmit_byte(&uart0, (uint8_t)c);
}

// Interrupt-driven getchar relying on your fast_irq0 setup
volatile char rx_char = 0;
volatile int rx_ready = 0;

void fast_irq0_handler() {
    // Read the byte from the UART's receive register (clears the interrupt)
    char *rx_ptr = (char*)(uart0.base_addr) + UART_RX_ADDR_OFFSET;
    rx_char = *rx_ptr;
    rx_ready = 1;
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
    
    // Disable interrupts again so execution isn't preempted
    DISABLE_FAST_IRQ(0);
    DISABLE_GLOBAL_IRQ();
    
    return rx_char;
}

void uart_puts(const char* str) {
    // We can use your driver's string transmit function directly
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

// Cycle Counting 
static inline uint32_t get_cycles(void) {
    uint32_t cycles;
    __asm__ volatile ("csrr %0, mcycle" : "=r" (cycles));
    return cycles;
}

// Falcon Tests
static int test_falcon(void)
{
    // Deterministic PRNG
    shake256_context rng;
    shake256_init_prng_from_system(&rng); 

    // Allocate memory sizes
    size_t tmp_size = FALCON_TMPSIZE_KEYGEN(LOGN);
    if (FALCON_TMPSIZE_SIGNDYN(LOGN) > tmp_size) {
        tmp_size = FALCON_TMPSIZE_SIGNDYN(LOGN);
    }
    
    // Force 8-byte alignment for RISC-V floating-point emulation buffers
    __attribute__((aligned(8))) uint8_t tmp[tmp_size];
    uint8_t privkey[FALCON_PRIVKEY_SIZE(LOGN)];
    uint8_t pubkey[FALCON_PUBKEY_SIZE(LOGN)];
    
    uint32_t start_cycles, end_cycles;

    uart_puts("Generating keypair (FN-512)...\r\n");
    start_cycles = get_cycles();
    int result = falcon_keygen_make(&rng, LOGN, privkey, sizeof(privkey), 
                                    pubkey, sizeof(pubkey), tmp, tmp_size);
    end_cycles = get_cycles();
    uart_puts("-> Cycles: ");
    uart_put_uint32(end_cycles - start_cycles);
    uart_puts("\r\n");

    if (result != 0) {
        uart_puts("ERROR: Key generation failed!\r\n");
        return 1;
    }

    uart_puts("Keypair generated successfully.\r\n");
    return 0;
}

// Main
int main(void) {
    // Initialize Interrupts and UART
    SET_MTVEC_VECTOR_MODE();
    uart_init(&uart0, (uint32_t *) 0x10008010);

    uart_puts("FPGA: HORNET UART INITIALIZED. Waiting for trigger...\r\n");

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

    uart_puts("ALL TESTS PASSED\r\n");

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