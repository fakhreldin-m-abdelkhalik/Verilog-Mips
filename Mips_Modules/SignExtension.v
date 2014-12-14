module SignExtension(InputData,OutputData);
	input [15:0]InputData;
	output reg [31:0]OutputData;
	
	always @(InputData) begin
		if(InputData[15] == 1) 
			begin
			OutputData <={-1,InputData};
			end	
		else
			begin
			OutputData <=InputData;
			end
		end
endmodule