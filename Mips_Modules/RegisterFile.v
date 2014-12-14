module RegisterFile (ReadData1 ,ReadData2 ,ReadRegister1 ,ReadRegister2 ,WriteRegister ,WriteData ,RegWrite ,clk);

//outputs declaration
output [31:0] ReadData1 ;
wire [31:0] ReadData1 ;
output [31:0] ReadData2 ;
wire [31:0] ReadData2 ;

//inputs declaration
input [4:0] ReadRegister1 ;
wire [4:0] ReadRegister1 ;
input [4:0] ReadRegister2 ;
wire [4:0] ReadRegister2 ;
input [4:0] WriteRegister ;
wire [4:0] WriteRegister ;
input [31:0] WriteData ;
wire [31:0] WriteData ;
input RegWrite ;
wire RegWrite ;	 
input clk;
wire clk;

//inside module
reg [31:0] Registers [31:0];

//Reading from registers
assign  ReadData1=(ReadRegister1==5'b0) ? 32'b0 : Registers[ReadRegister1];
assign  ReadData2=(ReadRegister2==5'b0) ? 32'b0 : Registers[ReadRegister2];

//Writing in registers
always @(posedge clk)	
begin
	if(RegWrite&&WriteRegister!=0) 
			Registers[WriteRegister]<=WriteData;
end

initial
begin
	Registers[0]=0;
end

endmodule
