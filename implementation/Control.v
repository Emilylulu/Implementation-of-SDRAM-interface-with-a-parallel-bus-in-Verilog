`timescale 10ps/1ps
module Control(clock,Status,Write,Burst,tLAT,CountOut,BIWEn,BIREn,Load_tPRE,Load_tCAS,Load_tBURST,Load_tWAIT,Ready,StoreReg,EnWData,EnRData,bar_CS,bar_RAS,bar_CAS,bar_WE,SelRow,SelCol,state,counter);
input Write,BIWEn,BIREn,Status,clock;
input [2:0]Burst;
input [1:0]tLAT;
input [2:0]CountOut;

output [2:0]state;
output [2:0]counter;

output Load_tPRE,Load_tCAS,Load_tBURST,Load_tWAIT,Ready,StoreReg,EnWData,EnRData,bar_CS,bar_RAS,bar_CAS,bar_WE,SelRow,SelCol;


wire Write,BIWEn,BIREn,Status;
wire [2:0]Burst;
wire [1:0]tLAT;
wire [2:0]CountOut;

reg [2:0]state;
reg [2:0]counter;

reg Load_tPRE,Load_tCAS,Load_tBURST,Load_tWAIT,Ready,StoreReg,EnWData,EnRData,bar_CS,bar_RAS,bar_CAS,bar_WE,SelRow,SelCol;


always @(posedge clock)
begin
	#5
	if(state == 3'b0 && (Status == 1'b0))
	begin
		
		bar_CS <= 1'b0;
		bar_RAS <= 1'b0;
		bar_CAS <= 1'b0;
		bar_WE <= 1'b0;
		Ready = 1'b0;
		
	end

	else if(BIWEn == 1'b1 && state == 3'b000)
	begin
		state = state + 1;
		StoreReg = 1'b1;
		bar_CS <= 1'b0;
		bar_RAS <= 1'b0;
		bar_CAS <= 1'b1;
		bar_WE <= 1'b0;// send prepare signal
		Load_tPRE = 1'b1;
		Ready = 1'b0;
	end//state 1
	
	else if(state == 3'b001 && CountOut > 3'b001)
	begin
		StoreReg = 1'b0;
		Ready = 1'b0;
		Load_tPRE = 1'b0;
	end//tPRE

	else if(state == 3'b001 && CountOut == 3'b001)
	begin
		state = state + 1;
		bar_CS <= 1'b0;
		bar_RAS <= 1'b0;
		bar_CAS <= 1'b1;
		bar_WE <= 1'b1;//load row address and active bank;
		Load_tCAS = 1'b1;
		SelRow = 1'b1;
		Ready = 1'b0;
	end//end state 2

	else if(state == 3'b010 && CountOut > 3'b010)
	begin
		Ready = 1'b0;
		Load_tCAS = 1'b0;
		SelRow = 1'b0;
	end//tCAS

	else if(state == 3'b010 && CountOut == 3'b010)
	begin
		state = state + 1;
		bar_CS <= 1'b0;
		bar_RAS <= 1'b1;
		bar_CAS <= 1'b0;
		bar_WE <= 1'b0;//load col address and write data
		Load_tBURST = 1'b1;
		SelCol = 1'b1;
		
		Ready = 1'b1;
	end//end state 3

	else if(state == 3'b011 && CountOut > 3'b000)
	begin
		EnWData = 1'b1;
		Ready = 1'b1;
		Load_tBURST = 1'b0;
		SelCol=1'b0;
	end//write

	else if(state == 3'b011 && CountOut == 3'b000)
	begin
		
		EnWData = 1'b1;
		Load_tWAIT = 1'b1;
		Ready = 1'b0;
		state = state + 1;
	end//end state 4

	else if(state == 3'b100 && CountOut > 3'b001)
	begin
		Ready = 1'b0;
		EnWData = 1'b0;
		Load_tWAIT = 1'b0;
	end//tWAIT

	else if(state == 3'b100 && CountOut == 3'b001)
	begin
		counter = 3'b0;
		state = 3'b0;
	end
	//end for write
	
	
	else if(BIREn == 1'b1 && counter == 3'b0)
	begin
		counter = counter + 1;
		StoreReg = 1'b1;
		bar_CS <= 1'b0;
		bar_RAS <= 1'b0;
		bar_CAS <= 1'b1;
		bar_WE <= 1'b0;// send prepare signal
		Load_tPRE = 1'b1;
		Ready = 1'b0;
	end//end counter 1

	else if(counter == 3'b001 && CountOut > 3'b001)
	begin
		Ready = 1'b0;
		Load_tPRE = 1'b0;
	end//tPRE

	else if(counter == 3'b001 && CountOut == 3'b001)
	begin
		counter = counter + 1;
		bar_CS <= 1'b0;
		bar_RAS <= 1'b0;
		bar_CAS <= 1'b1;
		bar_WE <= 1'b1;
		Load_tCAS = 1'b1;
		SelRow = 1'b1;
		Ready = 1'b0;
	end//load row address and activate bank,end counter 2

	else if(counter == 3'b010 && CountOut > 3'b010)
	begin
		Ready = 1'b0;
		Load_tCAS = 1'b0;
		SelRow=1'b0;
	end//tCAS

	else if(counter == 3'b010 && CountOut == 3'b010)
	begin
		counter = counter+1;
		bar_CS <= 1'b0;
		bar_RAS <= 1'b1;
		bar_CAS <= 1'b0;
		bar_WE <= 1'b1;
		SelCol = 1'b1;
		Ready = 1'b0;
	end//start read

	else if(counter == 3'b011 && tLAT == 2'b00)
	begin
		counter = 3'b110;
		Load_tBURST = 1'b1;
		Ready = 0'b0;
		SelCol = 1'b0;
	end//LAT WAIT is 2

	else if(counter == 3'b011 && tLAT == 2'b01)
	begin
		Ready = 1'b0;
		counter = counter + 1;
		SelCol = 1'b0;
	end
	else if(counter == 3'b100 && tLAT == 2'b01)
	begin
		counter = 3'b110;
		Load_tBURST = 1'b1;
		Ready = 0'b0;
	end//LAT WAIT is 3

	else if(counter == 3'b011 && tLAT == 2'b10)
	begin
		Ready = 1'b0;
		counter = counter + 1;
		SelCol = 1'b0;
	end
	else if(counter == 3'b100 && tLAT == 2'b10)
	begin
		Ready = 1'b0;
		counter = counter + 1;
	end
	else if(counter == 3'b101 && tLAT == 2'b10)
	begin
		counter = 3'b110;
		Load_tBURST = 1'b1;
		Ready = 0'b0;
	end//LAT WAIT is 4

	else if(counter == 3'b011 && tLAT == 2'b11)
	begin
		Ready = 1'b0;
		counter = counter + 1;	
		SelCol = 1'b0;
	end
	else if(counter == 3'b100 && tLAT == 2'b11)
	begin
		Ready = 1'b0;
		counter = counter + 1;	
	end
	else if(counter == 3'b101 && tLAT == 2'b11)
	begin
		Ready = 1'b0;
		counter = counter + 1;	
	end
	else if(counter == 3'b110 && tLAT == 2'b11)
	begin
		Load_tBURST = 1'b1;
		Ready = 0'b0;	
	end//LAT WAIT is 5

	else if(counter == 3'b110 && CountOut > 3'b000)
	begin 
		EnRData = 1'b1;
		Ready = 1'b1;
		Load_tBURST = 1'b0;
	end//read

	else if(counter == 3'b110 && CountOut == 3'b000)
	begin
		counter = counter+1;
		Load_tWAIT = 1'b1;
		EnRData = 1'b1;
		Ready = 1'b1;
		

	end

	else if(counter == 3'b111 && CountOut > 3'b001)
	begin
		Ready = 0;
		Load_tWAIT = 1'b0;
		EnRData = 1'b0;
	end

	else if(counter == 3'b111 && CountOut == 3'b001)
	begin
		state = 3'b0;
		counter = 3'b0;
	end

	else
	begin
		state = 3'b0;
		counter = 3'b0;
		
	end

end

endmodule