CC32=riscv32-unknown-elf
TARGET_SIM=sim_dilithium
TARGET_FPGA_O0=fpga_dilithium_O0
TARGET_FPGA_O3=fpga_dilithium_O3

# Base flags without optimization levels
# Included -DDILITHIUM_MODE=2 to match your previous Dilithium setup
BASE_FLAGS=-march=rv32im_zicsr -mabi=ilp32 -mstrict-align -malign-data=xlen -fno-math-errno -T ./linksc.ld -nostartfiles -ffunction-sections -fdata-sections -Wl,--gc-sections -DDILITHIUM_MODE=2

# Include paths for Dilithium and Drivers
INCLUDES=-I../ -I../../../../drivers/common -I../../../../drivers/uart

CCFLAGS=$(BASE_FLAGS) $(INCLUDES)

# Sources
DILITHIUM_SRC = ../sign.c ../packing.c ../polyvec.c ../poly.c ../ntt.c ../reduce.c ../rounding.c ../randombytes.c ../fips202.c ../symmetric-shake.c
DRIVER_SRC = ../../../../drivers/common/irq.c ../../../../drivers/uart/uart.c
STARTUP_SRC = ../../../../crt0.s
ROM_GEN = ../../../../rom_generator

build: sim fpga_O0 fpga_O3

# Simulation Target (O3)
sim:
	$(CC32)-gcc hornet_dilithium.c $(DILITHIUM_SRC) $(DRIVER_SRC) $(STARTUP_SRC) $(CCFLAGS) -O3 -o $(TARGET_SIM).elf
	$(CC32)-objcopy -O binary -j .init -j .text -j .rodata $(TARGET_SIM).elf $(TARGET_SIM).bin
	$(ROM_GEN) $(TARGET_SIM).bin
	cp $(TARGET_SIM).data memory_init_tb.mem

# FPGA Target (O0)
fpga_O0:
	$(CC32)-gcc hornet_dilithium_fpga.c $(DILITHIUM_SRC) $(DRIVER_SRC) $(STARTUP_SRC) $(CCFLAGS) -O0 -o $(TARGET_FPGA_O0).elf
	$(CC32)-objcopy -O binary -j .init -j .text -j .rodata $(TARGET_FPGA_O0).elf $(TARGET_FPGA_O0).bin
	$(ROM_GEN) $(TARGET_FPGA_O0).bin
	cp $(TARGET_FPGA_O0).data $(TARGET_FPGA_O0).mem

# FPGA Target (O3)
fpga_O3:
	$(CC32)-gcc hornet_dilithium_fpga.c $(DILITHIUM_SRC) $(DRIVER_SRC) $(STARTUP_SRC) $(CCFLAGS) -O3 -o $(TARGET_FPGA_O3).elf
	$(CC32)-objcopy -O binary -j .init -j .text -j .rodata $(TARGET_FPGA_O3).elf $(TARGET_FPGA_O3).bin
	$(ROM_GEN) $(TARGET_FPGA_O3).bin
	cp $(TARGET_FPGA_O3).data $(TARGET_FPGA_O3).mem

clean:
	rm -f *.elf *.bin *.data *.mem memory_init_tb.mem