`timescale 1ns / 1ps
`include "macros.v"


module writeback(
input wire                      clk,
input wire                      rst,
input wire [1:0]        ctr_wb,
input wire [31:0]       mem_out,
input wire [31:0]       ALU_out,
input wire [4:0]        write_reg,
output reg [31:0]      write_data,
output reg             regwrite_flag,
output reg [4:0]        reg_write
    );
    
    wire memtoReg_flag ;
	 wire regwriteflag;
	 wire [31:0] writedata;
    assign memtoReg_flag = ctr_wb[0];
    assign regwriteflag = ctr_wb[1];
    assign writedata = (memtoReg_flag) ? mem_out : ALU_out;
    
	 always @(negedge clk)
      begin
        if( rst )
        begin
            write_data<=0;
    reg_write <= 0;
	 regwrite_flag<=0;
        end
        else
        begin
           
                write_data<=writedata;
    reg_write <= write_reg;
	 regwrite_flag<=regwriteflag;
                
           
        end
      end
	
endmodule