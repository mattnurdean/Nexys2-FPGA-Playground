# 1. Create the working library
vlib work

# 2. Compile the VHDL Design (The Decoder)
vcom hex_decoder.vhd

# 3. Compile the SystemVerilog Testbench
vlog testbench.sv

# 4. Initialize Simulation (Top module is 'top')
vsim -c top

# 5. Run until the testbench says $finish
run -all