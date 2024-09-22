# 8-bit-Single-Cycle-Processor

In this project, I designed and implemented a simple 8-bit single-cycle processor as part of an academic course. The primary goal was to deepen my understanding of computer architecture through practical hands-on experience, using Verilog HDL to build the processor from the ground up.

## What the Project Involved:
Arithmetic Logic Unit (ALU): Designed an 8-bit ALU capable of performing basic arithmetic (add, sub) and logical (and, or, mov, loadi) operations.<br>
Register File: Implemented an 8×8 register file for efficient data storage and retrieval.<br>
Control Logic: Developed control logic to manage the flow of instructions and integrate the ALU and register file into a fully functional CPU.<br>
New Instructions: Extended the processor's functionality to support flow control instructions (j, beq) and memory access instructions (lwd, swd).<br>

To enhance the processor’s performance, I further implemented a memory hierarchy, including:<br>

Data Memory: A 256-byte memory module with a latency of 5 clock cycles.<br>
Data Cache: A direct-mapped cache to reduce memory access times, with parameters like a 32-byte size and 4-byte block size.<br>
Instruction Cache: Added an instruction cache to optimize instruction fetching, with a 128-byte size and 16-byte block size.<br>

## Results:
The processor successfully executed a predefined set of instructions within a single cycle, and the memory hierarchy significantly improved overall performance by reducing access time.<br>
The project concluded with a detailed performance comparison between the processor with and without the implemented caches, demonstrating the efficiency of the caching mechanism.

### Contributors
Ishan Kumarasinghe, e20211@eng.pdn.ac.lk<br>
Dasuni Kawya, e20197@eng.pdn.ac.lk
