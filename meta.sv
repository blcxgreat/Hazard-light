
module meta(clk, d1, q1, q2); 
    
	 input logic clk, d1;
	 output logic q1, q2;
	 
	    always_ff @(posedge clk) begin
		     q1 <= d1;
			  q2 <= q1;
		 end

endmodule

module meta_testbench();
   logic clk,w1;
	logic out1, out2;
	
	meta h (clk, w1, out1, out2);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
	   clk<= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design.  Each line is a clock cycle.
	initial begin
	                       @(posedge clk);
                          @(posedge clk);
		            w1 <= 0;@(posedge clk);
		                    @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
					   w1 <= 1;@(posedge clk);
						        @(posedge clk);
						w1 <= 0;@(posedge clk);
						        @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
					   w1 <= 1;@(posedge clk);
						        @(posedge clk);
      $stop; // End the simulation.
   end
endmodule
