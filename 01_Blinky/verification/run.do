# 1. Create the working library
vlib work

# 2. Compile the VHDL Design
vcom blinky.vhd

# 3. Compile the Testbench
vlog +incdir+$::env(RIVIERA_HOME)/vlib/uvm-1.2/src -l uvm_1_2 testbench.sv

# 4. Start Simulator with READ ACCESS (+access+r)
vsim -c top -L uvm_1_2 +access+r

# 5. Run
run -all
quit