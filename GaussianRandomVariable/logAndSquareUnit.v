`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:45:10 07/11/2016 
// Design Name: 
// Module Name:    logAndSquareUnit 
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
module logAndSquareUnit(
					 input 					clk,
					 input 					reset,
					 input 					enable,
					 output 	[15:0]		output_h
					 );
					 
	reg					loadSeed = 1'b0;
	reg					resetSeed = 1'b1;
	wire					seed_LogAndSquare = 32'h1234_4567;
	wire 					rstTmp;
	wire		[15:0]	Addr_16bits;
	
	parameter     		seed = 32'h5C27_66A3 ;				 
					 
//********** Initial *********************************//					 
	always @ (posedge clk or negedge reset)
	begin
		if(reset)
		begin
			output_h  <= 16'd0 ;
			load_seed <= 1'b0;
		end					//end of else(reset == 1'b1)
		else
		begin
			if(resetSeed == 1'b1)
			begin
				load_seed <= 1'b1;
				seed_logAndSquare <= seed;
				resetSeed <= 1'b0;
			end				//end of else(resetSeed == 1'b1)
			else
			begin
				load_seed <= 1'b0;
			end				//end of else(resetSeed == 1'b0)
		end				//end of else(reset == 1'b0)
	end				// end of always
	
	
//********** RNG for ROM address *********************************//		
	
		assign rstTmp = ~reset ;

		rng 	rngRom1_uut (
					.clk(clk),
					.reset(rstTmp),
					.loadseed_i(load_seed),
					.seed_i(seed_logAndSquare),
					.unmber_o(Addr_16bits)
					);
					
//*********** 对ROM 进行取值 *******************//					

	






endmodule
