CC32=riscv64-unknown-elf
CCFLAGS=-march=rv32im_zicsr -mabi=ilp32 -ffp-contract=off -mstrict-align -malign-data=xlen -O3 -fno-math-errno -T ../linksc.ld -lm -nostartfiles -ffunction-sections -fdata-sections -Wl,--gc-sections -o led.elf



build:
	$(CC32)-gcc led.c uart.c irq.c ../crt0.s $(CCFLAGS)
	$(CC32)-objcopy -O binary -j .init -j .text -j .rodata -j .sdata led.elf led.bin
	../rom_generator led.bin
	cp led.data memory_init.mem


comp:
	gcc led.c -lm -o led