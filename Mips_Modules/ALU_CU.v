module ALU_CU(ALU_control, JumpReg, func, ALUOp);

input  [5:0] func;
input  [2:0] ALUOp;

output [3:0] ALU_control;
output JumpReg;

wire  [5:0] func;
wire  [2:0] ALUOp;

reg   [3:0] ALU_control;
reg   JumpReg;

always @ (ALUOp or func) begin
		#0.1 //delay 100ps for ALU-ControlUnit
		
		if (ALUOp == 'b000) begin       //add
			JumpReg       <= 0;
			ALU_control <= 4'b0010;
		end
		
		else if (ALUOp == 'b001) begin	 //sub
			JumpReg     <= 0;
			ALU_control <= 4'b0110;
		end
		
		else if (ALUOp == 'b011) begin  //and
			JumpReg     <= 0;
			ALU_control <= 4'b0000;
		end
		
		else if (ALUOp == 'b100) begin  //or	 
			JumpReg     <= 0;
			ALU_control <= 4'b0001;
		end

		else if (ALUOp == 'b010) begin	  //func_field

			if (func == 'h20) begin   //add
				JumpReg     <= 0;
				ALU_control <= 4'b0010; //add
			end
		
			else if (func == 'h00) begin   //sll
				JumpReg     <= 0;
				ALU_control <= 4'b1111; //TO-DO
			end

			else if (func == 'h24) begin   //and
				JumpReg     <= 0;
				ALU_control <= 4'b0000; //and
			end

			else if (func == 'h25) begin   //or
				JumpReg     <= 0;
				ALU_control <= 4'b0001; //or
			end
		
			else if (func == 'h27) begin   //nor
				JumpReg     <= 0;
				ALU_control <= 4'b1100; //nor
			end

			else if (func == 'h2A) begin   //slt
				JumpReg     <= 0;
				ALU_control <= 4'b0111; //slt
			end

			else if (func == 'h08) begin   //jr
				JumpReg     <= 1;
				ALU_control <= 4'bxxxx;
			end
		end
end
endmodule