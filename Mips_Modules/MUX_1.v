module mux_1(out, s, in1, in2);

	input s;
	input in1;
	input in2;

	output out;

	wire s;
	wire in1;
	wire in2;

	reg out;

	always @ (s or in1 or in2) begin
	
		if (s)
			out <= in2;
		else
			out <= in1;
	end

endmodule
