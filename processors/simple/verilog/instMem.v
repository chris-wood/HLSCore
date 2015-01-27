`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:51:36 01/26/2015 
// Design Name: 
// Module Name:    instMem 
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
module instMem(
	input	clock,
	input reset,
	input [31:0] addr_in,
	output [31:0] data_out
	);

	parameter ADDR_WIDTH=8;
	parameter INIT_PROGRAM="C:\Users\Sam\Documents\GitHub\HLSCore\processors\simple\verilog\blank.memh";
	
	reg [31:0] rom [0:2**ADDR_WIDTH-1];
	reg [31:0] data_out;
	
	initial
	begin
		$readmemh(INIT_PROGRAM, rom);
	end
	
	always @(posedge clock) begin
		if (reset) begin
			data_out <= 32'h00000000;
		end else begin
			data_out <= rom[addr_in[ADDR_WIDTH+1:2]];
		end
	end

endmodule
