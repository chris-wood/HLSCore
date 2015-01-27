`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:53:57 01/26/2015 
// Design Name: 
// Module Name:    dataMem 
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
module dataMem(
	input clock,
	input reset,

	input		[31:0]	addr_in,
	input		[31:0]	writedata_in,
	input					re_in,
	input					we_in,
	output	[31:0]	readdata_out
	);
	
	parameter INIT_PROGRAM = "C:\Users\Sam\Documents\GitHub\HLSCore\processors\simple\verilog\blank.memh";
	
	//select correct source for memory reads
	always @(*) begin
		case(addr_in[31:16])
			16'h1000:
				readdata_out <= data_readdata_data;
			16'h7fff:
				readdata_out <= data_readdata_stack;
			default:
				readdata_out <= 32'b0;
		endcase
	end
	
	//DATA segment
	mem
		#(
		.MEM_ADDR(16'h1000),
		.INIT_PROGRAM(INIT_PROGRAM),
		)
		data_seg
		(
		.clock(clock),
		.reset(reset),
		
		.addr_in(addr_in),
		.data_out(data_readdata_data),
		.re_in(re_in),
		.data_in(writedata_in),
		.we_in(we_in)
	);
	
	//STACK segment
	mem
		#(
		.MEM_ADDR(16'h7fff)
		)
		stack_seg
		(
		.clock(clock),
		.reset(reset),
		
		.addr_in(addr_in),
		.data_out(data_readdata_stack),
		.re_in(re_in),
		.data_in(writedata_in),
		.we_in(we_in)
	);


endmodule
