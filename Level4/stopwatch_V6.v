//stopwatch_V6.v
// All goals of Level one and two have been achieved, this version adds the funcitonality of the Lap input

module stopwatch (
  input clk, reset, Start, Stop, Clear, Countdown, Lap, TimeSet,
  output reg [3:0] disp_Minutes, disp_Tens_Seconds, disp_Ones_Seconds, disp_Tenths_Seconds
  );
  reg [3:0] Minutes, Tens_Seconds, Ones_Seconds, Tenths_Seconds;
  reg running,Down,flashing;
  reg Anode = 1;
  reg setting_mode,setting_mode_running;

	// Control Always block for handling non level sensitive inputs, !Buttons!
	always@(posedge Start,posedge Stop,negedge Start)
	begin
		if(setting_mode && Start)setting_mode_running <=1;
		if(setting_mode && ~Start)setting_mode_running <=0;
		if(Start)begin 
		running <=1; 	
		flashing <= 0;
		if(~Countdown) Tenths_Seconds <= Tenths_Seconds +4'd1;
		else begin
		Tenths_Seconds <= 4'd9;
		Ones_Seconds <= 4'd9;
		Tens_Seconds <= 4'd5;
		Minutes <= 4'd9;
		end
		end
		if(Stop)begin 
		running <=0;
		flashing <= 0;
		Anode <= 1;
		end
	end
	
	//Level sensitive Countdown toggle to activate the Down State and setting_mode State. 
	always@(Countdown,TimeSet)
	begin
		if(~Countdown) Down <=0;
		else Down <=1;
		if(TimeSet == 1 && running == 0) setting_mode <=1;
		else setting_mode <=0;
	end
	
	//reset fucntion on any clk 
	always@(posedge clk) begin
			if (reset) begin
				running					<= 0;
				setting_mode_running 	<= 0;
				Minutes 				<= 4'd0;
				Tens_Seconds			<= 4'd0;
				Ones_Seconds			<= 4'd0;
				Tenths_Seconds			<= 4'd0;
			end 
		end
	
	//Standard CountUp and CountDown
	always@(posedge clk)begin
		if (running && ~Down)begin
			if (Tenths_Seconds == 4'd9) begin // Check if tenths_seconds reaches 9
				Tenths_Seconds <= 0;		  // Reset to 0 on reaching 9
				Ones_Seconds <= Ones_Seconds + 1;
			end else begin
				Tenths_Seconds <= Tenths_Seconds + 1; // Increment tenths_seconds 
			end
			if (Ones_Seconds == 4'd9 && Tenths_Seconds == 4'd9) begin
					Ones_Seconds <= 0;
					Tens_Seconds <= Tens_Seconds +1;
				end
			if (Tens_Seconds == 4'd5 && Ones_Seconds == 4'd9 && Tenths_Seconds == 4'd9 ) begin
				Tens_Seconds <= 0;
				Minutes <= Minutes +1;
				end
			if (Minutes == 4'd9 && Tens_Seconds == 4'd5 && Ones_Seconds == 4'd9 && Tenths_Seconds == 4'd9) begin
				Minutes <= 4'd0; Tens_Seconds <= 4'd0; Ones_Seconds <= 4'd0; Tenths_Seconds <= 4'd0;
				running <=0;
				flashing <=1;
				end
		end
		if (running && Down)begin
			if (Tenths_Seconds == 4'd0) begin
				Tenths_Seconds <= 4'd9;
				Ones_Seconds <= Ones_Seconds - 1;
				end else begin
					Tenths_Seconds <= Tenths_Seconds -1;
					end
			if(Ones_Seconds == 4'd0 && Tenths_Seconds == 4'b0) begin
				Ones_Seconds <= 4'd9;
				Tens_Seconds <= Tens_Seconds - 1;
				end
			if (Tens_Seconds == 4'd0 && Ones_Seconds == 4'd0 && Tenths_Seconds == 4'd0 ) begin
				Tens_Seconds <= 4'd5;
				Minutes <= Minutes -1;
				end
			if (Minutes == 4'd0 && Tens_Seconds == 4'd0 && Ones_Seconds == 4'd0 && Tenths_Seconds == 4'd0) begin
				Minutes <= 4'd0; Tens_Seconds <= 4'd0; Ones_Seconds <= 4'd0; Tenths_Seconds <= 4'd0;
				running <=0;
				flashing <=1;
				end
			end
	end
	
	// Sped Up Countdown and CountUp that ignores the tenths and counts up by seconds 10 times faster than real time.
	always@(posedge clk)begin
		if (setting_mode_running && ~Down)begin
			if (Ones_Seconds == 4'd9) begin
					Ones_Seconds <= 0;
					Tens_Seconds <= Tens_Seconds +1;
				end else Ones_Seconds <= Ones_Seconds +1;
			if (Tens_Seconds == 4'd5 && Ones_Seconds == 4'd9) begin
				Tens_Seconds <= 0;
				Minutes <= Minutes +1;
				end
			if (Minutes == 4'd9 && Tens_Seconds == 4'd5 && Ones_Seconds == 4'd9) begin
				Minutes <= 0;
				end
		end
		if (setting_mode_running && Down)begin
			if(Ones_Seconds == 4'd0) begin
				Ones_Seconds <= 4'd9;
				Tens_Seconds <= Tens_Seconds - 1;
				end else Ones_Seconds <= Ones_Seconds -1; 
			if (Tens_Seconds == 4'd0 && Ones_Seconds == 4'd0) begin
				Tens_Seconds <= 4'd5;
				Minutes <= Minutes -1;
				end
			if (Minutes == 4'd0 && Tens_Seconds == 4'd0 && Ones_Seconds == 4'd0) begin
				Minutes <= 4'd9;
				end
			end
	end
	
	reg [2:0]count = 4'd0;
	//Basic counter for intermittent flashing
	always@(posedge clk)
		if (flashing) begin
		count <= count +1;
		end
	
	//Flasher to toggle anode every 0.5 seconds
	always@(posedge clk)
		if (flashing) begin
			wait (count == 4'd4);
			Anode <= 0;
			wait (count == 4'd5);
			count <= 4'b0;
			wait (count == 4'd4);
			Anode <= 1;
			wait (count == 4'd5);
			count <= 4'b0;
		end
		
	//Output Always block that locks output as current when Lap is pressed until Start is instantiated again.
	always@(posedge clk,posedge Lap) begin
		if(~Countdown)begin
			if(Lap)begin
					disp_Minutes <= Minutes;
					disp_Tens_Seconds <= Tens_Seconds;
					disp_Ones_Seconds <= Ones_Seconds;
					disp_Tenths_Seconds <= Tenths_Seconds;
					wait (Start == 1);
				end
			end
		disp_Minutes <= Minutes;
		disp_Tens_Seconds <= Tens_Seconds;
		disp_Ones_Seconds <= Ones_Seconds;
		disp_Tenths_Seconds <= Tenths_Seconds;
		
	end
	

endmodule