//Stopwatch_Level4.v
module stopwatch (
    input wire clk,
    input wire reset,
    input wire start,
    input wire stop,
    input wire clear,
    input wire countdown,
    input wire timeset,
    input wire lap,
    output reg [3:0] minutes_bcd,
    output reg [3:0] seconds_bcd,
    output reg [3:0] tenths_bcd,
    output reg [6:0] seven_segment_display,
    output reg flash
);

    // Synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            minutes_bcd <= 4'b0000;
            seconds_bcd <= 4'b0000;
            tenths_bcd <= 4'b0000;
            flash <= 1'b0;
        end
    end

    // Counter
    reg [11:0] count_reg;
    always @(posedge clk) begin
        if (reset) begin
            count_reg <= 12'b0000_0000_0000;
        end else if (start && !stop && !flash) begin
            if (timeset) begin
                count_reg <= count_reg + (countdown ? -1 : 1);
            end else begin
                count_reg <= count_reg + (countdown ? -1 : 1) * (lap ? 1 : 10);
            end
        end
    end

    // Time display
    always @(posedge clk) begin
        if (reset) begin
            minutes_bcd <= 4'b0000;
            seconds_bcd <= 4'b0000;
            tenths_bcd <= 4'b0000;
        end 
        else if (start && !stop && !flash) begin
            minutes_bcd <= count_reg[11:8];
            seconds_bcd <= count_reg[7:4];
            tenths_bcd <= count_reg[3:0];
        end
    end

    // Flashing
    always @(posedge clk) begin
        if (reset) begin
            flash <= 1'b0;
        end 
        else if (minutes_bcd == 4'b0000 && seconds_bcd == 4'b0000 && tenths_bcd == 4'b0000) begin
            flash <= 1'b1;
        end 
        else begin
            flash <= 1'b0;
        end
    end

    // Seven segment display
    always @(posedge clk) begin
        if (reset) begin
            seven_segment_display <= 7'b000_0000;
        end 
        else if (flash) begin
            seven_segment_display <= 7'b111_1111;
        end 
        else begin
            reg [3:0] digit_1, digit_2, digit_3;
            digit_1 <= minutes_bcd;
            digit_2 <= seconds_bcd;
            digit_3 <= tenths_bcd;
            if (digit_1 == 4'b0000) digit_1 <= 4'b0001;
            if (digit_2 == 4'b0000) digit_2 <= 4'b0001;
            if (digit_3 == 4'b0000) digit_3 <= 4'b0001;
            seven_segment_display <= {digit_3, digit_2, digit_1};
        end
    end

endmodule
