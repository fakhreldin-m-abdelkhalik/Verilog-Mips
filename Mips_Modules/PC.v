module PC(OUT,IN,clk);
	input [31:0] IN;
	input clk;
	output [31:0] OUT;
	wire [31:0] IN;
	wire clk;	
	reg [31:0] OUT;
	always @(posedge clk)
	begin
		OUT<=IN;
	end
endmodule
	