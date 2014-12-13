module InstructionMemory(PC,Instruction);
	
	input wire [31:0] PC;
	output wire [31:0] Instruction;
	integer file;

	parameter IMSize = 1024;

	reg[7:0] InstructionMemory[0:IMSize];

	initial begin
		$readmemh("C:/Users/Youssef/Desktop/jil",InstructionMemory);
	end
	
	assign Instruction = {InstructionMemory[PC],InstructionMemory[PC+1],InstructionMemory[PC+2],InstructionMemory[PC+3]};	

endmodule


