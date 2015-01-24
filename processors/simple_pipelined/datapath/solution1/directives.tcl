############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 2013 Xilinx Inc. All rights reserved.
############################################################
set_directive_interface -mode ap_ctrl_none -latency 0 "datapath"
set_directive_pipeline "datapath/loop"
set_directive_dependence -variable reg -type inter -dependent false "datapath/loop"
set_directive_dependence -variable exit -type inter -dependent false "datapath/loop"
set_directive_array_partition -type complete -dim 1 "datapath" reg
