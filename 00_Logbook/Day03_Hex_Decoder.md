# Engineering Log: Day 03 - Hexadecimal Decoder (Combinational Logic)
**Date:** February 05, 2026
**Project:** 02_Seven_Segment
**Platform:** Digilent Nexys 2 (Spartan-3E)
**Goal:** Implement a 4-bit Binary-to-Hex converter to control a Common Anode 7-Segment Display.

## 1. Concept
Unlike Project 1 (Blinky), this project uses **Combinational Logic** (no clock, no memory). The output changes immediately when the input switches change.
- **Inputs:** 4 Switches (Binary 0-15)
- **Outputs:** 7 Segments (Pattern g-a) + 4 Anodes (Digit Select)

## 2. Design Flow
1.  **Golden Model (Python):** Wrote `hex_model.py` to calculate the "Active Low" codes (e.g., 8 = `0000000`).
2.  **RTL (VHDL):** Implemented a `case` statement lookup table in `hex_decoder.vhd`.
3.  **Verification (SystemVerilog):** Verified the logic in EDA Playground. The testbench successfully drove inputs 0-F and checked outputs.
4.  **Hardware (FPGA):** Mapped inputs to SW0-SW3 and output to Digit 0 (Rightmost).

## 3. Implementation Details
**Key Challenge:** The Nexys 2 Display is **Common Anode**.
- To turn a segment ON, we must drive the pin **LOW (0)**.
- To select a digit, we must drive its Anode **LOW (0)**.
- We fixed `an <= "1110"` to activate only the rightmost digit.

## 4. Hardware Verification
**Status:** PASSED
**Observations:**
- SW0 (LSB) controls value +1.
- SW3 (MSB) controls value +8.
- **Test Case:** SW3 + SW2 + SW0 = 8 + 4 + 1 = 13 (Display 'd'). Verified correct.