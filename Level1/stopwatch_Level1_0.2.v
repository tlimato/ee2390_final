module Stopwatch (
  input clk,
  input reset,
  input Start,
  input Stop,
  input Clear,
  input CountDown,
  output reg [3:0] Minutes,  // Minutes (BCD)
  output reg [3:0] SecondsTens,  // Tens digit of Seconds (BCD)
  output reg [3:0] SecondsOnes,  // Ones digit of Seconds (BCD)
  output reg [3:0] TenthsOfSeconds  // Tenths of Seconds (BCD)
);

  reg isRunning;
  reg countUp;

  // Synchronous Reset
  always @(posedge clk) begin
    if (reset) begin
      isRunning <= 1'b0;
      countUp <= 1'b1;
      Minutes <= 4'd0;
      SecondsTens <= 4'd0;
      SecondsOnes <= 4'd0;
      TenthsOfSeconds <= 4'd0;
    end
  end
  // Start logic
  always @(posedge clk, posedge Start) begin
    if (Start & ~isRunning) begin  // Start only if currently stopped
      isRunning <= 1'b1;
    end
  end

  // Stop logic
  always @(posedge clk, posedge Stop) begin
    if (Stop) begin
      isRunning <= 1'b0;
    end
  end

  // Clear logic
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      Minutes <= 4'd0;
      SecondsTens <= 4'd0;
      SecondsOnes <= 4'd0;
      TenthsOfSeconds <= 4'd0;
    end
  end


// Internal countup Logic (completely separate block)
always @(posedge clk) begin
  if (~CountDown & isRunning) begin
    // Update TenthsOfSeconds
    if (TenthsOfSeconds < 9) begin
      TenthsOfSeconds <= TenthsOfSeconds + 1;
    end else begin
      TenthsOfSeconds <= 0;  // Reset to zero if reaches 9
    end

    // Update Seconds based on TenthsOfSeconds reaching 9
    if (TenthsOfSeconds == 9) begin
      SecondsOnes <= SecondsOnes + 1;  // Handle carry to seconds
      if (SecondsOnes == 9) begin
        // Handle carry to SecondsTens (loop for BCD)
        SecondsTens <= (SecondsTens == 5) ? 0 : SecondsTens + 1;
        // Check for Minutes increment after updating SecondsTens
        if (SecondsTens == 5) begin
          Minutes <= (Minutes == 9) ? 0 : Minutes + 1;  // Loop Minutes on 9
        end
        SecondsOnes <= 0;  // Reset SecondsOnes after carry
      end
    end
  end
end

// Internal countdown Logic (completely separate block)
always @(posedge clk) begin
  if (CountDown & isRunning) begin
    // Update TenthsOfSeconds
    if (TenthsOfSeconds > 0) begin
      TenthsOfSeconds <= TenthsOfSeconds - 1;
    end else begin
      // Reset to 9 on reaching zero and check for looping on Minutes
      TenthsOfSeconds <= 9;
      if (SecondsOnes == 0 && SecondsTens == 0 && Minutes == 0) begin
        Minutes <= 9;  // Reset Minutes to 9 for loop back
      end
    end

    // Update Seconds based on TenthsOfSeconds reaching 0
    if (TenthsOfSeconds == 0) begin
      SecondsOnes <= SecondsOnes - 1;  // Borrow from seconds
      if (SecondsOnes == 0) begin
        // Handle borrow to SecondsTens (loop for BCD)
        SecondsTens <= (SecondsTens == 0) ? 5 : SecondsTens - 1;
        // Check for Minutes decrement after updating SecondsTens
        if (SecondsTens == 0) begin
          Minutes <= (Minutes == 0) ? 9 : Minutes - 1;  // Decrement or loop Minutes
        end
        SecondsOnes <= 9;  // Reset SecondsOnes after borrow
      end
    end
  end
end


  // Output Logic (change based on your specific display driver)
  always @(Minutes, SecondsTens, SecondsOnes, TenthsOfSeconds) begin
    // Implement logic to drive your specific seven-segment displays for Minutes (BCD), Seconds (separate displays for Tens and Ones) and Tenths of Seconds (single BCD digit)
  end

endmodule
