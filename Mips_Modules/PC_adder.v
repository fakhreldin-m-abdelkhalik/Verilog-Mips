module PC_ALU(in1, in2, pc_out);

input wire [31:0] in1;
input wire [31:0] in2;
output reg [31:0] pc_out;


always@(in1 or in2) begin 
#0.1 //delay 100ps for PC adder
pc_out <= in1 + in2;         //ADD

end

endmodule