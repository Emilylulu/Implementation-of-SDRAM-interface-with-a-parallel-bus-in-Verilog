module SDRAM(clock,EnWData,EnRData,WData,BS,A,bar_CS,bar_RAS,bar_CAS,bar_WE,RData,Addr_4);
input [1:0]BS;
input [9:0]A;
input bar_CS,bar_RAS,bar_CAS,bar_WE,EnWData,EnRData,clock;
input [31:0]WData;

wire bar_CS,bar_RAS,bar_CAS,bar_WE,EnWData,EnRData,clock;
wire [1:0]BS;
wire [9:0]A;
wire [31:0]WData;

output [31:0]RData;
output [3:0]Addr_4;


reg [31:0]Bank_0[0:8];
reg [31:0]Bank_1[0:8];
reg [31:0]Bank_2[0:8];
reg [31:0]Bank_3[0:8];
reg [31:0]RData;
reg [3:0]Addr_4;


always @(posedge clock)
begin
	
	if(EnWData)//write
	begin
		
		if(BS == 2'b00)
		begin
			Bank_0[Addr_4] <= WData;
			Addr_4 = Addr_4 + 1;
		end
		else if(BS == 2'b01)
		begin
			Bank_1[Addr_4] <= WData;
			Addr_4 = Addr_4 + 1;
		end
		else if(BS == 2'b10)
		begin
			Bank_2[Addr_4] <= WData;
			Addr_4 = Addr_4 + 1;
		end
		else if(BS == 2'b11)
		begin
			Bank_3[Addr_4] <= WData;
			Addr_4 = Addr_4 + 1;
		end
		
	end

	else if(EnRData)//read
	begin
		
		if(BS == 2'b00)
		begin
			RData <= Bank_0[Addr_4];
			Addr_4 = Addr_4 + 1;
		end
		else if(BS == 2'b01)
		begin
			RData <= Bank_1[Addr_4];
			Addr_4 = Addr_4 + 1;
		end
		else if(BS == 2'b10)
		begin
			RData <= Bank_2[Addr_4];
			Addr_4 = Addr_4 + 1;
		end
		else if(BS == 2'b11)
		begin
			RData <= Bank_3[Addr_4];
			Addr_4 = Addr_4 + 1;
		end
		
	end
	else
	begin
		Addr_4 = 4'b0;
	end

end
endmodule