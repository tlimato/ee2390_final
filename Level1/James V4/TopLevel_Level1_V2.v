module top_level;

  input clk, reset, Start, Stop, Clear, Countdown;
  output reg [0:6] Seg_Minutes, Seg_Tens_Seconds, Seg_Ones_Seconds, Seg_Tenths_Seconds;

  wire [3:0] Minutes, Tens_Seconds, Ones_Seconds, Tenths_Seconds;

  stopwatch stopwatch_inst (
    .clk(clk),
    .reset(reset),
    .Start(Start),
    .Stop(Stop),
    .Clear(Clear),
    .Countdown(Countdown),
    .Minutes(Minutes),
    .Tens_Seconds(Tens_Seconds),
    .Ones_Seconds(Ones_Seconds),
    .Tenths_Seconds(Tenths_Seconds)
  );

  stopwatch_display stopwatch_display_inst (
    .clk(clk),
    .reset(reset),
    .Minutes(Minutes),
    .Tens_Seconds(Tens_Seconds),
    .Ones_Seconds(Ones_Seconds),
    .Tenths_Seconds(Tenths_Seconds),
    .Seg_Minutes(Seg_Minutes),
    .Seg_Tens_Seconds(Seg_Tens_Seconds),
    .Seg_Ones_Seconds(Seg_Ones_Seconds),
    .Seg_Tenths_Seconds(Seg_Tenths_Seconds)
  );

	sevensegBCDdecoder sevensegBCDdecoder_inst(
		.clk(clk),
		.IN(IN),
		.reset(reset),
		.Seg(Seg)
	)

endmodule