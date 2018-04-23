`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:00:52 12/29/2016 
// Design Name: 
// Module Name:    registers 
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
`include "macros.v"
module decode(
input wire						clk,
input wire						rst,
input wire [31:0]               instruction,
input wire						regwrite_flag,
input wire [4:0]                write_reg,
input wire [31:0]               write_data,
output reg [31:0]               reg1_data,
output reg [31:0]               reg2_data,
output reg signed [31:0]        reg_immediate,
output reg [31:0]               reg_instruction,
output reg [4:0]                reg_rt,
output reg [4:0]                reg_rd,
output reg [4:0]                reg_rs,
output reg [3:0]                reg_ctr_ex,
output reg [2:0]                reg_ctr_m,
output reg [1:0]                reg_ctr_wb,
output wire                     isHazard,
output reg [3:0]                reg_ALUcmd
          
    );
	 
	 /* define 32 32-bit width register */
	 reg	[31:0]				registers[31:0];
	 /* the CPU control signals */
	 wire                    c_regdst_flag;
     wire                   c_branch_flag;
     wire                    c_memread_flag;
     wire                    c_memtoReg_flag;
     wire [1:0]              c_ALUOp;
     wire                    c_memwrite_flag;
     wire                    c_ALUSrc_flag;
     wire                    c_regwrite_flag;
	 
	 /* the register index */
	 wire [4:0]                rs;
	 wire [4:0]                rt;
	 wire [4:0]                rd;
	 integer                   index;
	 
	 assign rs = instruction[25:21];
	 assign rt = instruction[20:16];
	 assign rd = instruction[15:11];
	 
	 /* detech the Hazard of LW instruction */
	 assign isHazard = (reg_ctr_m[1] == 1'b1) && ( (reg_rt == rs) || (reg_rt == rt));
      
	initial
    begin
	//lw $22, 1($20) load a
	 registers[0] = 32'h0000;
	 registers[1] = 32'h0000;
	 registers[2] = 32'h0000;
	 registers[3] = 32'h0000;
	 registers[4] = 32'h0005;
	 registers[5] = 32'h0006;
	 registers[6] = 32'h0000;
	 registers[7] = 32'h0000;
	 registers[8] = 32'h0000;
	 registers[9] = 32'h000A;
	 registers[10] = 32'h0000;
	 registers[11] = 32'h0000;
	 registers[12] = 32'h0000;
	 registers[13] = 32'h0000;
	 registers[14] = 32'h0000;
	 registers[15] = 32'h0000;
	 registers[16] = 32'h0000;
	 registers[17] = 32'h0000;
	 registers[18] = 32'h0000;
	 registers[19] = 32'h0000;
	 registers[20] = 32'h0000;
	 registers[21] = 32'h0000;
	 registers[22] = 32'h0023;
	 registers[23] = 32'h0000;
	 registers[24] = 32'h0000;
	 registers[25] = 32'h0000;
	 registers[26] = 32'h0000;
	 registers[27] = 32'h0000;
	 registers[28] = 32'h0000;
	 registers[29] = 32'h0000;
	 registers[30] = 32'h0000;
	 registers[31] = 32'h0000;
	 end
      /* save the registers to the next stage */
      always @(posedge clk)
      begin
        if( rst )
        begin
            reg_rt <= 0;
            reg_rd <= 0;
				reg_rs <= 0;
            reg_instruction <= 0;
            reg_immediate <= 0;
            reg1_data <= 0;
            reg2_data <= 0;
        end
        else
        begin
            if(isHazard)
            begin
                reg_rt <= reg_rt;
                reg_rd <= reg_rd;
					 reg_rs <= reg_rs;
                reg_instruction <= reg_instruction;
                reg_immediate <= reg_immediate;
                reg1_data <= reg1_data;
                reg2_data <= reg2_data;
            end
            else
            begin
                reg_rd <= rd;
                reg_rt <= rt;
					 reg_rs <= rs;
                reg_instruction <= instruction;
                reg_immediate <= instruction[15] ? {16'hFFFF, instruction[15:0]} : {16'h0, instruction[15:0]};
                /* create a bypath for reg1_data */
                if( regwrite_flag && write_reg == rs)
                    reg1_data <= write_data;
                else
                    reg1_data <= registers[rs];
                /* create a bypath for reg2_data */
					// $display("reg1_data %b",reg1_data);
					// $display("write_data %b",write_data);
					// $display("registers %b",registers[rs]);
                if(regwrite_flag && write_reg == rt)
                    reg2_data <= write_data;
                else
                    reg2_data <= registers[rt];
            end
        end
      end
	 
	 
	 /* write the register */
	 always @(negedge clk)
	 begin
		if( rst )
			begin
				for( index = 0; index < 32; index = index + 1)
				begin
					registers[ index ] <= 0; 
				end
			end
		else
			begin  
				if( regwrite_flag )
					registers[ write_reg ] <= write_data;
			end
	 end
	 
	 // Instantiate of the ALU_ctr
	 wire [5:0]    opcode;
	 wire [5:0]    funct;
	 wire [3:0]    ALUcmd;
	 assign opcode = instruction[31:26];
	 assign funct = instruction[5:0];
	 
	 /* generate the CPU control signals in the decode stage */
	 CPU_Ctr CPU_Ctr_inst (
         .instruction(        instruction         ), 
         .regdst_flag(        c_regdst_flag        ),  
         .memread_flag(       c_memread_flag    ), 
			.branch_flag(        c_branch_flag        ),
         .memtoReg_flag(      c_memtoReg_flag    ), 
         .ALUOp(              c_ALUOp            ), 
         .memwrite_flag(      c_memwrite_flag    ), 
         .ALUSrc_flag(        c_ALUSrc_flag        ), 
         .regwrite_flag(      c_regwrite_flag    )
         );
			
			ALU_Ctr ALU_Ctr_inst (
         .opcode(       opcode        ),
         .funct(        funct         ), 
         .ALUOp(        c_ALUOp       ), 
         .cmd(          ALUcmd        )
     );
	 /* combine and save the control signals */
	 always @(posedge clk)
	 begin
	   if( rst )
	   begin
	       reg_ctr_wb <= 0;
	       reg_ctr_m <= 0;
	       reg_ctr_ex <= 0;
	       reg_ALUcmd <= 0;
	   end
	   else
	   begin
	       
	       /* clear the control signals when found the Hazard or Flush  */
	       if(isHazard)
	       begin
	           reg_ctr_ex <= 0;
	           reg_ctr_m <= 0;
	           reg_ctr_wb <= 0;
	           reg_ALUcmd <= 0;
	       end
	       else
	       begin
	           reg_ALUcmd <= ALUcmd;
	           /* control signals for EX stage */
	           reg_ctr_ex[0] <= c_ALUSrc_flag;
	           reg_ctr_ex[2:1] <= c_ALUOp;
	           reg_ctr_ex[3] <= c_regdst_flag;
	           /* control signals for M stage */
	           reg_ctr_m[0] <= c_memwrite_flag;
	           reg_ctr_m[1] <= c_memread_flag;
	           reg_ctr_m[2] <= c_branch_flag;
	           /* control signals for WB stage */
	           reg_ctr_wb[0] <= c_memtoReg_flag;
	           reg_ctr_wb[1] <= c_regwrite_flag;
	       end
	   end
	 end


endmodule