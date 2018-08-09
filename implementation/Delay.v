
module Delay(ProgramData,clock,Load_tPRE,Load_tCAS,Load_tBURST,Load_tWAIT,tLAT,CountOut);
input [9:0]ProgramData;
input Load_tPRE,Load_tCAS,Load_tBURST,Load_tWAIT,clock;

output [1:0]tLAT;
output [2:0]CountOut;


wire Load_tPRE,Load_tCAS,Load_tBURST,Load_tWAIT,clock;
wire [9:0]ProgramData;

reg [1:0]tLAT;
reg [2:0]CountOut;


always @(posedge clock)
begin
	if(Load_tPRE)
	begin
		CountOut = 3'b100;
	end
	else if(Load_tCAS)
	begin
		CountOut = 3'b110;//tCAS change to 4 cycle
	end
	else if(Load_tBURST)
	begin
		CountOut = 3'b111;
	end
	else if(Load_tWAIT)
	begin
		CountOut = 3'b100;
	end
	
	else if(CountOut > 3'b000)
	begin
		 CountOut = CountOut - 1;
	end
	tLAT = 2'b00;
end

endmodule
