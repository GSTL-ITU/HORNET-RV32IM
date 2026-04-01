#include "uart.h"

void uart_init(volatile uart *uart_ptr, volatile uint32_t *base_addr)
{
    uart_ptr->base_addr = base_addr;

    /* Reset TX and RX FIFOs, polling mode */
    *((volatile uint32_t *)(0x1000900C)) = UART_CTRL_RST_TX | UART_CTRL_RST_RX;
    __asm__ volatile("nop");
    __asm__ volatile("nop");
    /* Enable RX interrupt */
    *((volatile uint32_t *)(0x1000900C)) |= 1u << 4;
}

void uart_transmit_byte(uart *uart_ptr, uint8_t data)
{
    /* Wait until TX FIFO is not full */
    while ( (*((volatile uint32_t *)(0x10009008)) & UART_STAT_TXFULL) != 0u ) {
    }
    *((uint32_t *)(0x10009004)) = (uint32_t)data;
}

void uart_transmit_string(uart *uart_ptr, const char *data, size_t len)
{
    size_t i;
    for (i = 0; i < len; i++) {
        __asm__ volatile("nop");
        __asm__ volatile("nop");
        uart_transmit_byte(uart_ptr, (uint8_t)data[i]);
    }
}