
module userInput(clk, reset, button, out);
   
	input logic clk, reset, button;
	output logic out;
	
	// State variables.
	enum { A, B, C } ps, ns;
	
	always_comb begin
	   case (ps)
		   A: if (button)               ns = B;
				else                      ns = A; 
		   B: if (button)               ns = B;
				else                      ns = C;
			C: if (button)               ns = B;
				else                      ns = A;
		endcase
   end
	
   // DFFs
	always_ff@(posedge clk)begin
	   if (reset)
		   ps <= A;
		else
		   ps <= ns;
   end	
	
	
	logic result;
	always_comb begin
	   case (ps)
		   A: begin 
			   result = 0;
			end 
			B: begin 
			   result = 0;
			end
			C: begin 
			   result = 1;
			end
	   endcase
   end
	
	assign out = result;
	
endmodule 

module User_testbench();
   logic clk, reset, w1;
	logic out;
	
	userInput h (clk, reset, w1, out);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
	   clk<= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design.  Each line is a clock cycle.
	initial begin
	     reset <= 1;           @(posedge clk);
                              @(posedge clk);
		reset <= 0; w1 <= 1;    @(posedge clk);
		                        @(posedge clk);
								      @(posedge clk);
								      @(posedge clk);
					   w1 <= 1;    @(posedge clk);
						            @(posedge clk);
						w1 <= 0;    @(posedge clk);
						            @(posedge clk);
						w1 <= 1;    @(posedge clk);
								      @(posedge clk);
					   w1 <= 1;    @(posedge clk);
						            @(posedge clk);
						w1 <= 1;    @(posedge clk);
						            @(posedge clk);
					   w1 <= 1;    @(posedge clk); 
      $stop; // End the simulation.
   end
endmodule
