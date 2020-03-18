
# Set the original project directory path for adding/importing sources in the new project
set orig_proj_dir "../ZCU104_hdmitest"

# Create project
create_project -force ZCU104_hdmitest ../ZCU104_hdmitest

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [get_projects ZCU104_hdmitest]
set_property "board_part" "xilinx.com:zcu104:part0:1.1" $obj
set_property "simulator_language" "Mixed" $obj
set_property "target_language" "VHDL" $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Add IP location
set_property ip_repo_paths  C:/kutu/svn/hawk/trunk/XilinxIP [current_fileset]
update_ip_catalog

add_files -norecurse sources/sources_1/top_level/top.vhd

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property "ip_repo_paths" "../XilinxIP" $obj
set_property "top" "top_ZCU104_hdmitest" $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Add files to 'constrs_1' fileset
add_files -fileset constrs_1 -norecurse sources/constrs_1/ZCU104_hdmitest.xdc


# Set 'constrs_1' fileset file properties for remote files
# None

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets sim_1] ""]} {
  create_fileset -simset sim_1
}

# Add files to 'sim_1' fileset
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property "top" "top_ZCU104_hdmitest" $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs synth_1] ""]} {
  create_run -name synth_1 -part xc7z020clg484-1 -flow {Vivado Synthesis 2015} -strategy "Vivado Synthesis Defaults" -constrset constrs_1
}
set obj [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs impl_1] ""]} {
  create_run -name impl_1 -part xc7z020clg484-1 -flow {Vivado Implementation 2015} -strategy "Vivado Implementation Defaults" -constrset constrs_1 -parent_run synth_1
}
set obj [get_runs impl_1]

puts "INFO: Project created:ZCU104_hdmitest"

# Add IP location
set_property ip_repo_paths ../XilinxIP [current_fileset]
update_ip_catalog

# Create block diagram
source scripts/system_top_bd.tcl

# Create block diagram wrapper
make_wrapper -files [get_files ZCU104_hdmitest.srcs/sources_1/bd/system_top/system_top.bd] -top
add_files -norecurse ZCU104_hdmitest.srcs/sources_1/bd/system_top/hdl/system_top_wrapper.vhd


update_compile_order -fileset sources_1
regenerate_bd_layout
save_bd_design

# generate output products
update_compile_order -fileset sources_1
generate_target all [get_files  ZCU104_hdmitest.srcs/sources_1/bd/system_top/system_top.bd]
