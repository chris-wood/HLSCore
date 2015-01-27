`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:29:15 01/26/2015 
// Design Name: 
// Module Name:    processor 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module processor(
	input clk,
	input rst,
	
	input [31:0]	imemresp_data,
	output[31:0]	imemreq_addr, 
	output[31:0]	dmemreq_addr, 
	output[31:0]	dmemreq_data, 
	input	[31:0]	dmemresp_data
	);
	
wire [4:0] raddr0;
wire [4:0] raddr1;
wire [31:0] rdata0;
wire [31:0] rdata1;
wire wen;
wire [4:0] waddr;
wire [31:0] wdata;

wire pc_sel;
wire	[4:0]		rf_raddr0;
wire	[4:0]		rf_raddr1; 
wire 			rf_wen;
wire	[4:0] 	rf_waddr;
wire 			op0_sel;
wire 			op1_sel; 
wire	[15:0]	inst_imm;
wire 			wb_sel;

regFile registers(
	clk, 
	raddr0, // Read 0 address (combinational input)
	rdata0, // Read 0 data (combinational on raddr)
	raddr1, // Read 1 address (combinational input)
	rdata1, // Read 1 data (combinational on raddr)
	wen_p,  // Write enable (sample on rising clk edge)
	waddr,// Write address(sample on rising clk edge)
	wdata // Write data (sample on rising clk edge)); 
	);

datapath dp(
	clk, 
	reset, 
	
	// Memory ports
	imemreq_addr, 
	dmemreq_addr, 
	dmemreq_data, 	//to be written
	dmemresp_data, //read back

	// Controls signals (ctrl->dpath)
	pc_sel, 
	op0_sel, 
	op1_sel, 
	inst_imm, 
	wb_sel, 

	// Control signals (dpath->ctrl)
	branch_cond_eq
);
	
	control(
		imemresp_data,
		// Controls signals (ctrl->dpath)
	output pc_sel, 
	output	[4:0]		rf_raddr0, 
	output	[4:0]		rf_raddr1, 
	output 			rf_wen, 
	output	[4:0] 	rf_waddr, 
	output 			op0_sel, 
	output 			op1_sel, 
	output	[15:0]	inst_imm, 
	output 			wb_sel, 

	// Control signals (dpath->ctrl)
	input 			branch_cond_eq
	);

endmodule
