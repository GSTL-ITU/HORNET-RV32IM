#ifndef UART_H
#define UART_H

#include <stdint.h>
#include <stddef.h>

#define UART_RX_FIFO_OFFSET    0x00u
#define UART_TX_FIFO_OFFSET    0x04u
#define UART_STAT_REG_OFFSET   0x08u
#define UART_CTRL_REG_OFFSET   0x0Cu

#define UART_STAT_RXVALID      (1u << 0)
#define UART_STAT_RXFULL       (1u << 1)
#define UART_STAT_TXEMPTY      (1u << 2)
#define UART_STAT_TXFULL       (1u << 3)

#define UART_CTRL_RST_TX       (1u << 0)
#define UART_CTRL_RST_RX       (1u << 1)
#define UART_CTRL_IE           (1u << 4)

typedef struct uart
{
    uint32_t *base_addr;
} uart;

void uart_init(uart *uart_ptr, uint32_t *base_addr);
void uart_transmit_byte(uart *uart_ptr, uint8_t data);
void uart_transmit_string(uart *uart_ptr, const char *data, size_t len);

#endif