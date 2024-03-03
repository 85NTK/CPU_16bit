# CPU_16bit
## COUNTER
## Flowchart
![counter_flowchart](/FLOWCHART/counter_Block.png)

|Sequence number|Name pin|Number of bits|Terminal|Function|
|---------------|--------|--------------|--------|--------|
|1|clear|1|input||
|2|clock|1|input||
|3|state|2|output|data_out|

## RTL code
```verilog
module counter ( state, clk, clear ) ;

	input clk, clear; 
	output [1:0] state; 
	
	reg [1:0] state; 
	wire [1:0] next;
	

	assign next = clear ? 2'b0 : (state + 2'b1);

	always @ ( posedge clk ) begin 
		state <= #1 next; 
	end
	
endmodule // counter
```
## Testbench
```verilog
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
```
## REGISTER
## DECODER
## MULTIPLEXER
## ALU
## CU
## CPU
## LOGIC SYNTHESIS
