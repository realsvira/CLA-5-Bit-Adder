# 5-Bit Carry Look-Ahead Adder: VLSI Design and Implementation

## Project Overview

This project presents a comprehensive implementation of a **5-bit Carry Look-Ahead (CLA) Adder** using 180nm CMOS technology, completed as part of the VLSI Design course at IIIT Hyderabad (Monsoon 2025). The design encompasses the complete VLSI design flow from architectural specification through RTL design, physical layout, post-layout verification, and FPGA implementation.

**Author:** Saumya Tushar Vira
**Roll Number:** 2024102044
**Institution:** IIIT Hyderabad  
**Course:** VLSI Design (Instructor: Prof. Abhishek Srivastava, CVEST)

## Table of Contents

- [Introduction](#introduction)
- [Architecture](#architecture)
- [Design Methodology](#design-methodology)
- [Implementation Details](#implementation-details)
- [Simulation Results](#simulation-results)
- [Layout Design](#layout-design)
- [FPGA Implementation](#fpga-implementation)
- [Performance Analysis](#performance-analysis)
- [Tools and Technologies](#tools-and-technologies)
- [Results Summary](#results-summary)
- [Future Improvements](#future-improvements)
- [References](#references)

## Introduction

Addition is a fundamental arithmetic operation in digital systems, forming the backbone of processors, ALUs, and various computational units. While traditional ripple-carry adders are simple to implement, they suffer from significant propagation delays due to sequential carry generation. The **Carry Look-Ahead Adder (CLA)** overcomes this limitation by computing carry signals in parallel, achieving O(log n) complexity instead of O(n).

### Key Features

- **5-bit parallel addition** with carry-out generation
- **Synchronous operation** using TSPC D flip-flops for input/output registers
- **Static CMOS implementation** using NAND-based universal logic
- **Complete physical layout** designed in MAGIC layout editor
- **Post-layout verification** with parasitic extraction
- **Hardware validation** on FPGA platform
- **Operating voltage:** VDD = 1.8V
- **Technology node:** 180nm CMOS

## Architecture

The 5-bit CLA adder consists of three primary functional blocks:

### 1. Propagate and Generate (P/G) Block

For each bit position i (where i = 0, 1, 2, 3, 4):
- **Propagate signal:** `pi = ai ⊕ bi`
- **Generate signal:** `gi = ai · bi`

### 2. Carry Look-Ahead Logic Block

Implements parallel carry computation:
- `c1 = g0`
- `c2 = (p1 · g0) + g1`
- `c3 = (p2 · p1 · g0) + (p2 · g1) + g2`
- `c4 = (p3 · p2 · p1 · g0) + (p3 · p2 · g1) + (p3 · g2) + g3`
- `c5 = (p4 · p3 · p2 · p1 · g0) + (p4 · p3 · p2 · g1) + (p4 · p3 · g2) + (p4 · g3) + g4`

### 3. Sum Generation Block

Computes final sum bits:
- `Si = pi ⊕ ci-1` (where c0 = 0)

### Synchronous Operation

- **Input registers:** TSPC D flip-flops capture input operands (A and B) at clock rising edge
- **Output registers:** TSPC D flip-flops store computed sum and carry-out, available at next rising edge
- Ensures predictable timing and clean interface with downstream logic

## Design Methodology

### Logic Style Selection

The design employs **static CMOS logic** with **NAND-based universal gates** for the following advantages:
- High noise margins
- Zero static power consumption
- Regular layout structure
- Minimum transistor count for universal logic
- Full logic swing (rail-to-rail operation)
- Robust behavior across PVT variations

### Design Philosophy

Unlike dynamic or pass-transistor logic, static CMOS provides:
- **Strong drive capability** through complementary pull-up and pull-down networks
- **Glitch-free operation** with predictable timing
- **Better manufacturability** and yield
- **Improved reliability** over temperature and voltage variations

## Implementation Details

### Basic Gates

#### 1. Inverter (INV)
- **NMOS:** W = 1.8μm, L = 0.18μm
- **PMOS:** W = 3.6μm, L = 0.18μm
- Sized for equal rise/fall times (βn = βp)

#### 2. 2-Input NAND Gate
- **Series NMOS:** W = 2 × 1.8μm = 3.6μm (compensate for series resistance)
- **Parallel PMOS:** W = 3.6μm
- L = 0.18μm for all transistors

#### 3. Multi-Input NAND Gates (3, 4, 5 inputs)
- **Series NMOS:** W = n × WN (where n = number of inputs)
- **Parallel PMOS:** W = WP = 3.6μm
- Sizing strategy maintains symmetrical rise/fall times

#### 4. XOR Gate
- Implemented using 4 NAND gates in NAND-NAND configuration
- Provides full swing output
- Used in P/G block and sum generation

### TSPC D Flip-Flop

The **True Single-Phase Clock (TSPC)** master-slave D flip-flop offers:
- **Single clock signal** (no complementary clock required)
- **Low power consumption** due to reduced clock loading
- **Reduced clock skew** concerns
- **Fast operation** with minimal setup time
- Three-stage dynamic logic structure

#### Measured Timing Parameters (Pre-Layout)
- **Setup Time (tsu):** 110 ps
- **Hold Time (th):** 0 ps (inherent to TSPC topology)
- **Clock-to-Q Delay (tc2q max):** 107.1 ps (rising edge)
- **Clock-to-Q Delay (tc2q min):** 50.58 ps (falling edge)

## Simulation Results

### Pre-Layout Simulation

**Tool:** NGSPICE with 180nm technology file

#### Functional Verification
- Comprehensive test vectors validated correct addition operation
- All combinations of 5-bit inputs tested
- Carry propagation verified through all bit positions

#### Timing Analysis
- **Worst-case propagation delay (tpd):** 594 ps (carry-out path)
- **Critical path:** Input FF → CLA logic → Output FF
- **Minimum clock period:** Tclk,min = tc2q,max + tpd + tsu = 107.1 ps + 594.2 ps + 110 ps = 811 ps

#### Pre-Layout Performance
- **Maximum Operating Frequency:** 1234.56 MHz
- All timing constraints satisfied with comfortable margins

### Post-Layout Simulation

**Tool:** MAGIC layout editor with SCN6M_DEEP.09.tech27 technology

#### Parasitic Extraction
Post-layout netlist includes:
- Gate, diffusion, and interconnect capacitances
- Metal and poly routing resistances
- Inter-wire coupling capacitances
- Junction capacitances

#### Timing Degradation Analysis

| Parameter | Pre-Layout | Post-Layout | Degradation |
|-----------|------------|-------------|-------------|
| tpd,max | 594 ps | 850 ps | 43% |
| Setup Time | 110 ps | 37.5 ps | Improved |
| tc2q,max | 107.1 ps | 936 ps | 774% |
| Tclk,min | 811 ps | 2038.5 ps | 151% |
| fmax | 1234.56 MHz | 434.4 MHz | 64.8% reduction |

#### Degradation Sources
1. **Parasitic capacitances:** Interconnect and diffusion loading
2. **Routing resistance:** RC delays in metal and polysilicon
3. **Coupling effects:** Adjacent wire interactions
4. **Non-ideal layout:** Longer interconnect paths than schematic

#### Post-Layout Performance
- **Maximum Operating Frequency:** 434.4 MHz
- Realistic performance accounting for physical effects
- Still exceeds typical embedded system requirements

## Layout Design

### Layout Methodology

**Tool:** MAGIC Layout Editor  
**Technology File:** SCN6M_DEEP.09.tech27 (6-metal layer process)

### Design Hierarchy

1. **Individual gate layouts** (INV, NAND2, NAND3, NAND4, NAND5, XOR)
2. **TSPC D flip-flop layout** (master-slave configuration)
3. **P/G block layout** (propagate and generate logic)
4. **Carry logic layout** (CLA computation block)
5. **Sum generation layout** (XOR array)
6. **Complete 5-bit CLA integration**

### Floor Planning Strategy

- **Regular structure:** Bit-sliced organization for carry logic
- **Power distribution:** Multiple VDD/GND rails for IR drop minimization
- **Signal routing:** Metal1 for local connections, Metal2/3 for global routing
- **Clock distribution:** Balanced H-tree for minimal skew
- **I/O separation:** Input registers on left, output registers on right

### Physical Characteristics

- **Total Layout Area:** ~48,955 μm²
- **Horizontal Pitch:** 179.64 μm (VDD-GND rail spacing)
- **Metal Layers Used:** Metal1, Metal2, Metal3
- **Active Layers:** Poly, N-diffusion, P-diffusion, N-well

### Design Rule Verification

- **DRC Clean:** Zero design rule violations
- **LVS Clean:** Layout matches schematic netlist
- **Antenna Rules:** Satisfied with protective diodes where necessary

## FPGA Implementation

### Hardware Validation

**Platform:** Xilinx FPGA  
**Tools:** Vivado Design Suite  
**HDL:** Verilog (structural description)

### Verilog Implementation

- **Structural modeling:** Instantiation of gates matching CMOS design
- **Hierarchical modules:** P/G block, CLA block, Sum block, D flip-flops
- **Testbench:** Comprehensive test vectors covering all input combinations

### Oscilloscope Measurements

Hardware testing validated:
1. **Test Case 1:** 11111 + 11111 = 11110 (with carry-out)
2. **Test Case 2:** 10101 + 01010 = 11111 (no carry-out)
3. **Test Case 3:** 11000 + 11100 = 10100 (with carry-out)

All test cases matched expected results, confirming correct hardware operation.

## Performance Analysis

### Speed Comparison: CLA vs Ripple-Carry

| Adder Type | Delay Complexity | 5-bit Delay | Advantage |
|------------|------------------|-------------|-----------|
| Ripple-Carry | O(n) | ~5 × tFA | Baseline |
| CLA (This Design) | O(log n) | ~594 ps | 3-4× faster |

### Area-Speed Trade-off

- **CLA advantages:** Significantly faster for multi-bit addition
- **CLA disadvantages:** Higher gate count, larger area, more complex routing
- **Optimal use case:** High-performance arithmetic units, pipelined processors

### Power Consumption

- **Static power:** Near zero (static CMOS design)
- **Dynamic power:** Proportional to clock frequency and switching activity
- **Power-performance trade-off:** Higher speed comes at cost of increased dynamic power

## Tools and Technologies

### Simulation Tools
- **NGSPICE:** Analog circuit simulation and timing analysis
- **Technology File:** 180nm CMOS process parameters

### Layout Tools
- **MAGIC Layout Editor:** Physical design and DRC/LVS verification
- **Technology:** SCN6M_DEEP.09.tech27 (6-metal CMOS process)

### Synthesis and FPGA Tools
- **Verilog HDL:** Hardware description and structural modeling
- **Vivado Design Suite:** FPGA synthesis, implementation, and programming
- **Oscilloscope:** Hardware measurement and validation

### Design Parameters
- **Supply Voltage (VDD):** 1.8V
- **Minimum Feature Size (λ):** 0.09 μm
- **Channel Length (L):** 0.18 μm (2λ)
- **Load Capacitance:** Inverter with Wp/Wn = 20λ/10λ

## Results Summary

### Key Achievements

✅ **Synchronous 5-bit CLA adder** with proper timing constraints  
✅ **Post-layout frequency:** 434.4 MHz (exceeds typical requirements)  
✅ **Complete VLSI flow:** Specification → Design → Layout → Fabrication-ready  
✅ **Hardware validation:** FPGA implementation confirms functional correctness  
✅ **Comprehensive analysis:** Pre/post-layout comparison quantifies parasitic effects  
✅ **DRC/LVS clean:** Layout ready for tape-out  

### Performance Metrics

| Metric | Value |
|--------|-------|
| Pre-Layout fmax | 1234.56 MHz |
| Post-Layout fmax | 434.4 MHz |
| Layout Area | 48,955 μm² |
| Technology Node | 180nm CMOS |
| Supply Voltage | 1.8V |
| Static Power | ~0 W (CMOS) |

### Design Insights

1. **Parasitic effects** reduce performance by ~65% from pre to post-layout
2. **TSPC flip-flops** provide excellent speed with minimal hold time
3. **NAND-based logic** offers good balance of speed, area, and robustness
4. **Static CMOS** eliminates static power and improves noise immunity
5. **Regular layout** simplifies routing and improves manufacturability

## Future Improvements

### Performance Enhancements
- **Pipelining:** Insert pipeline registers in carry logic for higher throughput
- **Dynamic logic:** Use domino logic for critical carry paths
- **Transistor optimization:** Advanced sizing using optimization algorithms
- **Layout optimization:** Reduce parasitic capacitances through careful floorplanning

### Functionality Extensions
- **Wider bit-width:** Extend to 16-bit or 32-bit using hierarchical CLA
- **Hybrid architectures:** Combine CLA with ripple-carry for area-efficient scaling
- **Error detection:** Add parity checking or residue codes
- **Low-power modes:** Clock gating and power gating for unused blocks

### Design Automation
- **Parameterized Verilog:** Scalable to arbitrary bit-widths
- **Automated place-and-route:** Using commercial EDA tools
- **Timing-driven optimization:** Meet aggressive frequency targets

## References

1. N. H. E. Weste and D. Harris, *CMOS VLSI Design: A Circuits and Systems Perspective*, 4th ed. Boston, MA: Addison-Wesley, 2011.

2. M. M. Mano, *Digital Logic and Computer Design*. Englewood Cliffs, NJ: Prentice-Hall, 1979.

3. J. P. Hayes, *Computer Architecture and Organization*, 3rd ed. New York, NY: McGraw-Hill, 1998.

4. S. Brown and Z. Vranesic, *Fundamentals of Digital Logic with Verilog Design*, 3rd ed. New York, NY: McGraw-Hill, 2013.

5. J. M. Rabaey, A. Chandrakasan, and B. Nikolic, *Digital Integrated Circuits: A Design Perspective*, 2nd ed. Upper Saddle River, NJ: Prentice Hall, 2003.

6. S. Palnitkar, *Verilog HDL: A Guide to Digital Design and Synthesis*, 2nd ed. Upper Saddle River, NJ: Prentice Hall, 2003.

---

## Project Structure

```
5-bit-CLA-Adder/
├── schematics/          # NGSPICE netlists and simulation files
├── layouts/             # MAGIC layout files (.mag)
├── extracted/           # Post-layout SPICE netlists
├── verilog/            # Verilog RTL and testbenches
├── fpga/               # FPGA implementation files
├── results/            # Simulation waveforms and measurements
├── docs/               # Project documentation and report
└── README.md           # This file
```

## Contact

**Saumya Tushar Vira**  
Email: saumya.vira@students.iiit.ac.in  
Institution: International Institute of Information Technology, Hyderabad  
Course: VLSI Design (Monsoon 2025)  
Instructor: Prof. Abhishek Srivastava, CVEST

---

*This project demonstrates the complete VLSI design flow from architectural specification through physical implementation and hardware validation, providing comprehensive insights into timing analysis, layout design, and the critical impact of parasitic effects on circuit performance.*
