`timescale 1ps/1ps
module InstructionMemory(PC,Instruction);
	
	input wire [31:0] PC;
	output wire [31:0] Instruction;

	parameter IMSize = 1024;

	reg[31:0] InstructionMemory[0:IMSize];
	
	assign #200 Instruction = InstructionMemory[PC];	

endmodule


