`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:37:48 07/11/2016 
// Design Name: 
// Module Name:    Box-MullerTop 
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
module Box_Muller_RNG(
		input 				clk,
		input 				reset,
		input 				enable,
		
		output  	[15:0]	grv,
		output 				outputvalid;
    );
	 
	 wire 					rstTmp;
	 wire			[15:0]  	Addr1;
	 wire			[15:0]  	Addr2;
	 
	 
	 parameter		seed2 = 32'hBA51_980D ;
	 
	 
//********** Random number for logarith & Square Rom **********//
	
	
	logAndSquareUnit 

				
				
				
				
endmodule
