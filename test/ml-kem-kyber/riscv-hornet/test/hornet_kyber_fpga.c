#include <stddef.h>
#include <stdint.h>

// Kyber includes
#include "../kem.h"
#include "../randombytes.h"

// Drivers
#include "../../../../drivers/uart/uart.h"
#include "../../../../drivers/common/irq.h"

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
    // Read the byte from the UART's receive register
    char *rx_ptr = (char*)(uart0.base_addr) + UART_RX_ADDR_OFFSET;
    rx_char = *rx_ptr;
    rx_ready = 1;
    
    // Disable interrupts INSIDE the ISR, exactly like the working MLP example
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

// Rewritten without strlen() to avoid bare-metal libc traps
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

// New 64-bit print helper for cycle counts
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

// Kyber Tests
static int test_keys(void)
{
    uint8_t pk[CRYPTO_PUBLICKEYBYTES];
    uint8_t sk[CRYPTO_SECRETKEYBYTES];
    uint8_t ct[CRYPTO_CIPHERTEXTBYTES];
    uint8_t key_a[CRYPTO_BYTES];
    uint8_t key_b[CRYPTO_BYTES];
    
    uint64_t start_cycles, end_cycles;

    uart_puts("Generating keypair...\r\n");
    start_cycles = read_cycle64();
    crypto_kem_keypair(pk, sk);
    end_cycles = read_cycle64();
    uart_puts("-> Cycles: ");
    uart_put_uint64(end_cycles - start_cycles);
    uart_puts("\r\n");

    uart_puts("Encapsulating secret...\r\n");
    start_cycles = read_cycle64();
    crypto_kem_enc(ct, key_b, pk);
    end_cycles = read_cycle64();
    uart_puts("-> Cycles: ");
    uart_put_uint64(end_cycles - start_cycles);
    uart_puts("\r\n");

    uart_puts("Decapsulating secret...\r\n");
    start_cycles = read_cycle64();
    crypto_kem_dec(key_a, ct, sk);
    end_cycles = read_cycle64();
    uart_puts("-> Cycles: ");
    uart_put_uint64(end_cycles - start_cycles);
    uart_puts("\r\n");

    // Standard bare-metal loop to avoid memcmp libc traps
    for(size_t j = 0; j < CRYPTO_BYTES; j++) {
        if(key_a[j] != key_b[j]) {
            uart_puts("ERROR: Shared secrets do not match!\r\n");
            return 1; 
        }
    }
    
    uart_puts("Shared secrets match.\r\n");
    return 0; 
}

static int test_invalid_sk_a(void)
{
    uint8_t pk[CRYPTO_PUBLICKEYBYTES];
    uint8_t sk[CRYPTO_SECRETKEYBYTES];
    uint8_t ct[CRYPTO_CIPHERTEXTBYTES];
    uint8_t key_a[CRYPTO_BYTES];
    uint8_t key_b[CRYPTO_BYTES];
    int match = 1;

    crypto_kem_keypair(pk, sk);
    crypto_kem_enc(ct, key_b, pk);

    randombytes(sk, CRYPTO_SECRETKEYBYTES);
    crypto_kem_dec(key_a, ct, sk);

    for(size_t j = 0; j < CRYPTO_BYTES; j++) {
        if(key_a[j] != key_b[j]) {
            match = 0; 
            break;
        }
    }

    if(match) {
        uart_puts("ERROR: Decapsulation succeeded with invalid secret key!\r\n");
        return 1;
    }

    uart_puts("Invalid secret key rejected correctly.\r\n");
    return 0;
}

static int test_invalid_ciphertext(void)
{
    uint8_t pk[CRYPTO_PUBLICKEYBYTES];
    uint8_t sk[CRYPTO_SECRETKEYBYTES];
    uint8_t ct[CRYPTO_CIPHERTEXTBYTES];
    uint8_t key_a[CRYPTO_BYTES];
    uint8_t key_b[CRYPTO_BYTES];
    uint8_t b;
    size_t pos;
    int match = 1;

    do {
        randombytes(&b, sizeof(uint8_t));
    } while(!b);
    randombytes((uint8_t *)&pos, sizeof(size_t));

    crypto_kem_keypair(pk, sk);
    crypto_kem_enc(ct, key_b, pk);

    ct[pos % CRYPTO_CIPHERTEXTBYTES] ^= b;
    crypto_kem_dec(key_a, ct, sk);

    for(size_t j = 0; j < CRYPTO_BYTES; j++) {
        if(key_a[j] != key_b[j]) {
            match = 0; 
            break;
        }
    }

    if(match) {
        uart_puts("ERROR: Decapsulation succeeded with corrupted ciphertext!\r\n");
        return 1;
    }

    uart_puts("Invalid ciphertext rejected correctly.\r\n");
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
    uart_puts("Kyber KEM FPGA Hardware Test\r\n");
    uart_puts("===============================\r\n");

    for(i = 0; i < NTESTS; i++) {
        uart_puts("--- Running Test Iteration ");
        uart_put_uint32(i + 1);
        uart_puts(" ---\r\n");

        r |= test_keys();
        r |= test_invalid_sk_a();
        r |= test_invalid_ciphertext();
        
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
    uart_puts("\r\nCRYPTO_CIPHERTEXTBYTES = ");
    uart_put_uint32(CRYPTO_CIPHERTEXTBYTES);
    uart_puts("\r\nCRYPTO_BYTES = ");
    uart_put_uint32(CRYPTO_BYTES);
    uart_puts("\r\n");

    // Trap the CPU to prevent executing junk memory
    while(1) { 
        __asm__ volatile ("nop"); 
    }

    return 0;
}