# Dilithium (ML-DSA) PQC for RISC-V Bare-Metal (Hornet)

This repository contains the ongoing work to port and test the ML-DSA (Dilithium) Post-Quantum Cryptography (PQC) digital signature algorithm on a custom RISC-V architecture. The project specifically targets a resource-constrained, bare-metal embedded environment and FPGA hardware implementation.

## Architecture & Hardware Context

The software in this repository is designed to run on **Hornet**, a custom RISC-V soft core.
* **Target Processor:** [HORNET-RV32IM](https://github.com/GSTL-ITU/HORNET-RV32IM)
* **Execution Environment:** Bare-metal (No OS) / FPGA
* **Compilation:** `riscv32-unknown-elf-gcc` (`-march=rv32im_zicsr -mabi=ilp32`)

## Acknowledgements & Source Material

The cryptographic source code in this repository is adapted from the official Dilithium reference implementation. 
* **Official Dilithium Project:** [https://pq-crystals.org/dilithium/](https://pq-crystals.org/dilithium/)

The codebase has been modified to support deterministic testing in bare-metal simulation and FPGA environments. OS-dependent entropy sources (`/dev/urandom`) and standard C library I/O dependencies (`stdio.h`, `printf`) have been stripped and replaced with custom bare-metal MMIO UART debugging and a deterministic SHAKE256 PRNG.

## Dilithium Parameters (Mode 2)

The current implementation tests the following parameter set sizes:
* **Public Key Size:** 1312 bytes
* **Secret Key Size:** 2560 bytes
* **Signature Size:** 2420 bytes 

## Repository Structure
```text
.
├── gcc/
│   ├── avx2/            # Native x86 AVX2 implementation (Ignored for bare-metal/FPGA)
│   ├── ref/             # Standard C reference implementation
│   └── profiling/       # Profiling tests (Gprof reports for ref and avx2)
└── riscv-hornet/        # Modified bare-metal implementation for the Hornet core
    ├── test/          
    │   ├── hornet_dilithium.c       # Main simulation test harness
    │   ├── hornet_dilithium_fpga.c  # FPGA test harness with UART & IRQ support
    │   ├── uart_monitor.py          # Python script for serial communication & triggering
    │   ├── linksc.ld                # Custom Hornet memory linker script
    │   └── Makefile                 # Toolchain build script (sim, fpga_O0, fpga_O3)
    ├── rom_gen/                     # Utilities for generating FPGA memory initialization files
    ├── randombytes.c                # Custom bare-metal deterministic SHAKE256 PRNG
    └── [Core Dilithium Source]      # sign, ntt, poly, packing, fips202 (unmodified where possible)
```    

## Current Status: Simulation & FPGA Testing

Testing is currently conducted in two phases:
1. **RTL Simulation:** Validating mathematical correctness and memory footprint using Verilator (`hornet_dilithium.c`).
2. **FPGA Hardware Execution:** Running the compiled binaries directly on the FPGA utilizing interrupts and UART communication (`hornet_dilithium_fpga.c` driven by `uart_monitor.py`).

### Hardware Cycle Analysis (mcycle)

Clock cycles for cryptographic operations are measured directly on the hardware using the standard 64-bit RISC-V `mcycle` and `mcycleh` Control and Status Registers (CSRs).

It was tested on Nexys Video with 25 MHz Hornet using UART and `pyserial`.

| Operation | O0 Optimization (Cycles) | O3 Optimization (Cycles) |
| :--- | :--- | :--- |
| **Keypair Generation** | 9,327,292 | 3,252,472 |
| **Signing Message** | 58,159,031 | 20,718,384 |
| **Verifying Signature** | 10,200,050 | 3,570,390 |

## Profiling

There is a Makefile script included in the `gcc/profiling` directory for profiling Dilithium using [Gprof](https://ftp.gnu.org/old-gnu/Manuals/gprof-2.9.1/html_mono/gprof.html).
Running the `make` command inside that directory will generate detailed profiling reports for the reference and AVX2 implementations (all parameters included).