`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:10:34 01/26/2015 
// Design Name: 
// Module Name:    regFile 
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
module regFile(
	input 				clk, 
	input  	[4:0]		r0, // Read 0 address (combinational input)
	output 	[31:0]	data0, // Read 0 data (combinational on raddr)
	input 	[4:0] 	r1, // Read 1 address (combinational input)
	output	[31:0]	data1, // Read 1 data (combinational on raddr)
	input					reg_wr,  // Write enable (sample on rising clk edge)
	input		[4:0] 	r2,// Write address(sample on rising clk edge)
	input		[31:0]	data2 // Write data (sample on rising clk edge)); 
	);

	// We use an array of 32 bit register for the regfile itself
	reg [31:0] registers[31:0]; 

	// Combinational read ports
	assign data0 = ( r0 == 0 ) ? 32'b0 : registers[r0]; 
	assign data1 = ( r1 == 0 ) ? 32'b0 : registers[r1]; 
	
	// Write port is active only when wen is asserted
	always @( posedge clk ) 
		if( reg_wr && (r2 != 5'b0) ) 
			registers[r2] <= data2; 

endmodule
