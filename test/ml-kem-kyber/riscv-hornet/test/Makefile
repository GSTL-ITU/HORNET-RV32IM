CC32=riscv32-unknown-elf
TARGET_SIM=sim_kyber
TARGET_FPGA_O0=fpga_kyber_O0
TARGET_FPGA_O3=fpga_kyber_O3

# Base flags without optimization levels
BASE_FLAGS=-march=rv32im_zicsr -mabi=ilp32 -mstrict-align -malign-data=xlen -fno-math-errno -T ./linksc.ld -nostartfiles -ffunction-sections -fdata-sections -Wl,--gc-sections

# Include paths for Kyber and Drivers
INCLUDES=-I../ -I../../../../drivers/common -I../../../../drivers/uart

CCFLAGS=$(BASE_FLAGS) $(INCLUDES)

# Sources
KYBER_SRC = ../cbd.c ../fips202.c ../indcpa.c ../kem.c ../ntt.c ../poly.c ../polyvec.c ../randombytes.c ../reduce.c ../symmetric-shake.c ../verify.c
DRIVER_SRC = ../../../../drivers/common/irq.c ../../../../drivers/uart/uart.c
STARTUP_SRC = ../../../../crt0.s
ROM_GEN = ../../../../rom_generator

build: sim fpga_O0 fpga_O3

# Simulation Target (O3)
sim:
	$(CC32)-gcc hornet_kyber.c $(KYBER_SRC) $(DRIVER_SRC) $(STARTUP_SRC) $(CCFLAGS) -O3 -o $(TARGET_SIM).elf
	$(CC32)-objcopy -O binary -j .init -j .text -j .rodata -j .sdata $(TARGET_SIM).elf $(TARGET_SIM).bin
	$(ROM_GEN) $(TARGET_SIM).bin
	cp $(TARGET_SIM).data memory_init_tb.mem

# FPGA Target (O0)
fpga_O0:
	$(CC32)-gcc hornet_kyber_fpga.c $(KYBER_SRC) $(DRIVER_SRC) $(STARTUP_SRC) $(CCFLAGS) -O0 -o $(TARGET_FPGA_O0).elf
	$(CC32)-objcopy -O binary -j .init -j .text -j .rodata -j .sdata $(TARGET_FPGA_O0).elf $(TARGET_FPGA_O0).bin
	$(ROM_GEN) $(TARGET_FPGA_O0).bin
	cp $(TARGET_FPGA_O0).data $(TARGET_FPGA_O0).mem

# FPGA Target (O3)
fpga_O3:
	$(CC32)-gcc hornet_kyber_fpga.c $(KYBER_SRC) $(DRIVER_SRC) $(STARTUP_SRC) $(CCFLAGS) -O3 -o $(TARGET_FPGA_O3).elf
	$(CC32)-objcopy -O binary -j .init -j .text -j .rodata -j .sdata $(TARGET_FPGA_O3).elf $(TARGET_FPGA_O3).bin
	$(ROM_GEN) $(TARGET_FPGA_O3).bin
	cp $(TARGET_FPGA_O3).data $(TARGET_FPGA_O3).mem

clean:
	rm -f *.elf *.bin *.data memory_init_tb.mem