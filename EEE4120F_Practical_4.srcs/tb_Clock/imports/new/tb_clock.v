module tb_clock;
    reg   CLK100MHZ;
    reg   BTNU;       //Up -- increment hours
    reg   BTNR;       //Right -- increment minutes
    reg   BTNC;        //Center -- reset button
    reg   [7:0]SW;
    
    wire [5:0]    LED;
    wire [3:0]    SegmentDrivers;
    wire [7:0]    SevenSegment; 

    
    // Instantiate the Device Under Test
    Clock myClock(
        .CLK100MHZ(CLK100MHZ), 
        .BTNU(BTNU), 
        .BTNR(BTNR), 
        .BTNC(BTNC), 
        .SW(SW),
        .LED(LED), 
        .SegmentDrivers(SegmentDrivers), 
        .SevenSegment(SevenSegment)
    );
    
    // Method for testing the clock
    initial begin
        CLK100MHZ = 0;
        BTNU = 0;
        BTNR = 0;
        BTNC = 1;
        SW = 8'hFF;
     end  
     
    always begin
	   #5 BTNC <= 0;
	end
     
     always begin
        #5 CLK100MHZ <= ~CLK100MHZ;
     end
endmodule