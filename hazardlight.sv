module hazardlight (clk, reset, SW1, SW0, out);
   input  logic clk, reset, SW1, SW0;
	output logic [2:0] out;
	
	// State variables.
	enum { A, B, C, D } ps, ns;
	
	// A:101 B:010 C:001 D:100
	
	// Next State logic
	always_comb begin
	   case (ps)
		   A: if (SW1 == 0 & SW0 == 0)      ns = B;
			   else if (SW1 == 0 & SW0 == 1) ns = C;
				else                          ns = D; 
			B: if (SW1 == 0 & SW0 == 0)      ns = A;
			   else if (SW1 == 0 & SW0 == 1) ns = D;
				else                          ns = C;
			C: if (SW1 == 0 & SW0 == 0)      ns = A;
			   else if (SW1 == 0 & SW0 == 1) ns = B;
				else                          ns = D;
			D: if (SW1 == 0 & SW0 == 0)      ns = A;
			   else if (SW1 == 0 & SW0 == 1) ns = C;
				else                          ns = B;
		endcase
   end
   // Output logic-could also be another always, or part of above block.
	
	logic [2:0] pattern;
	always_comb begin
	   case (ps)
		   A: begin 
			   pattern[2] = 1;
		      pattern[1] = 0;
		      pattern[0] = 1;
			end 
			B: begin 
			   pattern[2] = 0;
		      pattern[1] = 1;
		      pattern[0] = 0;
			end
			C: begin
			   pattern[2] = 0;
		      pattern[1] = 0;
		      pattern[0] = 1;
			end
			D: begin
			   pattern[2] = 1;
		      pattern[1] = 0;
		      pattern[0] = 0;
			end
	   endcase
   end
	assign out = pattern;
	//assign out = ps;
	
	// DFFs
	always_ff@(posedge clk)begin
	   if (reset)
		   ps <= A;
		else
		   ps <= ns;
   end
endmodule


module simple_testbench();
   logic clk, reset, w1, w0;
	logic out;
	
	hazardlight h (clk, reset, w1, w0, out);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
	   clk<= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design.  Each line is a clock cycle.
	initial begin
	                       @(posedge clk);
      reset <= 1;         @(posedge clk);
		reset <= 0; w1 <= 0; w0 <=0; @(posedge clk);
		                    @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
					   w1 <= 1; w0 <=0; @(posedge clk);
						w1 <= 0; w0 <=0; @(posedge clk);
						w1 <= 0; w0 <=1; @(posedge clk);
						        @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
					   w1 <= 0; w0 <=0; @(posedge clk);
						        @(posedge clk);
      $stop; // End the simulation.
   end
endmodule
