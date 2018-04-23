`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:15:58 12/29/2016 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
input wire signed [31:0]		opa,
input wire signed [31:0]		opb,
input wire [3:0]				cmd,
output wire signed [31:0]		res
    );
		
	wire [5:0]				     shift;
	
	
	
	/* the ALU operation */
	assign shift = opb[5:0];
	assign res = OUT(opa, opb, shift, cmd);
					
	function signed [31:0] OUT;
		input signed [31:0] opa;
		input signed [31:0] opb;
		input [5:0]			   shift;
		input [3:0]	 		   cmd;
		begin
			case( cmd )
			`ALU_AND: 	OUT = opa & opb;
			`ALU_OR:  	OUT = opa | opb;
         `ALU_ADD:   OUT = opa + opb;
         `ALU_SUB:   OUT = opa - opb;
			`ALU_SLT: 	OUT = (opa < opb) ? 32'd1 : 32'd0;
			`ALU_NOR: 	OUT = ~(opa | opb);
			`ALU_XOR: 	OUT = opa ^ opb;
			`ALU_LU:	OUT = {opb[15:0], 16'h0};
			`ALU_SLLV:	OUT = opa << shift;
			`ALU_SRLV:	OUT = opa >> shift;
			default: OUT = 32'hxxxxxxxx;
			endcase
		end
	endfunction

endmodule