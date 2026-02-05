// Testbench for Hex Decoder
module top;
  // Signals
  logic [3:0] sw;   // 4 Switches
  logic [6:0] seg;  // 7 Segments (Output)
  logic [3:0] an;   // Anodes (Output)
  logic dp;         // Decimal Point (Output)

  // Instantiate the VHDL DUT (Device Under Test)
  hex_decoder dut (
    .sw(sw),
    .seg(seg),
    .an(an),
    .dp(dp)
  );

  // Test Logic
  initial begin
    $dumpfile("dump.vcd"); // Create waveform file
    $dumpvars;

    // Title
    $display("-------------------------------------------");
    $display("HEX | SW (Input) | SEG (Output) | Check");
    $display("-------------------------------------------");

    // Loop from 0 to 15 (0x0 to 0xF)
    for (int i = 0; i < 16; i++) begin
      sw = i;      // Apply Input
      #10;         // Wait 10ns for logic to settle

      // Print status
      // %h = Hex format, %b = Binary format
      $display(" %h  |    %b    |   %b    |", sw, sw, seg);
    end
    
    $display("-------------------------------------------");
    $finish; // End simulation
  end
endmodule