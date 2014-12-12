
module ALU(ALU_reg_1, ALU_reg_2, ALU_control, ALU_out , ALU_zero , shamt);

input wire [31:0] ALU_reg_1;
input wire [31:0] ALU_reg_2;
input wire [3:0] ALU_control;
input wire [4:0] shamt;

output reg [31:0] ALU_out;
output reg ALU_zero;


always@(ALU_reg_1, ALU_reg_2, ALU_control) begin 
case(ALU_control)
4'b0000 : ALU_out <= ALU_reg_1 & ALU_reg_2;         //AND
4'b0001 : ALU_out <= ALU_reg_1 | ALU_reg_2;         //OR
4'b0010 : ALU_out <= ALU_reg_1 + ALU_reg_2;         //ADD
4'b0110 : ALU_out <= ALU_reg_1 - ALU_reg_2;         //SUB
4'b0111 : ALU_out <= ALU_reg_1 < ALU_reg_2 ? 1 : 0; //SLT
4'b1100 : ALU_out <= ~(ALU_reg_1 | ALU_reg_2) ;     //NOR
4'b1111 : ALU_out <=  ALU_reg_2 << shamt;
default : ALU_out <= 0;
endcase
end

always@(ALU_out)begin
case(ALU_out)
0 : ALU_zero <= 1;
default : ALU_zero <= 0;
endcase
end
endmodule