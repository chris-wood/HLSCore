############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 2013 Xilinx Inc. All rights reserved.
############################################################
open_project datapath
set_top datapath
add_files datapath.cpp
add_files -tb test.cpp
open_solution "solution1"
set_part {xc7z020clg484-1}
create_clock -period 10 -name default
source "./datapath/solution1/directives.tcl"
csim_design
csynth_design
cosim_design -trace_level none
export_design -evaluate vhdl -format pcore -version "1.00.a" -use_netlist none
