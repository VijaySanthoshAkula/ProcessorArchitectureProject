`timescale 1ns / 1ps

`include "macros.v"
module fetch(
input wire							clk,
input wire							rst,
input wire                          isHazard,
output reg [31:0]                   reg_instruction
 );

	
	wire [31:0]                instruction;
	reg  [31:0]                pc1;
	/* calculate the output PC */
	initial
    begin
   pc1=0;
	end
InstructionMemory 	InstructionMemory_inst (
.address(pc1),
.instruction(instruction)
);
	/* deal with other ocasions */
	always@(posedge clk)
	begin
		if( rst )
		  begin
			pc1 <= 0;
			reg_instruction <= 0;
		  end
		else
			begin
                 /* stall when found the Hazard signal */
			    if( isHazard  )
			     begin
			        pc1 <= pc1;
                 reg_instruction <= reg_instruction;
				 end
				else
				 begin
				    pc1 <= pc1+3'd4;
				    reg_instruction <= instruction;
				 end   
			end
	end
endmodule