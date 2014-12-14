module control_unit(
op_code,
RegDst,
Jump,
JumpAndLink,
Branch,
MemRead,
MemtoReg,
ALUOp,
MemWrite,
ALUSrc,
RegWrite
);

input [5:0] op_code;

output RegDst;
output Jump;
output JumpAndLink;
output Branch;
output MemRead;
output MemtoReg;
output [2:0] ALUOp;
output MemWrite;
output ALUSrc;
output RegWrite;

wire [5:0] op_code;

reg RegDst;
reg Jump;
reg JumpAndLink;
reg Branch;
reg MemRead;
reg MemtoReg;
reg [2:0] ALUOp;
reg MemWrite;
reg ALUSrc;
reg RegWrite;

always @ (op_code)
begin
	#0.2 //delay 200ps for Control Unit
	if (op_code == 'h00) begin	  //R-type
		RegDst      <= 1;
		Jump        <= 0;
		JumpAndLink <= 0;
		Branch      <= 0;
		MemRead     <= 0;
		MemtoReg    <= 0;
		ALUOp       <= 3'b010; //func_field
		MemWrite    <= 0;
		ALUSrc      <= 0;
		RegWrite    <= 1;
	end

	else if (op_code == 'h08) begin   //addi
		RegDst      <= 0;
		Jump        <= 0;
		JumpAndLink <= 0;
		Branch      <= 0;
		MemRead     <= 0;
		MemtoReg    <= 0;
		ALUOp       <= 3'b000; //add
		MemWrite    <= 0;
		ALUSrc      <= 1;
		RegWrite    <= 1;
	end
		
	else if (op_code == 'h23) begin   //lw
		RegDst      <= 0;
		Jump        <= 0;
		JumpAndLink <= 0;
		Branch      <= 0;
		MemRead     <= 1;
		MemtoReg    <= 1;
		ALUOp       <= 3'b000; //add
		MemWrite    <= 0;
		ALUSrc      <= 1;
		RegWrite    <= 1;
	end

	else if (op_code == 'h2B) begin   //sw
		RegDst      <= 1'bx;
		Jump 	    <= 0;
		JumpAndLink <= 0;
		Branch      <= 0;
		MemRead     <= 0;
		MemtoReg    <= 1'bx;
		ALUOp       <= 3'b000; //add
		MemWrite    <= 1;
		ALUSrc      <= 1;
		RegWrite    <= 0;
	end
	
	else if (op_code == 'h0C) begin  //andi
		RegDst      <= 0;
		Jump        <= 0;
		JumpAndLink <= 0;
		Branch      <= 0;
		MemRead     <= 0;
		MemtoReg    <= 0;
		ALUOp       <= 3'b011; //and
		MemWrite    <= 0;
		ALUSrc      <= 1;
		RegWrite    <= 1;
	end

	else if (op_code == 'h0D) begin //ori
		RegDst      <= 0;
		Jump        <= 0;
		JumpAndLink <= 0;
		Branch      <= 0;
		MemRead     <= 0;
		MemtoReg    <= 0;
		ALUOp       <= 3'b100; //or
		MemWrite    <= 0;
		ALUSrc      <= 1;
		RegWrite    <= 1;
	end
	
	else if (op_code == 'h04) begin //beq
		RegDst      <= 1'bx;
		Jump        <= 0;
		JumpAndLink <= 0;
		Branch      <= 1;
		MemRead     <= 0;
		MemtoReg    <= 1'bx;
		ALUOp       <= 3'b001; //sub
		MemWrite    <= 0;
		ALUSrc      <= 0;
		RegWrite    <= 0;
	end
	
	else if (op_code == 'h03) begin //jal
		RegDst      <= 1'bx;
		Jump        <= 1;
		JumpAndLink <= 1;
		Branch      <= 0;
		MemRead     <= 0;
		MemtoReg    <= 1'bx;
		ALUOp       <= 3'bxxx;
		MemWrite    <= 0;
		ALUSrc      <= 1'bx;
		RegWrite    <= 1;
	end

end
endmodule
