package require ::quartus::project
set project_name "MIPS_Part2_Processor"
set project_dir  [file dirname [info script]]
project_open -revision $project_name "$project_dir/$project_name"
set_global_assignment -name FAMILY "Cyclone IV E"
set_global_assignment -name DEVICE "EP4CE115F29C7"
export_assignments
project_close
puts "Part II device updated to EP4CE115F29C7"
