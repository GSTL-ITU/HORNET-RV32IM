#include "uart.h"
#include "aes.h"
#include "irq.h"
#define ECB 1
#include <stdint.h>
volatile int count;
volatile uint8_t input_array[16] = {0};
volatile uint8_t key[16] = {0};
uart uart0;
int main()
{
    SET_MTVEC_VECTOR_MODE();
    ENABLE_GLOBAL_IRQ();
    ENABLE_FAST_IRQ(0);
    // ENABLE_MEI();
    volatile char *addr_ptr = (char*) 0x10008020;
	count = 0;
//	uint8_t key[] = { 0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c };
	struct AES_ctx ctx;
    //AES_init_ctx(&ctx, key);
    
    uart_init(&uart0,(uint32_t *) 0x10009000);
    
    while(1)
    {
        ///////// UART RX

        ENABLE_GLOBAL_IRQ();
        ENABLE_FAST_IRQ(0);
        
        while(count<32) continue;
        AES_init_ctx(&ctx, key);

        *addr_ptr = 1; ////Trigger
        AES_ECB_encrypt(&ctx, input_array);
        *addr_ptr = 0;
        uart_transmit_string(&uart0,input_array,16);
        count = 0;
    }
}

void mti_handler() {}
void exc_handler() {}
void mei_handler() {}
void msi_handler() {}
void fast_irq0_handler()
{
    if ((uint8_t)(0x1) & (*(volatile uint8_t*)(0x10009008))){
        char count_copy = count;
        char rx_byte = *(volatile char*)(0x10009000);
        //uart_transmit_byte(&uart0, rx_byte);
        if(count_copy<16) {
        input_array[count_copy]=rx_byte;
        }
        else if(count_copy<32){
        key[count_copy-16]=rx_byte;
        }

        if(count_copy<32) count++;
        else DISABLE_GLOBAL_IRQ();
    }
}

void fast_irq1_handler() {}