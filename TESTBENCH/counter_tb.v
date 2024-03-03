`timescale 1ns/10ps 
module counter_testbench ( ) ; 
	wire [1:0] state; 
	reg clk; 
	reg clear;
	  
	counter dut (.state (state[1:0]), .clear (clear), .clk (clk));
	  
	always #10 clk = ~clk; 
	
	initial begin 
		$monitor ("time=%5d ns, clk=%b, clear=%b, state=%b", $time, clk, clear, state[1:0]);
		clk = 1'b0; 
		clear = 1'b0; 
		clear = 1'b1; 
		@(posedge clk);#1; 
		clear = 1'b0; 
		@(posedge clk);#1; 
		@(posedge clk);#1; 
		@(posedge clk);#1; 
		@(posedge clk);#1; 
		@(posedge clk);#1; 
		@(posedge clk);#1; 
		@(posedge clk);#1;  
		$display("All tests completed sucessfully\n\n"); 
		$finish; 
	end 
	
	initial begin 
		$dumpfile("counter.vcd");
		$dumpvars;
	end
	
endmodule // counter_testbench