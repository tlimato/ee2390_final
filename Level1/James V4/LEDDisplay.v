
module stopwatch_display (
  input clk, reset,
  input [3:0] Minutes, Tens_Seconds, Ones_Seconds, Tenths_Seconds
  output reg [0:6] Seg_Minutes, Seg_Tens_Seconds, Seg_Ones_Seconds, Seg_Tenths_Seconds
);

  always @(posedge clk or posedge reset) begin
    begin
      sevensegBCDdecoder minutes_decoder(Minutes, clk, Seg_Minutes);
      sevensegBCDdecoder tens_seconds_decoder(Tens_Seconds, clk, Seg_Tens_Seconds);
      sevensegBCDdecoder ones_seconds_decoder(Ones_Seconds, clk, Seg_Ones_Seconds);
      sevensegBCDdecoder tenths_seconds_decoder(Tenths_Seconds, clk, Seg_Tenths_Seconds);
    end
  end

endmodule

endmodule