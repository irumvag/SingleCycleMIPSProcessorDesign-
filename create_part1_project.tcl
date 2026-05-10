# ============================================================
# Quartus II TCL Script: Create Part I Components Project
# Target: Cyclone IV GX EP4CGX15BF14C6
# Top-level: mips_components_top
# ============================================================

package require ::quartus::project
package require ::quartus::flow

set project_name "MIPS_Part1_Components"
set project_dir  [file dirname [info script]]
set src_dir      "$project_dir/Part1_Components"

# Create the project (overwrite if exists)
if {[project_exists $project_name]} {
    project_open $project_name -revision $project_name
} else {
    project_new -revision $project_name $project_name
}

# Device assignment
set_global_assignment -name FAMILY           "Cyclone IV GX"
set_global_assignment -name DEVICE           "EP4CGX15BF14C6"
set_global_assignment -name TOP_LEVEL_ENTITY mips_components_top

# Compiler settings
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256

# Add SystemVerilog source files
set_global_assignment -name SYSTEMVERILOG_FILE "$src_dir/full_adder_32.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$src_dir/mux4to1_32.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$src_dir/alu_32.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$src_dir/alu_control.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$src_dir/mips_components_top.sv"

export_assignments

project_close
puts "Part I project created successfully: $project_name"
