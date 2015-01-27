`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:49:34 01/26/2015
// Design Name:   datapath
// Module Name:   C:/Users/Sam/Documents/GitHub/HLSCore/processors/simple/verilog/testbench.v
// Project Name:  verilog
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: datapath
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench;

	// Inputs
	reg clk;
	reg reset;
	reg [31:0] instMem_data;
	reg [31:0] dataMem_addr;
	reg [31:0] dataMem_din;

	// Outputs
	wire instMem_rd;
	wire [31:0] instMem_addr;
	wire dataMem_rd;
	wire dataMem_wr;
	wire [31:0] dataMem_dout;

	// Instantiate the Unit Under Test (UUT)
	datapath uut (
		.clk(clk), 
		.reset(reset), 
		.instMem_rd(instMem_rd), 
		.instMem_addr(instMem_addr), 
		.instMem_data(instMem_data), 
		.dataMem_rd(dataMem_rd), 
		.dataMem_wr(dataMem_wr), 
		.dataMem_addr(dataMem_addr), 
		.dataMem_din(dataMem_din), 
		.dataMem_dout(dataMem_dout)
	);
	
	//instantiage memories
	instMem(clk, reset, instMem_addr, instMem_data);
	dataMem(clk, reset, dataMem_addr, dataMem_dout, dataMem_rd, dataMem_wr, dataMem_din);
	
	//Generate clock at 100 MHz
	initial begin
		clk <= 1'b0;
		forever #10 clk <= ~clk;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish
		#100;
      reset = 0;
		// Add stimulus here

	end
      
endmodule

