`timescale 1 ns / 1 ps

module RegisterFile (ReadData1 ,ReadData2 ,ReadRegister1 ,ReadRegister2 ,WriteRegister ,WriteData ,RegWrite ,clk);

//outputs declaration
output [31:0] ReadData1 ;
reg [31:0] ReadData1 ;
output [31:0] ReadData2 ;
reg [31:0] ReadData2 ;

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
always @(ReadRegister1 or ReadRegister2 or Registers[ReadRegister1] or Registers[ReadRegister2])
begin
	if(ReadRegister1==0)
		ReadData1<=0;
	else	
		ReadData1<=Registers[ReadRegister1];
	if(ReadRegister2==0)
		ReadData2<=0;
	else	
		ReadData2<=Registers[ReadRegister2];
end	

//Writing in registers
always @(posedge clk)	
begin
	if(RegWrite&&WriteRegister!=0) 
			Registers[WriteRegister]<=WriteData;
end
endmodule
