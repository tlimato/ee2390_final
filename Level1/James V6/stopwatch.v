module stopwatch(
    input clock,
    input reset,
    input start,
    output a, b, c, d, e, f, g, dp,
    output [3:0] an
    );

reg [3:0] reg_d0, reg_d1, reg_d2, reg_d3; //registers that will hold the individual counts
reg [22:0] ticker; //23 bits needed to count up to 5M bits
wire click;


//the mod 5M clock to generate a tick ever 0.1 second

always @ (posedge clock or posedge reset)
begin
 if(reset)

  ticker <= 0;

 else if(ticker == 5000000) //if it reaches the desired max value reset it
  ticker <= 0;
 else if(start) //only start if the input is set high
  ticker <= ticker + 1;
end

assign click = ((ticker == 5000000)?1'b1:1'b0); //click to be assigned high every 0.1 second

always @ (posedge clock or posedge reset)
begin
 if (reset)
  begin
   reg_d0 <= 0;
   reg_d1 <= 0;
   reg_d2 <= 0;
   reg_d3 <= 0;
  end
  
 else if (click) //increment at every click
  begin
   if(reg_d0 == 9) //xxx9 - the 0.1 second digit
   begin  //if_1
    reg_d0 <= 0;
    
    if (reg_d1 == 9) //xx99 
    begin  // if_2
     reg_d1 <= 0;
     if (reg_d2 == 5) //x599 - the two digit seconds digits
     begin //if_3
      reg_d2 <= 0;
      if(reg_d3 == 9) //9599 - The minute digit
       reg_d3 <= 0;
      else
       reg_d3 <= reg_d3 + 1;
     end
     else //else_3
      reg_d2 <= reg_d2 + 1;
    end
    
    else //else_2
     reg_d1 <= reg_d1 + 1;
   end 
   
   else //else_1
    reg_d0 <= reg_d0 + 1;
  end
end

//The Circuit for Multiplexing - Look at my other post for details on this

localparam N = 18;

reg [N-1:0]count;

always @ (posedge clock or posedge reset)
 begin
  if (reset)
   count <= 0;
  else
   count <= count + 1;
 end

reg [6:0]sseg;
reg [3:0]an_temp;
reg reg_dp;
always @ (*)
 begin
  case(count[N-1:N-2])
   
   2'b00 : 
    begin
     sseg = reg_d0;
     an_temp = 4'b1110;
     reg_dp = 1'b1;
    end
   
   2'b01:
    begin
     sseg = reg_d1;
     an_temp = 4'b1101;
     reg_dp = 1'b0;
    end
   
   2'b10:
    begin
     sseg = reg_d2;
     an_temp = 4'b1011;
     reg_dp = 1'b1;
    end
    
   2'b11:
    begin
     sseg = reg_d3;
     an_temp = 4'b0111;
     reg_dp = 1'b0;
    end
  endcase
 end
assign an = an_temp;

reg [6:0] sseg_temp; 
// IMPLIMENT FLASH ENABLE
reg flash_enable 1'b0;
always @ (*)
 begin
  case(sseg)
   4'd0 : begin 
       sseg_temp = 7'b1000000;
       flash_enable = 1'b0; // Enable flashing //dash
   4'd1 : begin 
       sseg_temp = 7'b1111001;
       flash_enable = 1'b0; // Enable flashing //dash
   4'd2 : begin
       sseg_temp = 7'b0100100;
       flash_enable = 1'b0; // Enable flashing //dash
   4'd3 : begin
       sseg_temp = 7'b0110000;
       flash_enable = 1'b0; // Enable flashing //dash
   4'd4 : begin
       sseg_temp = 7'b0011001;
       flash_enable = 1'b0; // Enable flashing //dash
   4'd5 : begin 
       sseg_temp = 7'b0010010;
       flash_enable = 1'b0; // Enable flashing //dash
   4'd6 : begin 
       sseg_temp = 7'b0000010;
       flash_enable = 1'b0; // Enable flashing //dash
   4'd7 : begin
       sseg_temp = 7'b1111000;
       flash_enable = 1'b0; // Enable flashing //dash
   4'd8 : begin 
       sseg_temp = 7'b0000000;
       flash_enable = 1'b0; // Enable flashing //dash
   4'd9 : begin 
       sseg_temp = 7'b0010000;
       flash_enable = 1'b0; // Enable flashing //dash
      default: begin
          sseg_temp = 7'b0111111;
          flash_enable = 1'b1; // Enable flashing //dash
      end
  endcase
 end
// Tyson Flash Seven Segment.w
always @(flash_enable) begin
    if (flash_enable) // If flashing is enabled
        sseg_temp_seg = 7'b1000000; // Display 0
    else
        sseg_temp_seg = 7'b1111111; // Turn off all segments
end 
       
assign {g, f, e, d, c, b, a} = sseg_temp; 
assign dp = reg_dp;

endmodule
