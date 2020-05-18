module ss_driver_tb();
    reg Clk;
    reg Reset;
    reg [3:0] BCD3;
    reg [3:0] BCD2;
    reg [3:0] BCD1;
    reg [3:0] BCD0;
    
    wire [3:0] SegmentDrivers;
    wire [7:0] SevenSegment;
    
    // Instantitate the device under test
    SS_Driver DUT(
		Clk, Reset,
		BCD3, BCD2, BCD1, BCD0,
		SegmentDrivers, SevenSegment
	);
	
	// Initialise
	initial begin
	   Clk = 0;
	   Reset = 1;
	   BCD3 = 4'd0;
       BCD2 = 4'd1;
       BCD1 = 4'd2;
       BCD0 = 4'd3;
	end
	
	always begin
	   #5 Clk <= ~Clk;
	end 
	
	always begin
	   #5 Reset <= 0;
	end

	always @(posedge Clk)begin
	   #5 BCD3 <= BCD3 + 4'd1;
	   #5 BCD2 <= BCD2 + 4'd1;
	   #5 BCD1 <= BCD1 + 4'd1;
	   #5 BCD0 <= BCD0 + 4'd1;
	end 

endmodule