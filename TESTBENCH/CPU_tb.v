`timescale 1ns/1ps

module tb_CPU;

	// Inputs
	reg clk;
	reg run;
	reg resetn;
	reg [15:0] din;

	// Outputs
	wire [15:0] Bus;
	wire Done;

	// Instantiate the CPU module
	CPU uut (
		.clk(clk),
		.run(run),
		.resetn(resetn),
		.din(din),
		.Bus(Bus),
		.Done(Done)
	);

	// Clock generation
	initial begin
	
		clk = 0;
		forever #5 clk = ~clk;
		
	end

	// Test scenario
	initial begin
	
		// Initialize inputs
		run = 1;
		resetn = 0;
		din = 16'h0000;

		// Apply reset
		#10 resetn = 1;

		// Test case 1
		#20 din = 16'b0001001_000_110_100;
		
		// Test case 2
		#20 din = 16'b0101011_001_111_000;
		
		// Test case 3
		#20 din = 16'h0101011_010_111_000;

		// Add more test cases as needed

		#100 $finish; // Stop simulation after 100 time units
		
	end
	  
	initial begin
	
		$dumpfile ("CPU.vcd");
		$dumpvars;
		
	end

endmodule
