# ModelSim simulation script for MIPS ALU Part I
# Run: do run_sim.do

vlib work
vmap work work

# Compile source files
vlog -sv "../../Part1_Components/full_adder_32.sv"
vlog -sv "../../Part1_Components/mux4to1_32.sv"
vlog -sv "../../Part1_Components/alu_32.sv"
vlog -sv "../../Part1_Components/alu_control.sv"
vlog -sv "../../Part1_Components/mips_components_top.sv"

# Compile testbench
vlog -sv "../../Part1_Components/tb_alu_32.sv"

# Start simulation
vsim -t 1ns work.tb_alu_32

# Add all signals to wave window
add wave -divider "ALU Control"
add wave -radix binary     sim:/tb_alu_32/alu_ctrl
add wave -divider "Inputs"
add wave -radix hexadecimal sim:/tb_alu_32/a
add wave -radix hexadecimal sim:/tb_alu_32/b
add wave -divider "Outputs"
add wave -radix hexadecimal sim:/tb_alu_32/result
add wave -radix binary     sim:/tb_alu_32/zero

# Configure wave window
configure wave -namecolwidth 150
configure wave -valuecolwidth 120
configure wave -timelineunits ns

# Run simulation
run 200ns

# Zoom to fit
wave zoom full
