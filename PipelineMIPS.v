`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/01/11 19:01:08
// Design Name: 
// Module Name: PipelineMIPS
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


module PipelineMIPS(
input wire                  clk,
input wire                  rst,
output reg [31:0]                   reg_instruction,
output reg [31:0]   ex_aluout,
output reg [31:0]   mem_out,
output reg ishazard,
output reg [31:0]               d_reg1_data,
output reg [31:0]               d_reg2_data,
output reg signed [31:0]        d_reg_immediate,
output reg [4:0]                d_reg_rt,
output reg [4:0]                d_reg_rd,
output reg [4:0]                d_reg_rs,
output reg [3:0]                d_reg_ctr_ex,
output reg [2:0]                d_reg_ctr_m,
output reg [1:0]                d_reg_ctr_wb,
output reg [31:0]           e_reg_reg2_data,
output reg [4:0]            e_reg_write_reg,
output reg [2:0]            e_reg_ctr_m,
output reg [1:0]            e_reg_ctr_wb,
output reg [31:0]               m1_reg_ALU_out,
output reg [4:0]                m1_reg_write_reg,
output reg [1:0]                m1_reg_ctr_wb,
output reg [31:0]      w_write_data,
output reg [4:0]        w_reg_write
    );
    
    /* the IF stage */
    
    wire [31:0]             if_reg_instruction;
    
    /* the ID stage */
     wire [31:0]             id_reg1_data;
     wire [31:0]             id_reg2_data;
     wire [31:0]             id_reg_immediate;
     wire [4:0]              id_reg_rt;
     wire [4:0]              id_reg_rd;
	  wire [4:0]              id_reg_rs;
     wire [31:0]             id_reg_instruction;
     wire [3:0]              id_reg_ctr_ex;
     wire [2:0]              id_reg_ctr_m;
     wire [1:0]              id_reg_ctr_wb;
     wire                    isHazard;
     wire [3:0]              id_reg_ALUcmd;
     
     
     /* the EX stage */
     wire [31:0]             ex_reg_ALU_out;
     wire [31:0]             ex_reg_reg2_data;
     wire [4:0]              ex_reg_write_reg;
     wire [2:0]              ex_reg_ctr_m;
     wire [1:0]              ex_reg_ctr_wb;
     wire [4:0]              ex_write_reg;
     wire                    ex_regwrite_flag;
     wire [1:0]              ex_reg_forward_a;
     wire [1:0]              ex_reg_forward_b;
     
     /* the MEM stage */
     wire [31:0]             m_reg_mem_out;
     wire [31:0]             m_reg_ALU_out;
     wire [4:0]              m_reg_write_reg;
     wire [1:0]              m_reg_ctr_wb;
     wire [31:0]             m_writeback;
     
     /* the WB stage */
     wire [31:0]             wb_write_data;
	  wire [4:0]              wb_write_reg;
     wire                    wb_regwrite_flag;
     
    /* the IF stage */
    fetch fetch_inst(
        .clk(               clk                 ),
        .rst(               rst                 ),
        .isHazard(          isHazard            ),
        .reg_instruction(   if_reg_instruction  )
    );
    
 
    /* the ID stage */
    decode decode_inst(
        .clk(               clk                 ),
        .rst(               rst                 ),
        .instruction(       if_reg_instruction  ),
        .regwrite_flag(     wb_regwrite_flag    ),
        .write_reg(         wb_write_reg     ),
        .write_data(        wb_write_data       ),
        .reg1_data(         id_reg1_data        ),
        .reg2_data(         id_reg2_data        ),
        .reg_immediate(     id_reg_immediate    ),
        .reg_instruction(   id_reg_instruction  ),
        .reg_rt(            id_reg_rt           ),
        .reg_rd(            id_reg_rd           ),
		  .reg_rs(id_reg_rs),
        .reg_ctr_ex(        id_reg_ctr_ex       ),
        .reg_ctr_m(         id_reg_ctr_m        ),
        .reg_ctr_wb(        id_reg_ctr_wb       ),
        .isHazard(          isHazard            ),
        .reg_ALUcmd(        id_reg_ALUcmd       )
        
    );
    

    /* the EX stage */
    execute execute_inst(
        .clk(               clk                 ),
        .rst(               rst                 ),
        .ctr_ex(            id_reg_ctr_ex       ),
        .ctr_m(             id_reg_ctr_m        ),
        .ctr_wb(            id_reg_ctr_wb       ),
        .reg1_data(         id_reg1_data        ),
        .reg2_data(         id_reg2_data        ),
        .immediate(         id_reg_immediate    ),
        .rt(                id_reg_rt           ),
        .rd(                id_reg_rd           ),
		  .rs(id_reg_rs),
        .ALUcmd(            id_reg_ALUcmd       ),
        .reg_ALU_out(       ex_reg_ALU_out      ),
        .reg_reg2_data(     ex_reg_reg2_data    ),
        .reg_write_reg(     ex_reg_write_reg    ),
        .reg_ctr_m(         ex_reg_ctr_m        ),
        .reg_ctr_wb(        ex_reg_ctr_wb       ),
		  
		  .ex_write_reg(      ex_reg_write_reg       ),
        .ex_regwrite_flag(  ex_reg_ctr_wb[1]    ),
		  .mem_write_reg(  m_reg_write_reg         ),
        .mem_regwrite_flag(  m_reg_ctr_wb[1]           ),
        .ex_mem_data(       ex_reg_ALU_out      ),
        .mem_wb_data(       m_writeback      )
        
        
       
        
    );
    
    /* the MEM stage */
    mem     mem_inst(
        .clk(               clk                 ),
        .rst(               rst                 ),
        .ctr_m(             ex_reg_ctr_m        ),
        .ctr_wb(            ex_reg_ctr_wb       ),
        .ALU_out(           ex_reg_ALU_out      ),
        .reg2_data(         ex_reg_reg2_data    ),
        .write_reg(         ex_reg_write_reg    ),
        .readData(       m_reg_mem_out       ),
        .reg_ALU_out(       m_reg_ALU_out       ),
        .reg_write_reg(     m_reg_write_reg     ),
        .reg_ctr_wb(        m_reg_ctr_wb        ),
		  .writeback(m_writeback)
    );
    
    /* the WB stage */
    writeback   writeback_inst(
	     .clk(               clk                 ),
        .rst(               rst                 ),
        .ctr_wb(            m_reg_ctr_wb        ),
        .mem_out(           m_reg_mem_out       ),
        .ALU_out(           m_reg_ALU_out       ),
		  .write_reg(m_reg_write_reg),
        .write_data(        wb_write_data       ),
        .regwrite_flag(     wb_regwrite_flag    ),
        .reg_write(wb_write_reg)		  
    );
    
    always@(posedge clk)
	begin
	   reg_instruction=if_reg_instruction;
		ex_aluout=ex_reg_ALU_out;
		mem_out=m_reg_mem_out;
		ishazard=isHazard;
		d_reg1_data=id_reg1_data;
		d_reg2_data=id_reg2_data;
      d_reg_immediate=id_reg_immediate;
      
d_reg_rt=id_reg_rt;
d_reg_rd=id_reg_rd;
d_reg_rs=id_reg_rs;
d_reg_ctr_ex=id_reg_ctr_ex;
d_reg_ctr_m=id_reg_ctr_m;
d_reg_ctr_wb=id_reg_ctr_wb;
e_reg_reg2_data=ex_reg_reg2_data;
e_reg_write_reg=ex_reg_write_reg;
e_reg_ctr_m=ex_reg_ctr_m;
e_reg_ctr_wb=ex_reg_ctr_wb;
m1_reg_ALU_out=m_reg_ALU_out;
m1_reg_write_reg=m_reg_write_reg;
m1_reg_ctr_wb=m_reg_ctr_wb ;
w_write_data=wb_write_data ;
w_reg_write=wb_write_reg;
	end
endmodule