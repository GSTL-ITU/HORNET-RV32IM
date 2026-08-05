# Kyber (ML-KEM) PQC for RISC-V Bare-Metal (Hornet)

This repository contains the ongoing work to port and test the ML-KEM (Kyber) Post-Quantum Cryptography (PQC) algorithm on a custom RISC-V architecture. The project specifically targets a resource-constrained, bare-metal embedded environment and FPGA hardware implementation.

## Architecture & Hardware Context

The software in this repository is designed to run on **Hornet**, a custom RISC-V soft core.
* **Target Processor:** [HORNET-RV32IM](https://github.com/GSTL-ITU/HORNET-RV32IM)
* **Execution Environment:** Bare-metal (No OS) / FPGA
* **Compilation:** `riscv32-unknown-elf-gcc` (`-march=rv32im_zicsr -mabi=ilp32`)

## Acknowledgements & Source Material

The cryptographic source code in this repository is adapted from the official Kyber reference implementation. 
* **Official Kyber Project:** [https://pq-crystals.org/kyber/](https://pq-crystals.org/kyber/)

The codebase has been modified to support deterministic testing in bare-metal simulation and FPGA environments. OS-dependent entropy sources (`/dev/urandom`) and standard C library I/O dependencies (`stdio.h`, `printf`) have been stripped and replaced with custom bare-metal MMIO UART debugging and a deterministic SHAKE256 PRNG.

## Repository Structure

.
├── avx2/             # Native x86 AVX2 implementation (Ignored for bare-metal/FPGA)
├── ref/              # Standard C reference implementation
├── profiling/        # Profiling tests (Gprof reports for ref and avx2)
└── riscv-hornet/     # Modified bare-metal implementation for the Hornet core
    ├── test/         
    │   ├── hornet_kyber.c        # Main simulation test harness
    │   ├── hornet_kyber_fpga.c   # FPGA test harness with UART & IRQ support
    │   ├── uart_monitor.py       # Python script for serial communication & triggering
    │   ├── linksc.ld             # Custom Hornet memory linker script
    │   ├── Makefile              # Toolchain build script (sim, fpga_O0, fpga_O3)
    │   └── verilator.sh          # Simulation script targeting barebones_top_tb
    ├── randombytes.c             # Custom bare-metal deterministic SHAKE256 PRNG
    └── [Core Kyber Source]       # indcpa, ntt, poly, kem, fips202 (unmodified where possible)

## Current Status: Simulation & FPGA Testing

Testing is currently conducted in two phases:
1. **RTL Simulation:** Validating mathematical correctness and memory footprint using Verilator (`hornet_kyber.c`).
2. **FPGA Hardware Execution:** Running the compiled binaries directly on the FPGA utilizing interrupts and UART communication (`hornet_kyber_fpga.c` driven by `uart_monitor.py`).

### Hardware Cycle Analysis (mcycle)

Clock cycles for cryptographic operations are measured directly on the hardware using the standard 64-bit RISC-V `mcycle` and `mcycleh` Control and Status Registers (CSRs).

**Current FPGA Execution Metrics (Target: Kyber KEM):**
* **Keypair Generation:** 1,628,037 cycles
* **Encapsulation:** 1,876,904 cycles
* **Decapsulation:** 2,197,007 cycles

### Simulation Cycle Calculation

For Verilator simulation, the testbench (`barebones_top_tb.v`) drives the clock with a half-period toggle delay of `#12.5` ns. This yields a full clock period of **25 ns**, corresponding to a hardware frequency of **40 MHz**. Total cycles in simulation can be derived via:

$$\text{Clock Cycles} = \frac{\text{Total Simulation Time (ns)}}{25 \text{ ns}}$$

## Profiling

There is a Makefile script included for profiling Dilithium/Kyber using [Gprof](https://ftp.gnu.org/old-gnu/Manuals/gprof-2.9.1/html_mono/gprof.html).
Running the command below will generate detailed profiling reports for the reference and AVX2 implementations (all parameters included):

make profile