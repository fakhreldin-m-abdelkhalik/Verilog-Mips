module DataMemory(clock,MemoryRead,MemoryWrite,Address,InputData,OutputData);

	input wire clock;
	input wire MemoryRead;
	input wire MemoryWrite;
	input wire [31:0] Address;
	input wire [31:0] InputData;
	output reg [31:0] OutputData;

	parameter DMSize = 4294967295 ;

	reg[7:0] DataMemory[0:DMSize];

	always@(posedge clock) begin

		if(MemoryRead) begin
			OutputData <= {DataMemory[Address],DataMemory[Address+1],DataMemory[Address+2],DataMemory[Address+3]};
		end	

		if(MemoryWrite) begin
			DataMemory[Address] <= InputData[31:24];
			DataMemory[Address+1] <= InputData[23:16];
			DataMemory[Address+2] <= InputData[15:8];
			DataMemory[Address+3] <= InputData[7:0];
			
		end
	end
endmodule