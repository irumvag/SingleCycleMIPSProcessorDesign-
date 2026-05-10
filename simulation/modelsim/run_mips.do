# ModelSim simulation script — Single-Cycle MIPS Processor (Part II)
# Run: do run_mips.do

vlib work
vmap work work

# Part I components
vlog -sv "../../Part1_Components/full_adder_32.sv"
vlog -sv "../../Part1_Components/alu_32.sv"
vlog -sv "../../Part1_Components/alu_control.sv"

# Part II modules
vlog -sv "../../Part2_Processor/mux2to1_32.sv"
vlog -sv "../../Part2_Processor/mux2to1_5.sv"
vlog -sv "../../Part2_Processor/sign_extend.sv"
vlog -sv "../../Part2_Processor/register_file.sv"
vlog -sv "../../Part2_Processor/control_unit.sv"
vlog -sv "../../Part2_Processor/instr_memory.sv"
vlog -sv "../../Part2_Processor/data_memory.sv"
vlog -sv "../../Part2_Processor/mips_top.sv"

# Testbench
vlog -sv "../../Part2_Processor/tb_mips_top.sv"

# Start simulation
vsim -t 1ns work.tb_mips_top

# Add signals to wave window
add wave -divider "Clock / Reset"
add wave -radix binary     sim:/tb_mips_top/clk
add wave -radix binary     sim:/tb_mips_top/reset

add wave -divider "Program Counter"
add wave -radix hexadecimal sim:/tb_mips_top/pc_out

add wave -divider "ALU Outputs"
add wave -radix unsigned   sim:/tb_mips_top/alu_result_out
add wave -radix binary     sim:/tb_mips_top/zero_out

add wave -divider "Internal — Control Signals"
add wave -radix binary     sim:/tb_mips_top/dut/reg_dst
add wave -radix binary     sim:/tb_mips_top/dut/alu_src
add wave -radix binary     sim:/tb_mips_top/dut/mem_to_reg
add wave -radix binary     sim:/tb_mips_top/dut/reg_write
add wave -radix binary     sim:/tb_mips_top/dut/mem_read
add wave -radix binary     sim:/tb_mips_top/dut/mem_write
add wave -radix binary     sim:/tb_mips_top/dut/branch
add wave -radix binary     sim:/tb_mips_top/dut/alu_op

add wave -divider "Internal — Datapath"
add wave -radix hexadecimal sim:/tb_mips_top/dut/instr
add wave -radix unsigned    sim:/tb_mips_top/dut/rd1
add wave -radix unsigned    sim:/tb_mips_top/dut/rd2
add wave -radix unsigned    sim:/tb_mips_top/dut/alu_result
add wave -radix unsigned    sim:/tb_mips_top/dut/write_back_data

# Configure wave display
configure wave -namecolwidth 200
configure wave -valuecolwidth 120
configure wave -timelineunits ns

# Run 300 ns (covers reset + 10 instructions at 20 ns each)
run 300ns

wave zoom full
