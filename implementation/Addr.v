
module Addr(clock,ProgramData,StoreReg,Addr_32,Status,Write,SelRow,SelCol,BIWEn, BIREn,BS,A);
input StoreReg;
input Status;
input Write,clock;
input SelRow;
input SelCol;
input [9:0]ProgramData;
input [31:0]Addr_32;

output BIWEn, BIREn;
output [1:0]BS;
output [9:0]A;

wire StoreReg,Status,Write,SelRow,SelCol;
wire [9:0]ProgramData;
wire [31:0]Addr_32;

reg BIWEn, BIREn;
reg [1:0]BS;
reg [9:0]A;

always @(posedge clock)
begin
	if(SelRow == 1'b1)
	begin
		A <= Addr_32[19:10];
	end
	else if(SelCol == 1'b1)
	begin
		A <= Addr_32[9:0];
	end
	
	else 
	begin
		A <= 10'bz;
	end
	BS <= Addr_32[21:20];

	if(Status == 1'b1 && Write == 1'b1 && (Addr_32[31:28] == 4'b0))
	begin
		BIWEn <= 1'b1;
		BIREn <= 1'b0;
	end
	else if(Status == 1'b1 && Write == 1'b0 && (Addr_32[31:28] == 4'b0))
	begin
		BIREn <= 1'b1;
		BIWEn <= 1'b0;		
	end
	else
	begin
		BIREn <= 1'b0;
		BIWEn <= 1'b0;
	end
end

endmodule