module InstructionMemory(clock,PC,Instruction);
	
	input wire clock;
	input wire [31:0] PC;
	output reg [31:0] Instruction;

	parameter IMSize = 1024;

	reg[7:0] InstructionMemory[0:IMSize];

	initial begin
		$readmemh("file",memory);
	end
	
	assign Instruction <= {InstructionMemory[PC],InstructionMemory[PC+1],InstructionMemory[PC+2],InstructionMemory[PC+3]};	

endmodule


