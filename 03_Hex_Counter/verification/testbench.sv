module testbench;

  // 1. Signals
  logic clk;
  logic [0:0] btn;
  logic [6:0] seg;
  logic [3:0] an;
  logic dp;

  // 2. Instantiate DUT (Design Under Test)
  // CRITICAL: We override the Generic to 4 for super-fast simulation!
  top #(.SIM_SPEED(4)) u_top (
    .clk(clk),
    .btn(btn),
    .seg(seg),
    .an(an),
    .dp(dp)
  );

  // 3. Clock Generation (50 MHz = 20ns period)
  initial begin
    clk = 0;
    forever #10 clk = ~clk; // Toggle every 10ns
  end

  // 4. Test Sequence
  initial begin
    // Dump waves for EPWave
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);

    $display("Starting Simulation...");
    
    // Reset
    btn[0] = 1;
    #100;
    btn[0] = 0;
    $display("Reset Released. Counting begins.");

    // Wait for 20 counts (should see 0 -> F -> 0 -> 4)
    // Since SIM_SPEED=4, one count = 5 clocks = 100ns.
    // 20 counts * 100ns = 2000ns.
    #2500;

    $display("Simulation Finished.");
    $finish;
  end

endmodule