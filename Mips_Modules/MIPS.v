`timescale 1ps/1ps
module MIPS;

	reg clk;
	wire [31:0] JumpReg_mux_PC;
	wire [31:0] PC_output;
	wire [31:0] PC_adder_output;
	wire [31:0] Instruction;
	wire RegDst;
	wire Jump;
	wire Branch;
	wire MemRead;
	wire MemtoReg;
	wire [2:0] ALUOp;
	wire MemWrite;
	wire ALUSrc;
	wire RegWrite;
	wire JumpAndLink;
	wire [3:0] ALU_control;
	wire JumpReg;
	wire JumpReg_mux_RF;
	wire [4:0] RtRd_mux_Jal_mux;
	wire [31:0] Sign_extension_output;
	wire [31:0] ReadData1;
	wire [31:0] ReadData2;
	wire [31:0] ALUSrc_mux_output;
	wire [31:0] Branch_adder_Branch_mux;
	wire [31:0] ALU_output;
	wire [31:0] ReadDataMemory;
	wire [31:0] MemtoReg_mux_output;
	wire [31:0] WriteData_RF;
	wire [4:0] WriteRegister;
	wire [31:0] Branch_mux_Jump_mux;
	wire [31:0] Jump_mux_JumpReg_mux;
	wire ALU_zero;
	wire PCSrc;

	//Modules
	PC ProgCounter(PC_output,JumpReg_mux_PC,clk);

	InstructionMemory IM(PC_output,Instruction);
	
	PC_ALU PC_adder(PC_output,4,PC_adder_output);
	
	control_unit CU(Instruction[31:26],RegDst,Jump,JumpAndLink,Branch,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite);
	
	mux_5 Rd_Rt_mux(RtRd_mux_Jal_mux,RegDst,Instruction[20:16],Instruction[15:11]);
	
	mux_5 Jal_mux1(WriteRegister,JumpAndLink,RtRd_mux_Jal_mux,5'b11111);
	
	mux_1 JumpReg_muxRF(JumpReg_mux_RF,JumpReg,RegWrite,1'b0);
	
	RegisterFile RF(ReadData1,ReadData2,Instruction[25:21],Instruction[20:16],WriteRegister,WriteData_RF,RegWrite,clk);
	
	SignExtension SE(Instruction[15:0],Sign_extension_output);
	
	mux_32 ALUSrc_mux(ALUSrc_mux_output,ALUSrc,ReadData2,Sign_extension_output);
	
	PC_ALU Branch_adder(PC_adder_output,{Sign_extension_output[29:0],2'b00},Branch_adder_Branch_mux);
	
	ALU MainALU(ReadData1,ALUSrc_mux_output,ALU_control,ALU_output,ALU_zero,Instruction[10:6]);	
	
	ALU_CU ALU_controller(ALU_control,JumpReg,Instruction[5:0],ALUOp);
	
	DataMemory DM(clk,MemRead,MemWrite,ALU_output,ReadData2,ReadDataMemory);
	
	and branch_condition(PCSrc,Branch,ALU_zero);
	
	mux_32 branch_mux(Branch_mux_Jump_mux,PCSrc,PC_adder_output,Branch_adder_Branch_mux);
	
	mux_32 Jump_mux(Jump_mux_JumpReg_mux,Jump,Branch_mux_Jump_mux,{PC_adder_output[31:28],Instruction[25:0],2'b00});
	
	mux_32 JumpReg_mux(JumpReg_mux_PC,JumpReg,Jump_mux_JumpReg_mux,ReadData1);
	
	mux_32 MemtoReg_mux(MemtoReg_mux_output,MemtoReg,ALU_output,ReadDataMemory);
	
	mux_32 Jal_mux2(WriteData_RF,JumpAndLink,MemtoReg_mux_output,PC_adder_output);

	
	always
	begin
		#410 clk=~clk;
	end

endmodule