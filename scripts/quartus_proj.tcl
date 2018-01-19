load_package ::quartus::flow

set board  "c4es"
set project "uart_test"
set top $project

project_new $project -part EP4CE115F29C7 -family "Cyclone IV E"
set_global_assignment -name VERILOG_MACRO "CYCLONE_ES"
set_parameter -name FPGA_BOARD "C4ES"

set_global_assignment -name TOP_LEVEL_ENTITY $top
set_global_assignment -name NUM_PARALLEL_PROCESSORS 4

set_global_assignment -name SDC_FILE ../scripts/uart_test.sdc
set_global_assignment -name SYSTEMVERILOG_FILE ../rtl/uart_test.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../rtl/uart_tx.sv
set_global_assignment -name QIP_FILE ../rtl/ip/pll_2x.qip

set_location_assignment PIN_G9 -to tx
set_location_assignment PIN_M23 -to resetn_in
set_location_assignment PIN_M21 -to pb
set_instance_assignment -name IO_STANDARD "2.5 V" -to tx
set_instance_assignment -name IO_STANDARD "2.5 V" -to resetn_in
set_instance_assignment -name IO_STANDARD "2.5 V" -to pb

# 50 MHz clkin
set_location_assignment PIN_Y2 -to clkin
#set_instance_assignment -name IO_STANDARD "3.3 V" -to clkin

set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top
export_assignments

execute_flow -compile
exit
