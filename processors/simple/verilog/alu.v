`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:56:26 01/26/2015 
// Design Name: 
// Module Name:    alu 
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
module alu(
	// Register data
	input [31:0] data0,
	input [31:0] data1,
	
	// Control signals
	input [2:0] alu_op,
	
	// Outputs
	output zero,
	output [31:0] result
	);
	 
	 reg zero;
	 reg [31:0] result;

	//compare equal
	assign zero = (result == 0) ? 1:0;
	
	//ALU
	always @(data0,data1,alu_op)
	begin
		case(alu_op)
			3'b010:  begin	//ADD	2
				result = data0 + data1;
				end

			3'b110:	begin	//SUB 5
				result = data0 - data1;
				end

			3'b000: begin	//AND 0
				result = data0 & data1;
				end

			3'b001: begin	//OR 1 
				result = data0 | data1;
				end

			3'b111: begin	//SLT 7
				result = data0 < data1 ? 1 : 0;
				end

			default: begin
				result=0;
				end
		endcase
	end

endmodule
