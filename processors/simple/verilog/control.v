`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:21 01/26/2015 
// Design Name: 
// Module Name:    control 
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

`define LW 		32'b100011_?????_?????_?????_?????_?????? 
`define SW 		32'b101011_?????_?????_?????_?????_?????? 
`define ADDIU	32'b001001_?????_?????_?????_?????_?????? 
`define BNE 	32'b000101_?????_?????_?????_?????_??????

//pc_src values
`define pc_src_pc4	0
`define pc_src_br		1

//mem2reg values
`define mem2reg_reg	0
`define mem2reg_mem	1

//alu_src values
`define alu_src_reg	0
`define alu_src_imm	1

//alu_op values
`define alu_op_add	2
`define alu_op_sub	5
`define alu_op_and	0
`define alu_op_or		1
`define alu_op_slt	7

module control(
	input zero,
	input [31:0] instMem_data,
	
	output reg_dst,
	output reg_wr,
	output alu_op,
	output alu_src,
	output mem_wr,
	output mem_rd,
	output mem2reg,
	output pc_src
	);

	always@(*) 
	begin 
		casez( instMem_data ) 
			// 						op0 mux	op1 mux	wb mux	rfile mreq	  mreq
			// 			 br type sel 		sel 		sel 		wen 	r/w 	  val
			`ADDIU: begin
				pc_src = pc_src_pc4; 
				mem2reg = mem2reg_reg;
				mem_rd = 0;
				mem_wr = 0;
				alu_src = alu_src_reg;
				alu_op = alu_op_add;
				
				end
			`BNE 	: cs ={br_neq, op0_sx2, op1_pc4, wmx_x,	1'b0, mreq_x, 1'b0}; 
			`LW 	: cs ={br_pc4, op0_sx,	op1_rd0, wmx_mem, 1'b1, mreq_r, 1'b1}; 
			`SW 	: cs ={br_pc4, op0_sx,	op1_rd0, wmx_x,	1'b0, mreq_w, 1'b1};
endcase 
end 

endmodule
