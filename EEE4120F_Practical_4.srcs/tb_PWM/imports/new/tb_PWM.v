`timescale 1ns / 1ps
// testbench verilog code for debouncing button without creating another clock
module tb_PWM;
 // Inputs
 reg [7:0]pb_1;
 reg clk;
 // Outputs
 wire pb_out;
 // Instantiate the debouncing Verilog code
 PWM pwm (
  .pwm_in(pb_1), 
  .clk(clk), 
  .pwm_out(pb_out)
 );
 initial begin
  clk = 0;
  forever #1 clk = ~clk;
 end
 integer i;
 initial begin
    for (i = 0; i < 8'b11111111; i = i + 1) begin
        pb_1 <= i;
        #10000;
    end 
 end
endmodule