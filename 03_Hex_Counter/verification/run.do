vlib work
vcom -work work ../rtl/hex_decoder.vhd
vcom -work work ../rtl/pulse_gen.vhd
vcom -work work ../rtl/top.vhd
vlog -work work testbench.sv
vsim +access+r -c testbench
run -all