# Update Part I project to use EP4CE115F29C7 (528 I/O) for full compilation
package require ::quartus::project

set project_name "MIPS_Part1_Components"
set project_dir  [file dirname [info script]]

project_open -revision $project_name "$project_dir/$project_name"

set_global_assignment -name FAMILY "Cyclone IV E"
set_global_assignment -name DEVICE "EP4CE115F29C7"

export_assignments
project_close
puts "Device updated to EP4CE115F29C7"
