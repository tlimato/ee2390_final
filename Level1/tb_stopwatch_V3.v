//tb_Stopwatch_V3.v

// Testbench for Stopwatch Counter
`timescale 10ms/1ms
module stopwatch_tb;

  // Inputs
  reg clk;
  reg reset;
  reg Start;
  reg Stop;
  reg Countdown;

  // Outputs
  wire [3:0] Tenths_Seconds;
  wire [3:0] Ones_Seconds;
  wire [3:0] Tens_Seconds;
  wire [3:0] Minutes;


  // DUT (Device Under Test) - Your Stopwatch Counter Module
  stopwatch dut (
    .clk(clk),
    .reset(reset),
	.Start(Start),
	.Stop(Stop),
	.Countdown(Countdown),
    .Tenths_Seconds(Tenths_Seconds),
    .Ones_Seconds(Ones_Seconds),
    .Tens_Seconds(Tens_Seconds),
    .Minutes(Minutes)
  );

  // Clock generation
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk; // Generate clock with 50ns period (20MHz)
  end

  // Stimulus (reset for 100ns, then run for 1 minute)
  initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0,stopwatch_tb);
    reset = 1'b1;
	Start = 1'b1;
	Countdown = 1'b0;
    #10; //
    reset = 1'b0;
	Start = 1'b0;
	#1000
	Stop = 1'b1;
	#100;
	Stop = 1'b0;
	#2000;
	Start = 1'b1;
    #10; //
    Start = 1'b0;
	#5000;
	Countdown = 1'b1;
	#80000;
	Countdown = 1'b0;
    #11004; // Wait for 1 minute (60 seconds * 1 billion ns/second)
    $finish;
  end



endmodule