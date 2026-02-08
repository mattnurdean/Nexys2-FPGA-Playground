# Engineering Log: Day 04 - Hexadecimal Counter (Sequential Logic)
**Date:** February 08, 2026
**Project:** 03_Hex_Counter
**Platform:** Digilent Nexys 2 (Spartan-3E)
**Goal:** Create an automated 4-bit counter that updates the display every second.

## 1. System Architecture (Hierarchy)
Moved from a single-file design to a modular **Hierarchical Design**:
* **`top.vhd` (Manager):** Instantiates components and handles global reset.
* **`pulse_gen.vhd` (Timing):** Generates a 1-cycle "tick" enable signal.
    * *Technique:* Uses a `Generic` to allow speed adjustment (50M for Hardware vs. 4 for Simulation).
* **`hex_decoder.vhd` (Logic):** Reused IP from Project 02 (Binary $\rightarrow$ 7-Seg).

## 2. Verification Strategy
**A. Golden Model (Python):**
* Script: `verification/counter_model.py`
* Result: Generated the master Truth Table (Active Low Hex codes).
* *Check:* `0` $\rightarrow$ `40` (Binary 1000000), `1` $\rightarrow$ `79` (Binary 1111001).

**B. Logic Simulation (SystemVerilog):**
* Tool: EDA Playground (Riviera-PRO).
* Method: Overrode `SIM_SPEED = 4` to simulate 1 second in just 100ns.
* *Observation:* Waveform showed `seg` bus transitioning `40` $\rightarrow$ `79` $\rightarrow$ `24`, matching Python predictions exactly.

## 3. Hardware Implementation
**Bitstream:** `top.bit` generated successfully.
**Observations:**
* **Timing:** The display updates visible at ~1 Hz (matches 50MHz / 50M count).
* **Function:** Counts `0` to `F` and wraps around to `0`.
* **Control:** BTN0 acts as an asynchronous Reset (holding it clears display to `0`).

## 4. Key Learnings
1.  **Generics:** Essential for simulating long timers without waiting millions of cycles.
2.  **Hierarchy:** Simplifies debugging; I only had to debug `pulse_gen` for timing issues, leaving `hex_decoder` untouched.