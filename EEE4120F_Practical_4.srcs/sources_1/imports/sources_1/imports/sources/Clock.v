`timescale 1ns / 1ps
module Clock(
        // Inputs
        // Clocks
        input   CLK100MHZ,
        
        // Buttons
        input   BTNU,       //Up -- increment hours
        input   BTNR,       //Right -- increment minutes
        input   BTNC,       //Center -- reset button
        input   [7:0] SW,    //Switches
        
        // Outputs
        // Seconds display output
        output [5:0]  LED,
        
        // 7-Segment Display
        output [3:0]    SegmentDrivers,        //Anode signals of the 7-segment LED display
        output [7:0]    SevenSegment           //Cathode patterns of the 7-segment LED display
    );
    
    //Add the reset
    wire Reset;
    Delay_Reset Delay_Reset1(CLK100MHZ, BTNC, Reset); 

	//Add and debounce the buttons
	wire MButton;
	wire HButton;
	
	// Instantiate Debounce modules here
	Debounce DebounceM(CLK100MHZ, BTNR, MButton);
	Debounce DebounceH(CLK100MHZ, BTNU, HButton);
	
	//Set up PWM
    wire pwm_out;
    PWM pwm (CLK100MHZ,SW,pwm_out);
	
	
	// registers for storing the time
    reg [3:0]hours1    =4'd0;
	reg [3:0]hours2    =4'd0;
	reg [3:0]mins1     =4'd0;
	reg [3:0]mins2     =4'd0;
	reg [5:0]secs      =6'd0;
    
	// Initialize seven segment
	// You will need to change some signals depending on you constraints
	SS_Driver SS_Driver1(
		CLK100MHZ, Reset,pwm_out,
		hours2, hours1, mins2, mins1, // Use temporary test values before adding hours2, hours1, mins2, mins1
		SegmentDrivers, SevenSegment
	);
	
	// Display the seconds on the LEDs
	assign LED [5:0] = secs [5:0];

	
	//keeps track of 'real' time
	reg [5:0] rsec     =0;
	reg [5:0] rmin     =56;
	reg [4:0] rhour    =22;
	
	reg [32:0] count   =0;     //use to count howmany clocks equal a second 
	
	//Responsible for incrementing time using 'real' time variables
	always @(posedge CLK100MHZ) begin
        $display("Hours = %d:%d  Minutes = %d:%d  secs = %d  Counter =%d\n", hours2, hours1, mins2, mins1, secs,count);
        
        count <= count +1;
        if(count == 1   && !HButton && !MButton) begin       // when count == 100MHZ (32'hF4240) increment the seconds
            count <= 0;
            if( rsec < 59) begin
                rsec <= rsec +1;
            end
            else begin                                  // overflow seconds
                rmin <= rmin+1;
                rsec <=0;
                if( rmin == 59) begin                   //Overflow min  
                    rhour <=rhour+1;
                    rmin <=0;
                    if( rhour == 23) begin              // reset hour back to 00
                        rhour   <= 0;
                    end
                end
            end
        end
        else if(HButton == 1'b1) begin // If increment push button (BTNU) is pressed 
		$display("Hours button pressed\n"); 
            rhour <=rhour+1;
            if( rhour == 23) begin              // reset to 00:00:00
                rhour   <= 0;
            end
        end
        else if(MButton == 1'b1) begin // If increment push button (BTNR) is pressed 
		$display("min button pressed\n"); 
            rmin <= rmin+1;
            if( rmin == 59) begin                   //Overflow min  
                rmin <=0;
            end
        end
	end

	
	// Block to split 'real' time into digits
	always @(*) begin 
	    
       hours2  <= (rhour-rhour%10)/10;
       hours1  <= rhour%10;
       mins2   <= (rmin -rmin%10)/10;
       mins1   <= rmin%10;
       secs    <= (rsec%3600)%60; 
	end

		

endmodule