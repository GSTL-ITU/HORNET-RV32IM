#include <stdint.h>
#include "uart.h"
#include "irq.h"

#define GPIO_ADDR   0x10008020
#define UART_BASE   0x10009000

static uart uart0;

static int int_to_str(int value, char *buf)
{
    char temp[12];
    int i = 0;
    int j = 0;

    if (value == 0) {
        buf[0] = '0';
        return 1;
    }

    while (value > 0) {
        temp[i++] = (char)('0' + (value % 10));
        value /= 10;
    }

    while (i > 0) {
        buf[j++] = temp[--i];
    }

    return j;
}

static int build_counter_msg(char *buf, int counter)
{
    const char prefix[] = "Counter: ";
    int i = 0;
    int len = 0;

    while (prefix[i] != '\0') {
        buf[len++] = prefix[i++];
    }

    len += int_to_str(counter, &buf[len]);

    buf[len++] = '\r';
    buf[len++] = '\n';

    return len;
}

int main(void)
{
    volatile uint32_t *gpio = (volatile uint32_t *)GPIO_ADDR;
    int i = 0;
    char init_msg[] = "Boot OK\r\n";
    int counter = 0;
    char counter_str[24];
    int msg_len;

    uart_init(&uart0, (uint32_t *)UART_BASE);
    uart_transmit_string(&uart0, init_msg, sizeof(init_msg) - 1);
    *gpio = 1;

    while (1) {
        *gpio = 1;
        //uart_transmit_string(&uart0, "Hello, World!", 12);

        counter++;
        msg_len = build_counter_msg(counter_str, counter);
        uart_transmit_string(&uart0, counter_str, msg_len);

        for (i = 0; i < 1000000; i++) { //1000000
            __asm__ volatile("nop");
        }

        *gpio = 0;
        for (i = 0; i < 1000000; i++) {
            __asm__ volatile("nop");
        }
    }

    return 0;
}


// -------------------------------------------------------------
// INTERRUPT HANDLERS
// -------------------------------------------------------------

void mti_handler() {}
void exc_handler() {}
void mei_handler() {}
void msi_handler() {}

void fast_irq0_handler()
{
    /*
    char *rx_ptr = (char*)(uart0.base_addr) + UART_RX_FIFO;
    char rx_byte = *rx_ptr;

    rx_var.bytes[count % 4] = rx_byte;
    input_array[count / 4] = rx_var.f;

    if (count < TOTAL_BYTES_TO_RECEIVE) {
        count++;
    } else {
        DISABLE_GLOBAL_IRQ();
    }
    */
}

void fast_irq1_handler() {}