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
		
		output  	[15:0]	grv1,		//gaussian random variables
		output  	[15:0]	grv2,
		output 				outputvalid
    );
	 
	 
	reg					load_seed = 1'b0;
	reg					resetSeed = 1'b1;
	reg		[31:0]	grv_data1;
	reg		[31:0]	grv_data2;
	
	wire		[31:0] 	seed_normal_RNG = 32'h1234_4567;//Initial Value
	wire 					rstTmp				= 1'b0;
	wire 		[31:0]	rng_32bits 			= 32'b0;
	wire		[15:0]	h1_addr_16bits  	= 16'b0;
	wire					h1_doneFlag;
	wire		[15:0]	h1_data;
	wire		[15:0]	h2_addr_16bits  	= 16'b0;
	
	wire		[15:0]	sin_data;
	wire		[15:0]	cos_data;
	
	wire					readyForMerge;
	 
	 //********** Initial *********************************//					 
	always @ (posedge clk or negedge reset)
	begin
		if(reset)
		begin
			grv  <= 16'd0 ;
			load_seed <= 1'b0;
			outputvalid	<= 1'b0;
		end					//end of else(reset == 1'b1)
		else
		begin
			if(resetSeed == 1'b1)
			begin
				load_seed <= 1'b1;
				seed_normal_RNG <= seed;
				resetSeed <= 1'b0;
			end				//end of else(resetSeed == 1'b1)
			else
			begin
				load_seed <= 1'b0;
			end				//end of else(resetSeed == 1'b0)
		end				//end of else(reset == 1'b0)
	end				// end of always
	
	
	 
//********** Random number for logarith & Square Rom **********//
	
//********** RNG for ROM address *********************************//		
	
		assign 			   rstTmp 	= ~reset ;
		parameter     		seed 		= 32'h5C27_66A3 ;
		
		rng 	rngRom1_uut (
					.clk(clk),
					.reset(rstTmp),
					.loadseed_i(load_seed),
					.seed_i(seed_normal_RNG),
					.unmber_o(rng_32bits)		//32bits
					);
//*********** h1-> ( (-2)*ln(x) ) ^ (1/2) *******************************************//
   assign h1_addr_16bits = rng_32bits[15:0];
	 
	
	logAndSquareUnit logAndSqure_uut(
						.clk(clk),
						.reset(reset),
						.enable(enable),
						.address(h1_addr_16bits),		//使用插值的方法扩展位
						.h1_Done(h1_doneFlag),
						.output_h(h1_data)
					 );			
				
//*********** h2-> sin & cos  *******************************************//	
	assign h2_addr_32bits = {rng_32bits[24:3],rng_32bits[31:25],rng_32bits[2:0]}; 	//

	sinAndCosUnit sinAndCos_uut(
						.clk(clk),
						.reset(reset),
						.enable(enable),
						.address(h2_addr_32bits),		//使用插值的方法扩展位
						.sinAndCos_Done(h2_doneFlag),
						.output_sin(sin_data),
						.output_cos(cos_data)
					 );		
					 
//************ Box-Muller output *******************************************//
	assign 	readyForMerge = h2_doneFlag && h1_doneFlag;
	
	always @ (posedge clk or negedge reset)
	begin
		if(readyForMerge)
		begin
			grv_data1 <= h1_data * sin_data;
			grv_data2 <= h1_data * cos_data;
		end	//end of if(readyForMerge)
	
	end	//end always

assign 	grv1 = {grv_data1[31], grv_data1[22:12]};
assign 	grv2 = {grv_data2[31], grv_data2[22:12]};		
	
endmodule
