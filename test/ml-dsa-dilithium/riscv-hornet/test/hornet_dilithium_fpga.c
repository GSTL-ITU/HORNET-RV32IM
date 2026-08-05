#include <stddef.h>
#include <stdint.h>
#include <string.h>

// Dilithium includes
#include "../randombytes.h"
#include "../sign.h"

// Drivers
#include "../../../../drivers/uart/uart.h"
#include "../../../../drivers/common/irq.h"

#define MLEN 59
#define CTXLEN 14
#define NTESTS 1

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
    uart_transmit_string(&uart0, str, strlen(str));
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

// Dilithium Tests
static int test_dilithium(void)
{
    size_t j;
    int ret;
    size_t mlen, smlen;
    uint8_t b;
    uint8_t ctx[CTXLEN] = {0};
    uint8_t m[MLEN + CRYPTO_BYTES];
    uint8_t m2[MLEN + CRYPTO_BYTES];
    uint8_t sm[MLEN + CRYPTO_BYTES];
    uint8_t pk[CRYPTO_PUBLICKEYBYTES];
    uint8_t sk[CRYPTO_SECRETKEYBYTES];
    
    uint32_t start_cycles, end_cycles;

    randombytes(m, MLEN);

    uart_puts("Generating keypair...\r\n");
    start_cycles = get_cycles();
    crypto_sign_keypair(pk, sk);
    end_cycles = get_cycles();
    uart_puts("-> Cycles: ");
    uart_put_uint32(end_cycles - start_cycles);
    uart_puts("\r\n");

    uart_puts("Signing message...\r\n");
    start_cycles = get_cycles();
    crypto_sign(sm, &smlen, m, MLEN, ctx, CTXLEN, sk);
    end_cycles = get_cycles();
    uart_puts("-> Cycles: ");
    uart_put_uint32(end_cycles - start_cycles);
    uart_puts("\r\n");

    uart_puts("Verifying signature...\r\n");
    start_cycles = get_cycles();
    ret = crypto_sign_open(m2, &mlen, sm, smlen, ctx, CTXLEN, pk);
    end_cycles = get_cycles();
    uart_puts("-> Cycles: ");
    uart_put_uint32(end_cycles - start_cycles);
    uart_puts("\r\n");

    if(ret) {
        uart_puts("ERROR: Verification failed!\r\n");
        return 1;
    }
    if(smlen != MLEN + CRYPTO_BYTES) {
        uart_puts("ERROR: Signed message lengths wrong!\r\n");
        return 1;
    }
    if(mlen != MLEN) {
        uart_puts("ERROR: Message lengths wrong!\r\n");
        return 1;
    }
    for(j = 0; j < MLEN; ++j) {
        if(m2[j] != m[j]) {
            uart_puts("ERROR: Messages don't match!\r\n");
            return 1;
        }
    }
    
    uart_puts("Signature verified successfully.\r\n");

    // Test trivial forgeries
    randombytes((uint8_t *)&j, sizeof(j));
    do {
        randombytes(&b, 1);
    } while(!b);
    
    sm[j % (MLEN + CRYPTO_BYTES)] += b;
    ret = crypto_sign_open(m2, &mlen, sm, smlen, ctx, CTXLEN, pk);
    
    if(!ret) {
        uart_puts("ERROR: Trivial forgery succeeded!\r\n");
        return 1;
    }

    uart_puts("Invalid signature (forgery) rejected correctly.\r\n");
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
    uart_puts("Dilithium Digital Signature FPGA Hardware Test\r\n");
    uart_puts("===============================\r\n");

    for(i = 0; i < NTESTS; i++) {
        uart_puts("--- Running Test Iteration ");
        uart_put_uint32(i + 1);
        uart_puts(" ---\r\n");

        r |= test_dilithium();
        
        if(r) {
            uart_puts("\r\nTEST FAILED\r\n");
            while(1) { __asm__ volatile ("nop"); }
        }
    }

    uart_puts("ALL TESTS PASSED\r\n");

    uart_puts("CRYPTO_PUBLICKEYBYTES = ");
    uart_put_uint32(CRYPTO_PUBLICKEYBYTES);
    uart_puts("\r\nCRYPTO_SECRETKEYBYTES = ");
    uart_put_uint32(CRYPTO_SECRETKEYBYTES);
    uart_puts("\r\nCRYPTO_BYTES = ");
    uart_put_uint32(CRYPTO_BYTES);
    uart_puts("\r\n");

    // Trap the CPU to prevent executing junk memory
    while(1) { 
        __asm__ volatile ("nop"); 
    }

    return 0;
}