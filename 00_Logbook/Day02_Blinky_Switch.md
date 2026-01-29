# Engineering Log: Day 02 - Mixed-Language Verification & Switch Control
**Date:** January 29, 2026
**Project:** 01_Blinky
**Platform:** Digilent Nexys 2 (Spartan-3E)
**Goal:** Implement conditional logic (Switch Control) and verify it using a Python Golden Model before hardware deployment.

## 1. Project Overview
Upgraded the standard "Blinky" design to include user input.
- **Input:** Switch 0 (sw<0>).
- **Output:** LED 0 (led<0>).
- **Logic:**
  - If SW0 = 1: LED blinks at ~0.74 Hz.
  - If SW0 = 0: LED is Forced OFF.

## 2. Methodology: "Simulation Speedup"
To verify the logic in a cloud simulator (EDA Playground), cannot wait 0.6 seconds (33 million clock cycles) for a blink. Implemented a parameterizable design strategy.

- **Real Hardware:** Uses Bit 25. Frequency: ~0.74 Hz. Purpose: Human-visible blinking.
- **Simulation:** Uses Bit 4. Frequency: ~1.5 MHz. Purpose: Fast toggling for UVM Waveforms.

## 3. Verification: Python Golden Model
Before writing VHDL, verified the logic using a Python script (blinky_model.py). This serves as the "Golden Reference" to prove the math is correct.

**Script Execution Log:**
Command: python 01_Blinky/verification/blinky_model.py

Output:
>>> MODE: Simulation Speedup (Bit 4)
Cycle      | Counter    | LED
------------------------------
0          | 1          | 0
1          | 2          | 0
2          | 3          | 0
3          | 4          | 0
4          | 5          | 0
5          | 6          | 0
6          | 7          | 0
7          | 8          | 0
8          | 9          | 0
9          | 10         | 0
10         | 11         | 0
11         | 12         | 0
12         | 13         | 0
13         | 14         | 0
14         | 15         | 0
15         | 16         | 1 <-- LED Turns ON (Bit 4 High)
16         | 17         | 1
17         | 18         | 1
18         | 19         | 1
19         | 20         | 1
20         | 21         | 1
21         | 22         | 1
22         | 23         | 1
23         | 24         | 1
24         | 25         | 1
25         | 26         | 1
26         | 27         | 1
27         | 28         | 1
28         | 29         | 1
29         | 30         | 1
30         | 31         | 1
31         | 32         | 0 <-- LED Turns OFF (Bit 4 Low)
32         | 33         | 0
33         | 34         | 0
34         | 35         | 0 

**Result:** The model confirms that the LED toggles correctly based on the target bit.

## 4. Hardware Implementation (RTL)
The final VHDL code synthesized for the FPGA (01_Blinky/rtl/blinky.vhd).

```vhdl
entity blinky is
    Port ( clk : in  STD_LOGIC;
           sw  : in  STD_LOGIC_VECTOR (0 downto 0);
           led : out STD_LOGIC_VECTOR (0 downto 0));
end blinky;

architecture Behavioral of blinky is
    signal counter : unsigned(25 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;
            
            -- CONDITIONAL LOGIC
            if sw(0) = '1' then
                led(0) <= counter(25); -- Blink (Bit 25)
            else
                led(0) <= '0';         -- Force OFF
            end if;
        end if;
    end process;
end Behavioral;

## 5. Constraints (UCF)
The pin mapping for the Digilent Nexys 2 Board (01_Blinky/constraints/nexys2.ucf).

Plaintext
NET "clk" LOC = "B8";    # 50MHz Oscillator
NET "sw<0>" LOC = "G18"; # Switch 0
NET "led<0>" LOC = "J14";# LED 0

## 6. Final Results
Simulation: Validated via Python and UVM Testbench.

Synthesis: Successfully generated blinky.bit using Xilinx ISE 14.7.

Hardware Test:

Test 1 (SW0 OFF): LED remained OFF.

Test 2 (SW0 ON): LED blinked visible (~1 sec period).

Status: PASSED