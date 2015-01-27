`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:55:56 01/26/2015 
// Design Name: 
// Module Name:    mem 
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
module mem(
	input clock,
	input reset,
	
	input		[31:0]	addr_in,
	output	[31:0]	data_out,
	input		[31:0]	data_in,
	input					we_in,
	input					re_in
	);
	
	parameter	MEM_ADDR = 16'h1000;
	parameter	INIT_PROGRAM = "C:\Users\Sam\Documents\GitHub\HLSCore\processors\simple\verilog\blank.memh";
	reg	[256*8:1] file_init0, file_init1, file_init2, file_init3;

	localparam NUM_WORDS = 1024;
	localparam NUM_WORDS_LOG = 10;
	
	initial begin
		$readmemh(INIT_PROGRAM, mem);
	end
	
	//memory for 4KB of data
	reg [31:0] mem	[0:NUM_WORDS-1];
	
	reg	[31:0]	rd;
	assign data_out = rd;
	
	//alternate version uses negative edge of clock for memory accesses
	always @(negedge clock) begin
		rd <= mem[addr_in[2+NUM_WORDS_LOG-1:2]];		
	end
		
	//on posedge of clock, write data only if wr_en is high
	always @(posedge clock) begin
		if (reset) begin
		end else begin
			if (we_in && (addr_in[31:16] == MEM_ADDR)) begin
				mem[addr_in[2+NUM_WORDS_LOG-1:2]] <= data_in;
			end
		end
	end

endmodule
