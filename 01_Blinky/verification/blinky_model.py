class BlinkyFPGA:
    def __init__(self, simulation_mode=False):
        # INTERNAL SIGNALS
        self.counter = 0 
        
        # PORTS (Matching EDA Playground Logic)
        self.clk = 0
        self.sw = 0  # Switch Input
        self.led = 0 # LED Output

        # PARAMETERIZATION
        # simulation_mode = True  -> Uses Bit 4 (Fast for EDA Playground)
        # simulation_mode = False -> Uses Bit 25 (Slow for Real Board)
        if simulation_mode:
            self.target_bit = 4
            print(">>> MODE: Simulation Speedup (Bit 4)")
        else:
            self.target_bit = 25
            print(">>> MODE: Real Hardware (Bit 25)")

    def rising_edge_clk(self):
        """
        Simulates one clock cycle (process(clk) in VHDL)
        """
        # 1. INCREMENT
        self.counter += 1
        
        # Simulate 26-bit Rollover (Hardware Limit)
        if self.counter >= 67108864: # 2^26
            self.counter = 0

        # 2. SWITCH LOGIC (The Advanced Part)
        # matches: if sw(0) = '1' then ...
        if self.sw == 1:
            # 3. BLINK LOGIC
            # matches: led <= counter(target_bit);
            self.led = (self.counter >> self.target_bit) & 1
        else:
            # matches: else led <= '0';
            self.led = 0

# --- TEST SCENARIO ---
if __name__ == "__main__":
    # 1. CHANGE THIS: Use Simulation Mode (True) so it uses Bit 4
    dut = BlinkyFPGA(simulation_mode=True)
    
    # 2. Turn Switch ON
    dut.sw = 1 
    
    print(f"{'Cycle':<10} | {'Counter':<10} | {'LED'}")
    print("-" * 30)

    # 3. CHANGE THIS: Run for 35 cycles
    # Bit 4 (16) flips at cycle 16 and 32. We need enough time to see it!
    for i in range(35):
        dut.rising_edge_clk()
        print(f"{i:<10} | {dut.counter:<10} | {dut.led}")