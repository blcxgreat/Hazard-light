
module  DE1_SoC  (CLOCK_50,  HEX0,  HEX1,  HEX2,  HEX3,  HEX4,  HEX5,  KEY,  LEDR, SW); 

   input  logic CLOCK_50; // 50MHz clock.
	output logic[6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 
	output logic[9:0]  LEDR;
	input  logic[3:0]  KEY; // True when not pressed, False whenpressed
	input  logic[9:0]  SW; 
	
	// Generate clk off of CLOCK_50, whichClock picks rate.
	//logic[31:0] clk;
	//parameter whichClock = 25;
	//clock_divider cdiv (CLOCK_50, clk);
	
	// Hook up FSM inputs and outputs.
	logic reset, clean3, clean0, temp3, temp0, tempC;
	logic out3;
	logic out0;
	logic [6:0] dis;
	assign reset = SW[9];// Reset when SW[9] is pressed.
	
	//set up and clean the input to avoid Metastability
	meta set3(.clk(CLOCK_50), .d1(KEY[3]), .q1(temp3), .q2(clean3));
	meta set0(.clk(CLOCK_50), .d1(KEY[0]), .q1(temp0), .q2(clean0));
	
	logic K3, K0;
	userInput in3(.clk(CLOCK_50), .reset, .button(clean3), .out(K3));
	
	userInput in0(.clk(CLOCK_50), .reset, .button(clean0), .out(K0));
	
	normalLight nm9(.clk(CLOCK_50), .reset, .L(K3), .R(K0), .NL(0), .NR(LEDR[8]), .lightOn(LEDR[9]));
	
	normalLight nm8(.clk(CLOCK_50), .reset, .L(K3), .R(K0), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]));
	
	normalLight nm7(.clk(CLOCK_50), .reset, .L(K3), .R(K0), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]));
	
	normalLight nm6(.clk(CLOCK_50), .reset, .L(K3), .R(K0), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]));
	
	centerLight cl(.clk(CLOCK_50), .reset, .L(K3), .R(K0), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]));
	
	normalLight nm4(.clk(CLOCK_50), .reset, .L(K3), .R(K0), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]));
	
	normalLight nm3(.clk(CLOCK_50), .reset, .L(K3), .R(K0), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]));
	
	normalLight nm2(.clk(CLOCK_50), .reset, .L(K3), .R(K0), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]));
	
	normalLight nm1(.clk(CLOCK_50), .reset, .L(K3), .R(K0), .NL(LEDR[2]), .NR(0), .lightOn(LEDR[1]));

   decideWin de(.clk(CLOCK_50), .reset, .L(K3), .R(K0), .leftleds(LEDR[9]), .rightleds(LEDR[1]), .display(dis));
	
	// Show signals on LEDRs so we can see what is happening.
   // assign LEDR = {out3[3], out3[2], out3[1], out3[0], tempC, out0[0], out0[1], out0[2], out0[3], 1'b0};
	assign HEX0 = dis;
	assign HEX5 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX1 = 7'b1111111;
endmodule

// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
   input logic          clock;
	output logic  [31:0]divided_clocks;
	 
	initial begin
	   divided_clocks <= 0;
	end
	
	always_ff@(posedge clock) begin
	   divided_clocks <= divided_clocks + 1;
	end
	
endmodule

module DE1_SoC_testbench();
	logic 		  CLOCK_50; // 50MHz clock.
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY; // True when not pressed, False when pressed
	logic [9:0] SW;
	
	DE1_SoC dut (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial CLOCK_50=0;
	initial KEY = 4'b0000;
	always begin
		#(CLOCK_PERIOD/2);
		CLOCK_50 = ~CLOCK_50;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
	SW[9] <= 1;											@(posedge CLOCK_50);
	                                          @(posedge CLOCK_50);
															@(posedge CLOCK_50);
	SW[9] <= 0; 										@(posedge CLOCK_50);
	                                          @(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);
	KEY[0] <= 1; KEY[3] <= 0; 						@(posedge CLOCK_50);
															@(posedge CLOCK_50);
	KEY[0] <= 0; 		   							@(posedge CLOCK_50);
	                                          @(posedge CLOCK_50);
															@(posedge CLOCK_50);
	KEY[0] <= 1; KEY[3]<=1;	  						@(posedge CLOCK_50);
	                                          @(posedge CLOCK_50);
	KEY[0] <= 0; KEY[3]<=0; 						@(posedge CLOCK_50);
	KEY[0] <= 1; 										@(posedge CLOCK_50);
	KEY[0] <= 0; 										@(posedge CLOCK_50);
	KEY[0] <= 1;					   				@(posedge CLOCK_50);
	KEY[0] <= 0;										@(posedge CLOCK_50);
	KEY[0] <= 1;										@(posedge CLOCK_50);
	KEY[0] <= 0;										@(posedge CLOCK_50);
	KEY[0] <= 1;					   				@(posedge CLOCK_50);
	KEY[0] <= 0;										@(posedge CLOCK_50);
	KEY[0] <= 1;										@(posedge CLOCK_50);
	KEY[0] <= 0;										@(posedge CLOCK_50);
	KEY[0] <= 1;										@(posedge CLOCK_50);
	KEY[0] <= 0;										@(posedge CLOCK_50);		
	KEY[0] <= 1;										@(posedge CLOCK_50);
	KEY[0] <= 0;										@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);
	SW[9] <= 1;											@(posedge CLOCK_50);
	SW[9] <= 0; 										@(posedge CLOCK_50);
															@(posedge CLOCK_50);
	KEY[3] <= 1; KEY[0] <= 0; 						@(posedge CLOCK_50);
	KEY[3] <= 0; 		   							@(posedge CLOCK_50);
	KEY[3] <= 1;		  								@(posedge CLOCK_50);
	KEY[3] <= 0; 										@(posedge CLOCK_50);
	KEY[3] <= 1; 										@(posedge CLOCK_50);
	KEY[3] <= 0; 										@(posedge CLOCK_50);
	KEY[3] <= 1;					   				@(posedge CLOCK_50);
	KEY[3] <= 0;										@(posedge CLOCK_50);
	KEY[3] <= 1;										@(posedge CLOCK_50);
	KEY[3] <= 0;										@(posedge CLOCK_50);
	KEY[3] <= 1;					   				@(posedge CLOCK_50);
	KEY[3] <= 0;										@(posedge CLOCK_50);
	KEY[3] <= 1;										@(posedge CLOCK_50);
	KEY[3] <= 0;										@(posedge CLOCK_50);
	KEY[3] <= 1;										@(posedge CLOCK_50);
	KEY[3] <= 0;										@(posedge CLOCK_50);		
	KEY[3] <= 1;										@(posedge CLOCK_50);
	KEY[3] <= 0;										@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);

		$stop; // End the simulation.
	end
endmodule	