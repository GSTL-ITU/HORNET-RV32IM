# 🐝 HORNET RV32IM

A **32-bit open-source RISC-V CPU core** implementing the **RV32IM instruction set**, designed with clarity, modularity, and FPGA usability in mind.

> Developed as part of an academic and research effort to provide a **well-documented and accessible RISC-V core**.

---

## 📌 Overview

**HORNET** is a synthesizable RISC-V processor core written in **Verilog HDL**, supporting:

* RV32I base integer instruction set
* RV32M extension (multiplication & division)
* Machine-mode privileged architecture
* 5-stage pipelined microarchitecture

The project also includes **peripherals, software, and example SoC integrations** to help you get started quickly. ([GitHub][1])

---

## ✨ Features

* ✅ RV32IM ISA support
* ⚙️ 5-stage pipeline (IF, ID, EX, MEM, WB)
* 🧠 Machine-mode support (privileged ISA)
* 🔀 Misaligned memory access support
* 🔌 FPGA-proven design
* 🧩 Modular and extensible architecture
* 📚 Accompanied by documentation and examples

---

## 🏗️ Architecture

The HORNET core follows a **classic 5-stage pipeline design**, enabling efficient instruction execution:

1. **Instruction Fetch (IF)**
2. **Instruction Decode (ID)**
3. **Execute (EX)**
4. **Memory Access (MEM)**
5. **Write Back (WB)**

This structure improves throughput by overlapping instruction execution stages, a common design in modern RISC-V cores. ([GitHub CPE][2])

---

## 📂 Repository Structure

```bash
.
├── core/            # Core CPU implementation
├── processor/       # Top-level processor integration
├── peripherals/     # Peripheral modules
├── lib/             # Supporting libraries
├── test/            # Test programs and verification
├── documentation/   # Manuals and design documents
├── LICENSE
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

* Verilog simulator (e.g., **Icarus Verilog**, ModelSim, Verilator)
* RISC-V GNU Toolchain (`riscv32-unknown-elf-gcc`)
* FPGA tools (optional, for synthesis)

---

### 🔧 Build & Simulation

Example (generic flow):

```bash
# Compile test program
riscv32-unknown-elf-gcc -o test.elf test.c

# Convert to binary/hex (if required)
riscv32-unknown-elf-objcopy -O binary test.elf test.bin

# Run simulation (tool-dependent)
make sim
```

> Refer to the `test/` and `documentation/` folders for detailed workflows.

---

## 🧪 Testing

The project includes:

* Sample C programs
* Assembly-level tests
* Simulation infrastructure

These are used to verify correctness of:

* Instruction execution
* Pipeline behavior
* Memory operations

---

## 🧩 System Integration

HORNET is designed to be easily integrated into:

* Custom SoCs
* FPGA platforms
* Educational CPU design projects

The repository provides **example integrations and peripherals** to accelerate development. ([GitHub][1])

---

## 📖 Documentation

Detailed documentation is available in the `documentation/` directory:

* 📘 **Reference Manual** – internal architecture and design decisions
* 📗 **User Guide** – how to use and integrate the core

---

## 🎯 Project Goals

* Provide a **fully open-source RISC-V core**
* Maintain **clarity and readability** in design
* Enable **easy learning and modification**
* Deliver **comprehensive documentation** (a common gap in many cores) ([ITU Web][3])

---

## 🤝 Contributing

Contributions are welcome!

You can help by:

* Reporting bugs
* Improving documentation
* Adding features or optimizations

Please open an issue or submit a pull request.

---

## 📬 Contact

For questions, suggestions, or collaboration:

* 📧 [0yavuz0@gmail.com](mailto:0yavuz0@gmail.com)
* 📧 [yasinxyilmaz@gmail.com](mailto:yasinxyilmaz@gmail.com)

---

## 📜 License

This project is licensed under the **MIT License**.

---

## ⭐ Acknowledgements

* RISC-V open standard and ecosystem
* Academic contributors and researchers
* FPGA and open hardware community

---

## 🔗 Related Work

If you're exploring similar designs:

* Other RV32IM cores (pipelined and single-cycle)
* RISC-V ISA documentation
* FPGA-based CPU implementations