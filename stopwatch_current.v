`timescale 0.1s/1ms
// Input mappings as stated in contraints file
// Reset = R2, Clear = T1, Start = U1, Stop = W2, Countdown = V17
module stopwatch (
    input clk,
    input reset,
    input start,
    input stop,
    input clear,
    input countdown,
    output reg [3:0] minutes_bcd,
    output reg [3:0] seconds_bcd,
    output reg [3:0] seconds2_bcd,
    output reg [3:0] tenths_bcd
);
// internal values
    reg [15:0] count_bcd
    reg [3:0] tenths_bcd_next =  4'b0000
    reg [3:0] seconds_bcd_next =  4'b0000
    reg [3:0] seconds2_bcd_next =  4'b0000
    reg [3:0] minutes_bcd_next =  4'b0000
    
// Synchronous reset
always @(posedge clk) begin
    if (reset) begin
        minutes_bcd <= 4'b0000;
        seconds_bcd <= 4'b0000;
        seconds2_bcd <= 4'b0000; // added synchronous reset for seconds2_bcd
        tenths_bcd <= 4'b0000;
    end
end

// Counter
reg [11:0] count_bcd;
always @(posedge clk) begin
    if (reset) begin
        count_bcd <= 16'b000000000000; //updated from a 12 bit number to a 16 digit number to account for seconds 2
    end else if (start && !stop) begin
        count_bcd <= count_bcd + 1'b1;
    end
end

// Countdown
// Currently this would overlap with the existing count up code would it not?
// |-> Actually nevermind I missed the countdown input
always @(posedge clk) begin
    if (clear && !stop) begin
        count_bcd <= 12'b000000000000;
    end else if (countdown && !stop) begin
        count_bcd <= count_bcd - 1'b1;
    end
end

    
// Time display
reg [3:0] tenths_bcd_next, seconds_bcd_next, minutes_bcd_next;
always @(posedge clk) begin
    if (reset) begin
        tenths_bcd_next <= 4'b0000;
        seconds_bcd_next <= 4'b0000;
        seconds2_bcd <= 4'b0000;
        minutes_bcd_next <= 4'b0000;
    end 
    else if (start && !stop) begin
        tenths_bcd_next <= count_bcd[3:0];
        seconds_bcd_next <= count_bcd[7:4];
        seconds2_bcd_next <= count_bcd[11:8];
        minutes_bcd_next <= count_bcd[15:12];
    end
end
// Parallel execution of next state management
always @(posedge clk) begin
    if (tenths_bcd_next != tenths_bcd) begin
        tenths_bcd <= tenths_bcd_next;
    end
    if (seconds_bcd_next != seconds_bcd) begin
        seconds_bcd <= seconds_bcd_next;
    end
    if (seconds2_bcd_next != seconds2_bcd) begin
        seconds2_bcd <= seconds2_bcd_next;
    end
    if (minutes_bcd_next != minutes_bcd) begin
        minutes_bcd <= minutes_bcd_next;
    end
end

endmodule
