`timescale 1ns/10ps 
module register_testbench ( ) ; 
	wire [15:0] r_out; 
	reg clk; 
	reg r_in;
  	reg[15:0] buswires;
  
	register dut (.r_out (r_out[15:0]), .r_in (r_in), .clk (clk), .buswires(buswires[15:0]));
  
	always #10 clk = ~clk;
	
	initial begin 
		$monitor ("time=%5d ns, clk=%b, r_in=%b, buswires=%b, r_out=%b", $time, clk, r_in, buswires[15:0], r_out[15:0]);
		// Initialize Inputs
        clk = 0;
        r_in = 0;
        buswires = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Add stimulus here
        r_in = 1;
        buswires = 16'hABCD;
        #10;
        r_in = 0;
        #10;
		$display("All tests completed sucessfully\n\n"); 
		$finish; 
	end 
	
	initial begin 
		$dumpfile("register.vcd");
		$dumpvars;
	end 
endmodule // counter_testbench