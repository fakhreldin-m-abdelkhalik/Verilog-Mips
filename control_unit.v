module control_unit(
op_code,
func,
RegDst,
Jump,
JumpReg,
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
input [5:0] func;

output RegDst;
output Jump;
output JumpReg;
output JumpAndLink;
output Branch;
output MemRead;
output MemtoReg;
output [3:0] ALUOp;
output MemWrite;
output ALUSrc;
output RegWrite;

wire [5:0] op_code;
wire [5:0] func;

reg RegDst;
reg Jump;
reg JumpReg;
reg JumpAndLink;
reg Branch;
reg MemRead;
reg MemtoReg;
reg [3:0] ALUOp;
reg MemWrite;
reg ALUSrc;
reg RegWrite;

always @ (op_code or func)
begin
	if (op_code == 'h00) begin	  //R-type

		if (func == 'h20) begin   //add
			RegDst      <= 1;
			Jump        <= 0;
			JumpReg     <= 0;
			JumpAndLink <= 0;
			Branch      <= 0;
			MemRead     <= 0;
			MemtoReg    <= 0;
			ALUOp       <= 4'b0010; //add
			MemWrite    <= 0;
			ALUSrc      <= 0;
			RegWrite    <= 1;
		end
		
		if (func == 'h00) begin   //sll
			RegDst      <= 1;
			Jump        <= 0;
			JumpReg     <= 0;
			JumpAndLink <= 0;
			Branch      <= 0;
			MemRead     <= 0;
			MemtoReg    <= 0;
			ALUOp       <= 4'b1111; //TO-DO
			MemWrite    <= 0;
			ALUSrc      <= 0;
			RegWrite    <= 1;
		end

		if (func == 'h24) begin   //and
			RegDst      <= 1;
			Jump        <= 0;
			JumpReg     <= 0;
			JumpAndLink <= 0;
			Branch      <= 0;
			MemRead     <= 0;
			MemtoReg    <= 0;
			ALUOp       <= 4'b0000; //and
			MemWrite    <= 0;
			ALUSrc      <= 0;
			RegWrite    <= 1;
		end

		if (func == 'h25) begin   //or
			RegDst      <= 1;
			Jump        <= 0;
			JumpReg     <= 0;
			JumpAndLink <= 0;
			Branch      <= 0;
			MemRead     <= 0;
			MemtoReg    <= 0;
			ALUOp       <= 4'b0001; //or
			MemWrite    <= 0;
			ALUSrc      <= 0;
			RegWrite    <= 1;
		end
		
		if (func == 'h27) begin   //nor
			RegDst      <= 1;
			Jump        <= 0;
			JumpReg     <= 0;
			JumpAndLink <= 0;
			Branch      <= 0;
			MemRead     <= 0;
			MemtoReg    <= 0;
			ALUOp       <= 4'b1100; //nor
			MemWrite    <= 0;
			ALUSrc      <= 0;
			RegWrite    <= 1;
		end

		if (func == 'h2A) begin   //slt
			RegDst      <= 1;
			Jump        <= 0;
			JumpReg     <= 0;
			JumpAndLink <= 0;
			Branch      <= 0;
			MemRead     <= 0;
			MemtoReg    <= 0;
			ALUOp       <= 4'b0111; //slt
			MemWrite    <= 0;
			ALUSrc      <= 0;
			RegWrite    <= 1;
		end

		if (func == 'h08) begin   //jr
			RegDst      <= 1'bx;
			Jump        <= 0;
			JumpReg     <= 1;
			JumpAndLink <= 0;
			Branch      <= 0;
			MemRead     <= 0;
			MemtoReg    <= 1'bx;
			ALUOp       <= 4'bxxxx;
			MemWrite    <= 0;
			ALUSrc      <= 1'bx;
			RegWrite    <= 0;
		end
	end

	else if (op_code == 'h08) begin   //addi
		RegDst      <= 0;
		Jump        <= 0;
		JumpReg     <= 0;
		JumpAndLink <= 0;
		Branch      <= 0;
		MemRead     <= 0;
		MemtoReg    <= 0;
		ALUOp       <= 4'b0010; //add
		MemWrite    <= 0;
		ALUSrc      <= 1;
		RegWrite    <= 1;
	end
		
	else if (op_code == 'h23) begin   //lw
		RegDst      <= 0;
		Jump        <= 0;
		JumpReg     <= 0;
		JumpAndLink <= 0;
		Branch      <= 0;
		MemRead     <= 1;
		MemtoReg    <= 1;
		ALUOp       <= 4'b0010; //add
		MemWrite    <= 0;
		ALUSrc      <= 1;
		RegWrite    <= 1;
	end

	else if (op_code == 'h2B) begin   //sw
		RegDst      <= 1'bx;
		Jump 	    <= 0;
		JumpReg     <= 0;
		JumpAndLink <= 0;
		Branch      <= 0;
		MemRead     <= 0;
		MemtoReg    <= 1'bx;
		ALUOp       <= 4'b0010; //add
		MemWrite    <= 1;
		ALUSrc      <= 1;
		RegWrite    <= 0;
	end
	
	else if (op_code == 'h0C) begin  //andi
		RegDst      <= 0;
		Jump        <= 0;
		JumpReg     <= 0;
		JumpAndLink <= 0;
		Branch      <= 0;
		MemRead     <= 0;
		MemtoReg    <= 0;
		ALUOp       <= 4'b0000; //and
		MemWrite    <= 0;
		ALUSrc      <= 1;
		RegWrite    <= 1;
	end

	else if (op_code == 'h0D) begin //ori
		RegDst      <= 0;
		Jump        <= 0;
		JumpReg     <= 0;
		JumpAndLink <= 0;
		Branch      <= 0;
		MemRead     <= 0;
		MemtoReg    <= 0;
		ALUOp       <= 4'b0001; //or
		MemWrite    <= 0;
		ALUSrc      <= 1;
		RegWrite    <= 1;
	end
	
	else if (op_code == 'h04) begin //beq
		RegDst      <= 1'bx;
		Jump        <= 0;
		JumpReg     <= 0;
		JumpAndLink <= 0;
		Branch      <= 1;
		MemRead     <= 0;
		MemtoReg    <= 1'bx;
		ALUOp       <= 4'b0110; //sub
		MemWrite    <= 0;
		ALUSrc      <= 0;
		RegWrite    <= 0;
	end
	
	else if (op_code == 'h03) begin //jal
		RegDst      <= 1'bx;
		Jump        <= 1;
		JumpReg     <= 0;
		JumpAndLink <= 1;
		Branch      <= 0;
		MemRead     <= 0;
		MemtoReg    <= 1'bx;
		ALUOp       <= 4'bxxxx;
		MemWrite    <= 0;
		ALUSrc      <= 1'bx;
		RegWrite    <= 1;
	end

end
endmodule