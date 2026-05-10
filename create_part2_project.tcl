# ============================================================
# Quartus II TCL Script: Create Part II Full MIPS Processor Project
# Target: Cyclone IV GX EP4CGX15BF14C6
# Top-level: mips_top
# ============================================================

package require ::quartus::project
package require ::quartus::flow

set project_name "MIPS_Part2_Processor"
set project_dir  [file dirname [info script]]
set src1_dir     "$project_dir/Part1_Components"
set src2_dir     "$project_dir/Part2_Processor"

# Create the project (overwrite if exists)
if {[project_exists $project_name]} {
    project_open $project_name -revision $project_name
} else {
    project_new -revision $project_name $project_name
}

# Device assignment
set_global_assignment -name FAMILY           "Cyclone IV GX"
set_global_assignment -name DEVICE           "EP4CGX15BF14C6"
set_global_assignment -name TOP_LEVEL_ENTITY mips_top

# Compiler settings
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256

# --- Shared components from Part I ---
set_global_assignment -name SYSTEMVERILOG_FILE "$src1_dir/alu_32.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$src1_dir/alu_control.sv"

# --- Part II source files ---
set_global_assignment -name SYSTEMVERILOG_FILE "$src2_dir/mux2to1_32.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$src2_dir/mux2to1_5.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$src2_dir/sign_extend.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$src2_dir/register_file.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$src2_dir/control_unit.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$src2_dir/instr_memory.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$src2_dir/data_memory.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$src2_dir/mips_top.sv"

export_assignments

project_close
puts "Part II project created successfully: $project_name"
