# RISCV CPU

## Overview

This project is designed to achieve a simple RISCV cpu.

## Installation

To install this project, follow these steps:

1. Clone the repository:

   ```sh
   git clone https://github.com/ic-fucker/CPU.git
   ```

2. Navigate to the project directory:

   ```sh
   cd 1.0.0
   ```

3. Simulation:

   ```sh
   make sim
   ```

4. Visualize Sim:

   ```sh
   gtkwave ./build/wave.vcd
   ```

5. Dependence:

   iverilog

## Project Tree

    1.0.0/
    ├─ defines.v
    ├─ ex.v
    ├─ ex_wb.v
    ├─ id.v
    ├─ id_ex.v
    ├─ if_id.v
    ├─ inst_rom.v
    ├─ pc.v
    ├─ regfile.v
    ├─ RISC_V_top.v
    ├─ riscv_tb.v
    ├─ wb.v
    │
    │
    ├── build/
    │   ├── a.out
    │   └── wave.vcd
    │   ...
    │
    ├── Makefile
    │
    └── README.md

## Screenshot

![运行截图](./screenshot/2025-03-14.png "addi instru test")

