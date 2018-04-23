`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   05:15:42 04/22/2018
// Design Name:   PipelineMIPS
// Module Name:   /home/ise/Downloads/Fw__MIPS_pipeline_source_files/stalling/Stalling/PipelineMIPS_tb.v
// Project Name:  Stalling
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: PipelineMIPS
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module PipelineMIPS_tb;

	// Inputs
	reg clk;
	reg rst;
   
	//output
	wire [31:0] reg_intruction;
   wire [31:0] aluout;
   wire [31:0] mem_out;
	wire isHazard;
	wire [31:0]               d_reg1_data;
   wire [31:0]               d_reg2_data;
 wire signed [31:0]        d_reg_immediate;
 wire [4:0]                d_reg_rt;
 wire [4:0]                d_reg_rd;
 wire [4:0]                d_reg_rs;
 wire [3:0]                d_reg_ctr_ex;
 wire [2:0]                d_reg_ctr_m;
 wire [1:0]                d_reg_ctr_wb;
 wire [31:0]           e_reg_reg2_data;
 wire [4:0]            e_reg_write_reg;
 wire [2:0]            e_reg_ctr_m;
 wire [1:0]            e_reg_ctr_wb;
 wire [31:0]               m1_reg_ALU_out;
 wire [4:0]                m1_reg_write_reg;
 wire [1:0]                m1_reg_ctr_wb;
 wire [31:0]      w_write_data;
 wire [4:0]        w_reg_write;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		// Wait 100 ns for global reset to finish
		#100 $stop;;
        
		// Add stimulus here

	end
	always #5 clk = ~clk;
      
		
		// Instantiate the Unit Under Test (UUT)
	PipelineMIPS uut (
		.clk(clk), 
		.rst(rst), 
		.reg_instruction(reg_intruction),
		.ex_aluout(aluout),
		.mem_out(mem_out),
		.ishazard(isHazard),
		.d_reg1_data(d_reg1_data),
       .d_reg2_data(d_reg2_data),
       .d_reg_immediate(d_reg_immediate),
       .d_reg_rt(d_reg_rt),
        .d_reg_rd(d_reg_rd),
       . d_reg_rs(d_reg_rs),
        .d_reg_ctr_ex(d_reg_ctr_ex),
        .d_reg_ctr_m(d_reg_ctr_m),
        .d_reg_ctr_wb(d_reg_ctr_wb),
        .e_reg_reg2_data(e_reg_reg2_data),
         .e_reg_write_reg(e_reg_write_reg),
         .e_reg_ctr_m(e_reg_ctr_m),
         .e_reg_ctr_wb(e_reg_ctr_wb),
         .m1_reg_ALU_out(m1_reg_ALU_out),
         .m1_reg_write_reg(m1_reg_write_reg),
        .m1_reg_ctr_wb(m1_reg_ctr_wb),
        .w_write_data(w_write_data),
         .w_reg_write(w_write_data)
	);
	
	
endmodule

