`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  SUTD
// Engineer:  Wen Jiaying
// 
// Create Date:    13:37:48 07/11/2016 
// Design Name:    Box_Muller_RNG
// Module Name:    Box_Muller_RNG  /Top module
// Project Name:   Nand Flash momory Modele
// Target Devices: 
// Tool versions:  
// Description:    用FPGA实现高斯分布随机数生成器
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
		
		output  signed	[15:0]	grv1,		//gaussian random variables
		output  signed	[15:0]	grv2,
		output 				outputvalid
    );
	 
	 
	reg							load_seed = 1'b0;
	reg							resetSeed = 1'b1;

	reg				[15:0]	sinTransfer_data;
	reg				[15:0]	cosTransfer_data;
	reg							outputvalid_reg;
	reg				[31:0] 	seed_normal_RNG = 32'h1234_4567;//Initial Value.
	
	wire	signed	[31:0]	grv_data1;
	wire	signed	[31:0]	grv_data2;	
	wire 							rstTmp				;
	wire 				[31:0]	rng_32bits 			;
	wire				[15:0]	h1_addr_16bits  	;
	wire							h1_doneFlag;
	wire				[15:0]	h1_data;
	wire				[31:0]	h2_addr_32bits 	;
	
	wire				[15:0]	sin_data;
	wire				[15:0]	cos_data;
	
	wire							readyForMerge;
	
	parameter seed = 32'h4DE1_76a4;
			
	 //********** Initial *********************************//					 
	always @ (posedge clk or posedge reset)
	begin
		if(reset)
		begin

			load_seed <= 1'b0;
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
		 
		rng 	rngRom1_uut (
					.clk(clk),
					.reset(rstTmp),
					.loadseed_i(load_seed),
					.seed_i(seed_normal_RNG),
					.number_o(rng_32bits)				//产生随机数作为后面的ROM地址
					);
					
					
//*********** h1-> ( (-2)*ln(x) ) ^ (1/2) *******************************************//
   assign h1_addr_16bits = rng_32bits[15:0];
	 
	
	logAndSquareUnit logAndSqure_uut(					//根据matlab程序生成的
						.clk(clk),
						.reset(reset),
						.enable(enable),
						.address(h1_addr_16bits),		//使用插值的方法扩展位
						.h1_Done(h1_doneFlag),
						.output_h(h1_data)
					 );			
				
//*********** h2-> sin & cos  *******************************************//	
	assign h2_addr_32bits = {{{rng_32bits[24:3],rng_32bits[31:25]},rng_32bits[2:0]}}; 	//

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
	
	always @ (posedge clk or posedge reset)
	begin
		if (reset)
			outputvalid_reg	<= 1'b0;
			
		else if(readyForMerge)
		begin		
			case({rng_32bits[12],rng_32bits[5]})
			2'd0:
			begin
				sinTransfer_data <=  sin_data;
				cosTransfer_data <=  cos_data;
				outputvalid_reg	<= 1'b1;
			end
			2'd1:
			begin
				sinTransfer_data <=  {~sin_data[15:0]+1'b1};
				cosTransfer_data <=  cos_data;
				outputvalid_reg	<= 1'b1;
			end
			2'd2:
			begin
				sinTransfer_data <=  sin_data;
				cosTransfer_data <=  {~cos_data[15:0]+1'b1};
				outputvalid_reg	<= 1'b1;
			end
			2'd3:
			begin
				sinTransfer_data <=  {~sin_data[15:0]+1'b1};
				cosTransfer_data <=  {~cos_data[15:0]+1'b1};
				outputvalid_reg	<= 1'b1;
			end
			default: ;
			endcase	//end case
		end	//end of if(readyForMerge)
	end	//end always



multiplier16buts multi_uut1( 
					.clk(clk),
					.reset(reset),
					.a_in16bit(h1_data),	//输入16位有符号数
					.b_in16bit(sinTransfer_data),	
					.y_out32bit(grv_data1) 			//输出32位有符号数
								);  
								
multiplier16buts multi_uut2( 
						.clk(clk),
						.reset(reset),
						.a_in16bit(h1_data),	//输入16位有符号数
						.b_in16bit(cosTransfer_data),	
						.y_out32bit(grv_data2) 			//输出32位有符号数
								);  								
								
assign 	grv1 = {grv_data1[31], grv_data1[26:12]};
assign 	grv2 = {grv_data2[31], grv_data2[26:12]};		
assign 	outputvalid=outputvalid_reg;

endmodule
