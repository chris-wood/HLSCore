`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:14:06 01/26/2015 
// Design Name: 
// Module Name:    datapath 
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
module datapath(
	input	clk, 
	input	reset,
	
	output instMem_rd,
	output [31:0] instMem_addr,
	input [31:0] instMem_data,
	
	output dataMem_rd,
	output dataMem_wr,
	input [31:0] dataMem_addr,
	input [31:0] dataMem_din,
	output [31:0] dataMem_dout
	);

	//data path signals
	reg[31:0] branch_targ; 
	reg[31:0] sign_ext_shift; 
	reg[31:0] sign_ext;
	reg[31:0] pc_plus4; 
	reg[31:0] pc_out; 
	reg[31:0] pc; 
	
	//register file signals
	reg [4:0] r2;
	reg [31:0] data2;
	wire [31:0] rdata0;
	wire [31:0] reg1;
	reg [31:0] rdata1;
	wire reg_wr;
	
	//alu signals
	wire zero;
	wire [31:0] result;
	wire [2:0] alu_op;
	
	//control
	wire reg_dst;
	wire [1:0] alu_src;
	wire mem2reg;
	wire pc_src;
	
	//set PC as instruction memory address
	assign instMem_addr = pc;
	
	//Add PC+4
	assign pc_plus4 = pc + 4;
	
	//RegDst MUX
	assign r2 = (reg_dst == 0) ? instMem_data[20:16] : instMem_data[15:11];
	//PCsrc MUX
	assign pc_out = (pc_src == 0) ? pc_plus4 : branch_targ;
	//Mem2Reg MUX
	assign data2 = (mem2reg == 0) ? result : dataMem_din;
	
	//ALUsrc MUX
	always @(*)
	begin
		case(alu_src)
			3'd0 : rdata1 = reg1;	//from reg
			3'd1 : rdata1 = {16'd0,inst_imm};	//unsigned imm
			3'd2 : rdata1 = sign_ext;	//signed imm
			3'd3 : rdata1 = 32'd4;	//value of 4 for address 
			3'd4 : rdata1 = 
		endcase
	end
	
	//sign extend
	assign sign_ext = (inst_imm[15] == 1) ? {16'hFFFF, instMem_data[15:0]} : {16'h0000, instMem_data[15:0]};
	
	//shift by 2
	assign sign_ext_shift = {sign_ext[29:0],2'b0};
	
	//branch target
	assign branch_targ = sign_ext_shift + pc_plus4;

	//register the PC
	always @(posedge(clk))
	begin
		if(reset == 1) begin
			pc = 32'h0001000;
		end else begin
			pc = pc_out;
		end
	end
	
	//instantiage Register File
	regFile registers(clk, instMem_data[25:21], rdata0, instMem_data[20:16], reg1, reg_wr, r2, data2);
	
	//instantiate ALU
	alu alu_i(rdata0, rdata1, alu_op, zero, result);
	
	//instantiage Control Unit
	control ctrl(zero, instMem_data, reg_dst, reg_wr, alu_op, alu_src, dataMem_wr, dataMem_rd, mem2reg, pc_src);

endmodule
