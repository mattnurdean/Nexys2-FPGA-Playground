# Engineering Log: Day 02 - Mixed-Language Verification & Switch Control
**Date:** January 28, 2026
**Project:** 01_Blinky
**Goal:** Implement conditional logic (Switch Control) and verify it using UVM (Universal Verification Methodology) before hardware deployment.

## 1. Project Overview
Upgraded the standard "Blinky" design to include user input.
- **Input:** Switch 0 (`sw(0)`).
- **Output:** LED 0 (`led(0)`).
- **Logic:** If SW0 is High, LED blinks at ~0.74 Hz. If SW0 is Low, LED is Forced OFF.

## 2. Methodology: "Simulation Speedup"
To verify the logic in a cloud simulator (EDA Playground), we cannot wait 0.6 seconds (33 million clock cycles) for a blink. We implemented a parameterizable design strategy.

| Mode | Target Bit | Frequency | Purpose |

| **Real Hardware** | `counter(25)` | 0.74 Hz | Human-visible blinking on Nexys 2. |
| **Simulation** | `counter(4)` | ~1.5 MHz | Fast toggling for UVM Waveforms (10us runtime). |

## 3. Python Verification Model (Golden Reference)
The following Python script models the hardware behavior. It was used to verify the logic concepts before VHDL implementation.

```python
class BlinkyFPGA:
    def __init__(self, simulation_mode=False):
        self.counter = 0
        self.sw = 0
        self.led = 0
        # Simulation Mode uses Bit 4 (Fast), Hardware uses Bit 25 (Slow)
        self.target_bit = 4 if simulation_mode else 25

    def rising_edge_clk(self):
        self.counter += 1
        # Simulate 26-bit hardware rollover
        if self.counter >= 67108864:
             self.counter = 0

        # Switch Logic
        if self.sw == 1:
            self.led = (self.counter >> self.target_bit) & 1
        else:
            self.led = 0