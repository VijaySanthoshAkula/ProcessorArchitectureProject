`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/01/11 15:53:54
// Design Name: 
// Module Name: execute
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "macros.v"

module execute(
input wire                  clk,
input wire                  rst,
input wire [3:0]            ctr_ex,
input wire [2:0]            ctr_m,
input wire [1:0]            ctr_wb,
input wire [31:0]           reg1_data,
input wire [31:0]           reg2_data,
input wire signed [31:0]    immediate,
input wire [4:0]            rt,
input wire [4:0]            rd,
input wire [4:0]            rs,
input [3:0]                 ALUcmd,
output reg [31:0]           reg_ALU_out,
output reg [31:0]           reg_reg2_data,
output reg [4:0]            reg_write_reg,
output reg [2:0]            reg_ctr_m,
output reg [1:0]            reg_ctr_wb,
input wire [4:0]                ex_write_reg,//
input wire                      ex_regwrite_flag,//
input wire [4:0]                mem_write_reg,//
input wire                      mem_regwrite_flag,//

input wire [31:0]           ex_mem_data,
input wire [31:0]           mem_wb_data
    );
    
       /* ALU related signals */
      wire                  ALUSrc_flag;
      wire [31:0]           ALU_out;
      wire                  regdst_flag;
      
      wire [31:0]           ALU_opa;
      wire [31:0]           ALU_opb;
      wire [31:0]           ALU_opb2;
      wire [4:0]            ex1_write_reg;
      /* the write reg */
      assign regdst_flag = ctr_ex[3];
      /* pass on the bypass related signal to the ID stage */
      assign ex1_write_reg = (regdst_flag) ? rd : rt;
      assign ex1_regwrite_flag = ctr_wb[1];
      assign ALUSrc_flag = ctr_ex[0];
      
		wire [1:0]                    forward_a;
	   wire [1:0]                    forward_b;
	  /* instantiate of the bypass control unit */

	 
	 forwardingUnit forwardingUnit_inst(
        .id_ex_rs(                  rs                          ),
        .id_ex_rt(                  rt                          ),
        .ex_mem_rd(                 ex_write_reg                ),
        .mem_wb_rd(                 mem_write_reg             ),
        .ex_mem_regwrite_flag(      ex_regwrite_flag               ),
        .mem_wb_regwrite_flag(      mem_regwrite_flag           ),
        .forward_a(                 forward_a                   ),
        .forward_b(                 forward_b                   )
      );
		always @*begin
		$display("rs %b,rt %b,ex_write_reg %b,mem_write_reg %b,ex_regwrite_flag %b,mem_regwrite_flag %b",rs,rt,ex_write_reg,mem_write_reg,ex_regwrite_flag,mem_regwrite_flag );
	 $display("forward_a %b,forward_b %b,reg1_data %b,ex_mem_data %b,mem_wb_data %b",forward_a ,forward_b,reg1_data,ex_mem_data,mem_wb_data );
      end/* the bypath for the OPA */
      bypath bypath_inst_opa(
        .reg_data(      reg1_data       ),
        .ex_mem_data(   ex_mem_data     ),
        .mem_wb_data(   mem_wb_data     ),
        .sel(           forward_a       ),
        .out(           ALU_opa         )
      );
      
      /* the bypath for the OPB */
      bypath bypath_inst_opb(
        .reg_data(      reg2_data       ),
        .ex_mem_data(   ex_mem_data     ),
        .mem_wb_data(   mem_wb_data     ),
        .sel(           forward_b       ),
        .out(           ALU_opb         )
      );
      
      /* the bypath for the OPB */
      bypath2 bypath2_inst(
        .reg_data(      reg2_data       ),
        .ex_mem_data(   ex_mem_data     ),
        .mem_wb_data(   mem_wb_data     ),
        .immediate(     immediate       ),
        .ALUSrc_flag(   ALUSrc_flag     ),
        .sel(           forward_b       ),
        .out(           ALU_opb2         )
      );
      
     

//Instantiate of the ALU 	 
    ALU ALU_inst (
        .opa(			ALU_opa			    ), 
        .opb(			ALU_opb2			), 
        .cmd(			ALUcmd				), 
        .res(			ALU_out				)
    );
    
	       /* pass on the control signals to next stage */
      always @(posedge clk)
      begin
        if( rst )
        begin
            reg_ctr_m <= 0;
            reg_ctr_wb <= 0;   
            reg_ALU_out <= 0;
            reg_reg2_data <= 0;
            reg_write_reg <= 0; 
        end
        else
        begin
            
                reg_ctr_m <= ctr_m;
                reg_ctr_wb <= ctr_wb;
                reg_ALU_out <= ALU_out;
                reg_reg2_data <= ALU_opb;
                reg_write_reg <= ex1_write_reg;
            
        end
      end

endmodule