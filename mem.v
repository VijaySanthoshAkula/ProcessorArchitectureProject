`timescale 1ns / 1ps
`include "macros.v"

module mem(
input wire                      clk,
input wire                      rst,
input wire [5:0]                ctr_m,
input wire [1:0]                ctr_wb,
input wire [31:0]               ALU_out,
input wire [31:0]               reg2_data,
input wire [4:0]                write_reg,
output reg [31:0]               readData,
output reg [31:0]               reg_ALU_out,
output reg [4:0]                reg_write_reg,
output reg [1:0]                reg_ctr_wb,
output reg [31:0]              writeback
);

wire MemWrite,MemRead;
assign MemWrite = ctr_m[0];
assign MemRead = ctr_m[1];
reg [7:0] memory[511:0];
reg [8:0] i;

initial
begin
   memory[0] = 8'h07;
   memory[1] = 8'h0f;
	memory[2] = 8'h0a;
	memory[3] = 8'h0f;
	memory[4] = 8'h00;
	memory[5] = 8'h00;
	memory[6] = 8'h00;
	memory[7] = 8'h03;

	memory[8] = 8'h00;
	memory[9] = 8'h11;
	memory[10] = 8'hff;
	memory[11] = 8'h01;

end

 always@(negedge clk)
 begin
		if(MemWrite)
		begin

		  	memory[ALU_out] = reg2_data[31:24];
		 	memory[ALU_out+1] = reg2_data[23:16];
		  	memory[ALU_out+2] = reg2_data[15:8];
		  	memory[ALU_out+3] = reg2_data[7:0];

		end
 end
   
   
always@(ALU_out)
begin
if(MemRead)
begin
 readData = {memory[ALU_out<<2],memory[(ALU_out<<2)+1],memory[(ALU_out<<2)+2],memory[(ALU_out<<2)+3]};
end
 end

 initial
 begin
 	#191 begin
	 	for(i=0; i<128; i=i+1)
	 	begin
	 		$display("Mem[%d]: %b \n",i,{memory[i*4],memory[i*4+1],memory[i*4+2],memory[i*4+3]});
	 	end
 	end
 end
 wire [31:0] writedata;
assign writedata = (ctr_wb[0]) ? readData : ALU_out;
 /* save the registers to the next stage */
      always @(posedge clk)
      begin
        if( rst )
        begin
            reg_ALU_out <= 0;
            reg_write_reg <= 0;
            reg_ctr_wb <= 0;
				writeback<=0;
        end
        else
        begin
           
                reg_ALU_out <= ALU_out;
                reg_write_reg <= write_reg;
                reg_ctr_wb <= ctr_wb;
                writeback<=writedata;
           
        end
      end
	 
endmodule
