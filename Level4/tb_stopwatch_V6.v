//tb_Stopwatch_V6.v

// Testbench for Stopwatch Counter
`timescale 10ms/1ns  // Adjust timescale for finer control (optional)

module stopwatch_tb;

  // Inputs
  reg clk;
  reg reset;
  reg Start;
  reg Stop;
  reg Clear;  // Include Clear signal for testing
  reg Countdown;
  reg Lap;
  reg TimeSet;  // Include TimeSet signal for testing

  // Outputs
  wire [3:0] disp_Tenths_Seconds;
  wire [3:0] disp_Ones_Seconds;
  wire [3:0] disp_Tens_Seconds;
  wire [3:0] disp_Minutes;

  stopwatch dut (
    .clk(clk),
    .reset(reset),
    .Start(Start),
    .Stop(Stop),
    .Clear(Clear),  // Connect Clear signal to dut
    .Countdown(Countdown),
    .Lap(Lap),
    .TimeSet(TimeSet),  // Connect TimeSet signal to dut
    .disp_Tenths_Seconds(disp_Tenths_Seconds),
    .disp_Ones_Seconds(disp_Ones_Seconds),
    .disp_Tens_Seconds(disp_Tens_Seconds),
    .disp_Minutes(disp_Minutes)
  );

  // Clock generation
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk; // Generate clock with 5ns period (200MHz)
  end

  // Stimulus
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, stopwatch_tb);

    // Initial reset
    reset = 1'b1;
    #10;
    reset = 1'b0;

    // Test 1: Normal count-up
    Start = 1'b1;
    Countdown = 1'b0;
    #10; // Wait for start to register
    Start = 1'b0;
    #1000; // Run for 1 second
    Stop = 1'b1;
    #100; // Wait for stop to register
    Stop = 1'b0;
    // Check outputs (should be 00:01:00.0)
    #10;


    // Test 2: Countdown
    Start = 1'b1;
    Countdown = 1'b1;
    #10; // Wait for start to register
    Start = 1'b0;
    #5000; // Run for 5 seconds (should reach 00:00:00.0)
    Stop = 1'b1;
    #100; // Wait for stop to register
    Stop = 1'b0;
    // Check outputs (should be 00:00:00.0)
    #10;

    // Test 3: Lap functionality
    Start = 1'b1;
    Countdown = 1'b0;
    #10; // Wait for start to register
    Start = 1'b0;
    #2000; // Run for 2 seconds
    Lap = 1'b1;
    #100; // Wait for Lap to register
    Lap = 1'b0;
    #1000; // Run for 1 more second
    Stop = 1'b1;
    #100; // Wait for stop to register
    Stop = 1'b0;
    // Check outputs (should be 00:03:00.0 after stop, 00:02:00.0 on Lap display hold)
    #10;
	reset = 1'b1;
	#5;
	reset = 1'b0;
	// Test 4: TimeSet functionality
	TimeSet = 1'b1;
	Start = 1'b1;
	#5;
	Start = 1'b0;
	#1000;
	Stop = 1'b1;
	#5;
	Stop =1'b1;
	TimeSet = 1'b0;
	Start =1'b1;
	#5
	Start = 1'b0;
	#5000;
	reset = 1'b1;
	#5
	reset = 1'b0;
	#10
	$finish;
	end
    
endmodule