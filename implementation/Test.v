`timescale 10ps/1ps
module test;

wire[31:0] RData;
wire[1:0] tLAT,BS;
wire [2:0] CountOut;
wire BIWEn,BIREn,Load_tPRE,Load_tCAS,Load_tBURST,Load_tWAIT,Ready,StoreReg,EnWData,EnRData,bar_CS,bar_RAS,bar_CAS,bar_WE,SelRow,SelCol;
wire[3:0] Addr_4;
wire[9:0] A;
wire [2:0]state,counter;

reg clock;
reg [31:0]WData;
reg [31:0]Addr_32;
reg [9:0]ProgramData;
reg Write,Status;
reg [2:0]Burst;
 


Control control(
	.Status(Status),
	.clock(clock),
	.state(state),
	.counter(counter),
	.Write(Write),
	.Burst(Burst),
	.tLAT(tLAT),
	.CountOut(CountOut),
	.BIWEn(BIWEn),
	.BIREn(BIREn),
	.Load_tPRE(Load_tPRE),
	.Load_tCAS(Load_tCAS),
	.Load_tBURST(Load_tBURST),
	.Load_tWAIT(Load_tWAIT),
	.Ready(Ready),
	.StoreReg(StoreReg),
	.EnWData(EnWData),
	.EnRData(EnRData),
	.bar_CS(bar_CS),
	.bar_RAS(bar_RAS),
	.bar_CAS(bar_CAS),
	.bar_WE(bar_WE),
	.SelRow(SelRow),
	.SelCol(SelCol)
	);

	SDRAM SDram(
		.clock(clock),
		.WData(WData),
		.EnWData(EnWData),
		.EnRData(EnRData),
		.BS(BS),
		.A(A),
		.bar_CS(bar_CS),
		.bar_RAS(bar_RAS),
		.bar_CAS(bar_CAS),
		.bar_WE(bar_WE),
		.Addr_4(Addr_4),
		.RData(RData)
	);

	Addr addr(
		.ProgramData(ProgramData), 
		.clock(clock),
		.StoreReg(StoreReg), 
		.Addr_32(Addr_32), 
		.Status(Status), 
		.Write(Write), 
		.SelRow(SelRow), 
		.SelCol(SelCol),
		.BIWEn(BIWEn), 
		.BIREn(BIREn), 
		.BS(BS), 
		.A(A)
	);

	Delay delay(
		.ProgramData(ProgramData),
		
		.clock(clock),
		.Load_tPRE(Load_tPRE),
		.Load_tCAS(Load_tCAS),
		.Load_tBURST(Load_tBURST),
		.Load_tWAIT(Load_tWAIT),
		.tLAT(tLAT),
		.CountOut(CountOut)
	);
	

	initial
	begin
		clock = 1'b1;
		ProgramData = 10'b0000010100;
		Status = 1'b1;
		Write = 1'b1;
		Burst = 3'b111;
		Addr_32 =32'b00000000000000000000001111111111;//column 1,row 0,bank 0,Addr 0
		
		forever #10 clock = ~clock;
	end//initial all virable
	
	always@(posedge clock)
	begin
		
		
		if(EnWData == 1'b1)
		begin
			
			WData = WData + 1;
			Addr_32 = Addr_32 + 1;
			
			
		end
		else if((state == 3'b100 && CountOut > 3'b001)||(state == 3'b011 && CountOut > 3'b010))
		begin
			Status = 1'b0;
			Write = 1'b0;
		end
		else 
		begin
			Status = 1'b1;
			WData = 32'b0;
		end
	
	end	
endmodule