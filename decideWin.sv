
module decideWin(clk, reset, L, R, leftleds, rightleds, display);
   
	input logic clk, reset, leftleds, rightleds;
	input logic L, R;
	output logic [6:0] display;
	
	logic [6:0] temp;
	
	// State variables.
	enum {A, B, C} ps, ns;
	
	always_comb begin
	   case (ps)
		   A: begin
			temp = 7'b1111111;//0
			if (L&~R&leftleds)                         
               ns = B;          
				else if (~L&R&rightleds)                    
				   ns = C;
				else 
             	ns = A;
					end
		   B: begin
			temp = 7'b1111001;//1 
			   ns = B;
				end
			C: begin
			temp = 7'b0100100;//2
			   ns = C;
		      end
	      default temp = 7'b1111111;	
		endcase
   end
	
	assign display = temp;
	
	// DFFs
	always_ff@(posedge clk)begin
	   if (reset)
		   ps <= A;
		else
		   ps <= ns;
   end	
endmodule
	
module decide_testbench();
   logic clk, reset, L, R, NL, NR;
	logic out;
	
	decideWin h (clk, reset, L, R, NL, NR, out);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
	   clk<= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design.  Each line is a clock cycle.
	initial begin
	   reset <= 1;         @(posedge clk);
                          @(posedge clk);
								  @(posedge clk);
		reset <= 0; L <= 1; R <=0; NL <= 1; NR <= 0; @(posedge clk);
		                    @(posedge clk);
								  @(posedge clk);
		reset <= 1;         @(posedge clk);
					           @(posedge clk);
		reset <= 0; L <= 0; R <=1; NL <= 0; NR <= 1; @(posedge clk);
						        @(posedge clk);
						        @(posedge clk);
								  @(posedge clk);
		reset <= 0; L <= 1; R <=1; NL <= 0; NR <= 0; @(posedge clk);
		                    @(posedge clk);
								  @(posedge clk);
      $stop; // End the simulation.
   end
endmodule
