`timescale 1ns / 1ps
module InstructionMemory(instruction, address);  // Mention outputs first and then inputs

/* 32-bit address */
input [31:0] address;               
output reg [31:0] instruction;
/* 1KB Instruction Memory */
reg[7:0] instruction_memory[1023:0];

wire [9:0]wordAddress;/////////////////////////////////////?????
assign wordAddress = address;//////////////////////////////?????
                      

initial
begin

	//lw $22, 1($20) 
	 instruction_memory[0] = 8'b100011_10;
	 instruction_memory[1] = 8'b100_10110;
	 instruction_memory[2] = 8'b00000000;
	 instruction_memory[3] = 8'b00000001;


        //add $4,$22,$5  
	 instruction_memory[4] = 8'b000000_00;
	 instruction_memory[5] = 8'b101_10110;
	 instruction_memory[6] = 8'b00100_000;
	 instruction_memory[7] = 8'b00_100000;


        //add $9, $4,$22 
	  instruction_memory[8] = 8'b000000_00;
	  instruction_memory[9] = 8'b100_10110;
	  instruction_memory[10] = 8'b01001_000;
	  instruction_memory[11] = 8'b00_100000;

     


/*
      //add $4,$22,$5  
	 instruction_memory[0] = 8'b000000_00;
	 instruction_memory[1] = 8'b101_10110;
	 instruction_memory[2] = 8'b00100_000;
	 instruction_memory[3] = 8'b00_100000;


        //add $9, $4,$22 
	  instruction_memory[4] = 8'b000000_00;
	  instruction_memory[5] = 8'b100_10110;
	  instruction_memory[6] = 8'b01001_000;
	  instruction_memory[7] = 8'b00_100000; 

//add $10, $4,$9 
	  instruction_memory[8] = 8'b000000_00;
	  instruction_memory[9] = 8'b100_01001;
	  instruction_memory[10] = 8'b01010_000;
	  instruction_memory[11] = 8'b00_100000;	
//add $11, $9,$10
     instruction_memory[12] = 8'b000000_01;
	  instruction_memory[13] = 8'b001_01010;
	  instruction_memory[14] = 8'b01011_000;
	  instruction_memory[15] = 8'b00_100000;*/
        //lw $22, 1($20) load d
	// instruction_memory[12] = 8'b100011_10;
	// instruction_memory[13] = 8'b100_10110;
	// instruction_memory[14] = 8'b00000000;
	// instruction_memory[15] = 8'b00000001;

        //add $9, $15 , $20 a + b
	// instruction_memory[16] = 8'b000000_01;  
	// instruction_memory[17] = 8'b111_10100;     
	// instruction_memory[18] = 8'b01001000;
	// instruction_memory[19] = 8'b00_100000;

	//sub $9, $15 , $20 a - b
	// instruction_memory[20] = 8'b000000_01;  
	// instruction_memory[21] = 8'b111_10100;     
	// instruction_memory[22] = 8'b01001000;
	// instruction_memory[23] = 8'b00_100010;


        
	//and $9, $15 , $20 c and d
	// instruction_memory[24] = 8'b000000_01;  
	// instruction_memory[25] = 8'b111_10100;     
	// instruction_memory[26] = 8'b01001000;
	// instruction_memory[27] = 8'b00_100100;

	//or $9, $15 , $20  c or d
	// instruction_memory[28] = 8'b000000_01;  
	// instruction_memory[29] = 8'b111_10100;     
	// instruction_memory[30] = 8'b01001000;
	// instruction_memory[31] = 8'b00_100101;

 	//sw $15, 0($0) store a+b
 	// instruction_memory[32] = 8'b101011_00;
 	// instruction_memory[33] = 8'b000_01111;
 	// instruction_memory[34] = 8'b00000000;
 	// instruction_memory[35] = 8'b00001100;

    
        //sw $15, 0($0) store a-b
 	// instruction_memory[36] = 8'b101011_00;
 	// instruction_memory[37] = 8'b000_01111;
 	// instruction_memory[38] = 8'b00000000;
 	// instruction_memory[39] = 8'b00001100;

      
	//sw $15, 0($0)  store a&&b
 	// instruction_memory[40] = 8'b101011_00;
 	// instruction_memory[41] = 8'b000_01111;
 	// instruction_memory[42] = 8'b00000000;
 	// instruction_memory[43] = 8'b00001100;

   
        //sw $15, 0($0)  store a||b
 	// instruction_memory[44] = 8'b101011_00;
 	// instruction_memory[45] = 8'b000_01111;
 	// instruction_memory[46] = 8'b00000000;
 	// instruction_memory[47] = 8'b00001100;

end

always@(address)
begin
instruction = {instruction_memory[wordAddress], instruction_memory[wordAddress + 1],
					 instruction_memory[wordAddress + 2], instruction_memory[wordAddress + 3]};
end


endmodule

// PC adder block should be added???????????????
