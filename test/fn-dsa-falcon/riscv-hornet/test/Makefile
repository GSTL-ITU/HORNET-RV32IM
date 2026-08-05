CC32=riscv32-unknown-elf
TARGET_SIM=sim_falcon
TARGET_FPGA_O0=fpga_falcon_O0
TARGET_FPGA_O3=fpga_falcon_O3

# Base flags WITHOUT hardware floating point support (rv32im / ilp32) and zicsr for mcycle
BASE_FLAGS=-march=rv32im_zicsr -mabi=ilp32 -ffp-contract=off -mstrict-align -malign-data=xlen -fno-math-errno -T ./linksc.ld -nostartfiles -ffunction-sections -fdata-sections -Wl,--gc-sections

# Include paths for Falcon and Drivers
INCLUDES=-I../src -I../../../../drivers/common -I../../../../drivers/uart

CCFLAGS=$(BASE_FLAGS) $(INCLUDES)

# Sources
FALCON_SRC = ../src/codec.c ../src/common.c ../src/falcon.c ../src/fft.c ../src/fpr.c ../src/keygen.c ../src/rng.c ../src/shake.c ../src/sign.c ../src/vrfy.c
DRIVER_SRC = ../../../../drivers/common/irq.c ../../../../drivers/uart/uart.c
STARTUP_SRC = ../rom_gen/crt0.s
ROM_GEN = ../rom_gen/rom_generator

build: sim fpga_O0 fpga_O3

# Simulation Target (O3)
sim:
	$(CC32)-gcc hornet_keygen.c $(FALCON_SRC) $(DRIVER_SRC) $(STARTUP_SRC) $(CCFLAGS) -O3 -o $(TARGET_SIM).elf
	$(CC32)-objcopy -O binary -j .init -j .text -j .rodata -j .sdata $(TARGET_SIM).elf $(TARGET_SIM).bin
	$(ROM_GEN) $(TARGET_SIM).bin
	cp $(TARGET_SIM).data memory_init_tb.mem

# FPGA Target (O0)
fpga_O0:
	$(CC32)-gcc hornet_falcon_fpga.c $(FALCON_SRC) $(DRIVER_SRC) $(STARTUP_SRC) $(CCFLAGS) -O0 -o $(TARGET_FPGA_O0).elf
	$(CC32)-objcopy -O binary -j .init -j .text -j .rodata -j .sdata $(TARGET_FPGA_O0).elf $(TARGET_FPGA_O0).bin
	$(ROM_GEN) $(TARGET_FPGA_O0).bin
	cp $(TARGET_FPGA_O0).data $(TARGET_FPGA_O0).mem

# FPGA Target (O3)
fpga_O3:
	$(CC32)-gcc hornet_falcon_fpga.c $(FALCON_SRC) $(DRIVER_SRC) $(STARTUP_SRC) $(CCFLAGS) -O3 -o $(TARGET_FPGA_O3).elf
	$(CC32)-objcopy -O binary -j .init -j .text -j .rodata -j .sdata $(TARGET_FPGA_O3).elf $(TARGET_FPGA_O3).bin
	$(ROM_GEN) $(TARGET_FPGA_O3).bin
	cp $(TARGET_FPGA_O3).data $(TARGET_FPGA_O3).mem

clean:
	rm -f *.elf *.bin *.data *.mem memory_init_tb.mem