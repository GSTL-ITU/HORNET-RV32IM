CC32=riscv32-unknown-elf
CCFLAGS=-march=rv32im -mabi=ilp32 -mstrict-align -malign-data=xlen -O3 -fno-math-errno -T ../../../linksc.ld -lm -nostartfiles -ffunction-sections -fdata-sections -Wl,--gc-sections -o inference_light.elf



build:
	$(CC32)-gcc inference_light.c ../../../drivers/uart/uart.c ../../../drivers/common/irq.c ../../../crt0.s $(CCFLAGS)
	$(CC32)-objcopy -O binary -j .init -j .text -j .rodata -j .sdata inference_light.elf inference_light.bin
	../../../rom_generator inference_light.bin
	cp inference_light.data memory_init.mem


comp:
	gcc inference_light.c -lm -o inference_light