`timescale 1ps/1ps
module TB_Odd_Decrement;

integer i;
reg [23:0] Registers[0:31];

MIPS cpu();

initial begin
	cpu.ProgCounter.OUT = 0;
	cpu.clk = 0;
	Registers[0]  = "$0";  Registers[1]  = "$at"; Registers[2]  = "$v0"; Registers[3] = "$v1";
	Registers[4]  = "$a0"; Registers[5]  = "$a1"; Registers[6]  = "$a2"; Registers[7] = "$a3";
	Registers[8]  = "$t0"; Registers[9]  = "$t1"; Registers[10] = "$t2"; Registers[11] = "$t3";
	Registers[12] = "$t4"; Registers[13] = "$t5"; Registers[14] = "$t6"; Registers[15] = "$t7";
	Registers[16] = "$s0"; Registers[17] = "$s1"; Registers[18] = "$s2"; Registers[19] = "$s3";
	Registers[20] = "$s4"; Registers[21] = "$s5"; Registers[22] = "$s6"; Registers[23] = "$s7";
	Registers[24] = "$t8"; Registers[25] = "$t9"; Registers[26] = "$k0"; Registers[27] = "$k1";
	Registers[28] = "$gp"; Registers[29] = "$sp"; Registers[30] = "$fp"; Registers[31] = "$ra";
	
	$readmemb("Instructions.txt", cpu.IM.InstructionMemory);
	
	#62320

	$display("Final value of PC = %h", cpu.ProgCounter.OUT);
	for (i = 0; i < 32; i = i + 1) begin
		$display("%s = %h", Registers[i], cpu.RF.Registers[i]);
	end
	
	$stop;
end
endmodule