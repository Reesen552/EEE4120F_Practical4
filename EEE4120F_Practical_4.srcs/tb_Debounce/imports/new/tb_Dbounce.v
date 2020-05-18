`timescale 1ns / 1ps
// testbench verilog code for debouncing button without creating another clock
module tb_Debounce;
 // Inputs
 reg pb_1;
 reg clk;
 // Outputs
 wire pb_out;
 // Instantiate the debouncing Verilog code
 Debounce uut (
  .Button(pb_1), 
  .clk(clk), 
  .Flag(pb_out)
 );
 initial begin
  clk = 0;
  forever #10 clk = ~clk;
 end
 integer i;
 initial begin
 for (i = 0; i < 1000000; i = i + 1) begin
  pb_1 = 0;
  #10;
  pb_1=1;
  #20;
  pb_1 = 0;
  #10;
  pb_1=1;
  #30; 
  pb_1 = 0;
  #10;
  pb_1=1;
  #40;
  pb_1 = 0;
  #10;
  pb_1=1;
  #30; 
  pb_1 = 0;
  #10;
  pb_1=1; 
  #11
  pb_1=0; 
  #4000; 
  
  #40;
  
 end 
      end
endmodule