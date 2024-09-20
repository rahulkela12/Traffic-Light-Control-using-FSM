`timescale 1ms/1ms
`include "TLC.v"
module testbench();
reg clk;
reg rst;
reg farmSensor;
wire [5:0]count;
wire [1:0] h_s;
wire [1:0] f_s;
wire [2:0] state;
wire rst_count;

TLC utt(.clk(clk),.rst(rst),.count(count),.h_s(h_s),.f_s(f_s),.state(state),.rst_count(rst_count),.farmSensor(farmSensor));
counter ut(.clk(clk),.rst_count(rst_count),.count(count));
initial 
begin
	$dumpfile("TLC_waveform.vcd");
	$dumpvars(0, testbench);
    clk=1'b0;
    rst=1'b1;
    farmSensor=1'b0;
    #10000;
    rst=1'b0;
    #40000;
    farmSensor=1'b1;
    #10000;
    farmSensor=1'b0;
    #400000;
    $finish;
end
always #250 clk=~clk;
endmodule