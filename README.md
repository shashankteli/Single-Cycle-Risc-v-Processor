# RISC-V Single Cycle RV32I core

This is a Single Cycle processor running the RV32I implementation, hence a 32-bits cpu, written in Verilog.

# Introduction

In the rapidly advancing field of processor architecture, the RISC-V instruction set has become a significant player, offering an open-source, scalable, and modular alternative. This project aims to explore and implement a RISC-V single-cycle processor, designed with a focus on simplicity and efficiency.

# Objectives

The main objective of this project is to design and implement a RISC-V single-cycle processor. By utilizing the principles of simplicity and modularity that RISC-V is known for, the processor is intended to execute a broad set of instructions within a single clock cycle. Additionally, the project employs rigorous validation processes using open-source tools to ensure the accuracy and reliability of the processor design.

# Project Scope

The scope of this project goes beyond traditional processor design. It involves creating a RISC-V single-cycle processor, carefully selecting a set of instructions to maximize performance, and applying thorough verification techniques. By combining the robust architecture of RISC-V with comprehensive validation methods, this project aims to contribute to the evolution of processor architectures and verification standards.

# RISC-V ISA (Instruction Set Architecture)

The RISC-V ISA (Instruction Set Architecture) is designed to be modular and extensible,enabling flexibility and customization across various computing environments. The base integer ISA, referred to as RV32I (for 32-bit systems) or RV64I (for 64-bit systems), provides a minimal set of essential instructions. Additional standard extensions can be added to this
base ISA to enhance functionality. Below is an overview of the main components of the RISC-V ISA:

# Base Integer ISA (RV32I and RV64I)

## Integer Registers:

* RV32I includes 32 general-purpose integer registers, while RV64I includes 64.
  
* Register x0 is hardwired to zero and always holds the value zero.

## Data Types:

* Supports 8, 16, 32, and 64-bit integer data types.

## Intructions:

* Provides basic integer operations, load and store instructions, conditional branches, and jumps.
* Includes arithmetic and logic instructions (such as add, subtract, AND, OR, XOR, and shift operations).
* Load and store instructions are available for accessing memory.

## Control Flow:

* Supports conditional branches based on register values.

* Includes unconditional jumps using the JAL (Jump and Link) and JALR(Jump and Link Register) instructions.

## Immediate Values:

* Immediate values can be used as operands in various instructions, allowing for more efficient code.

## Synthesis

![image alt](https://github.com/shashankteli/Single-Cycle-Risc-v-Processor/blob/4e20408cf7ffc4dfdb6076c3b46cd40447f6f88f/Synthesis%20of%20top%20module.jpeg)

## Simulation Results 

![image alt](https://github.com/shashankteli/Single-Cycle-Risc-v-Processor/blob/762880b6d4030e2882e82f2a80afe42ac0105fa3/Simulation%20Results.jpeg)
  
