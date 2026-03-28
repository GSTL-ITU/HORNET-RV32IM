#define GPIO_ADDR 0x10008020

int main()
{
    volatile unsigned int *gpio = (unsigned int *)GPIO_ADDR;
    int i = 0;
    while (1) {
        *gpio = 1;   // LED ON
        for (i = 0; i < 1000000; i++) {
        __asm__ volatile("nop");
        }

        *gpio = 0;   // LED OFF
        for (i = 0; i < 1000000; i++) {
        __asm__ volatile("nop");
        }
    }

    return 0;
}