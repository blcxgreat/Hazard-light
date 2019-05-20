
module centerLight (clk, reset, L, R, NL, NR, lightOn);
   
	input logic clk, reset;
	input logic L, R, NL, NR;
	output logic lightOn;
	
	// State variables.
	enum { ON, OFF } ps, ns;
	
	// Next State logic
	always_comb begin
	   case (ps)
		   ON: if ((L&R) | (~L&~R))                    ns = ON;
				else                                 ns = OFF; 
		  OFF: if ((~L&R&NL) | (L&~R&NR))      ns = ON;
				else                                 ns = OFF;
		endcase
   end
	
   // DFFs
	always_ff@(posedge clk)begin
	   if (reset)
		   ps <= ON;
		else
		   ps <= ns;
   end	
	
	
	assign lightOn = (ps==ON);
	
endmodule 

module centerLight_testbench();
   logic clk, reset, w1, w0, nw1, nw0;
	logic out;
	
	centerLight h (clk, reset, w1, w0, nw1, nw0, out);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
	   clk<= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design.  Each line is a clock cycle.
	initial begin

		reset <= 0; w1 <= 1; w0 <=1; nw1 = 0; nw0 = 0; @(posedge clk);
		                    @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		reset = 1;  w1 <= 0; w0 <=1; nw1 = 0; nw0 = 0; @(posedge clk);
						        @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		reset <= 0; w1 <= 0; w0 <=0; @(posedge clk);
		                    @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
						w1 <= 1; w0 <=0; nw1 = 0; nw0 = 1;@(posedge clk);
						        @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
					   w1 <= 0; w0 <=1; nw1 = 1; nw0 = 0;@(posedge clk);
						        @(posedge clk);
						        @(posedge clk);
      $stop; // End the simulation.
   end
endmodule