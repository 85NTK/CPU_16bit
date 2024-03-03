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
## Verification
![counter_verification](/VERIFICATION/counter_Verification_Result.png)

## REGISTER
## Flowchart
![counter_flowchart](/FLOWCHART/register_Block.png)

|Sequence number|Name pin|Number of bits|Terminal|Function|
|---------------|--------|--------------|--------|--------|
|1|rin[...]|1|input|enable|
|2|clock|1|input||
|3|buswires|16|input|data_in|
|4|r[...]|16|output|data_out|

## RTL code
```verilog
module register(clk, r_in, buswires, r_out);
	// Inputs
	input clk, r_in;
	input [15:0] buswires;
	
	// Outputs
	output [15:0] r_out;
	reg [15:0] r_out;
	
	always @(posedge clk) begin
		if (r_in) begin
			r_out <= buswires;
		end
	end
	
endmodule
```
## Testbench
```verilog
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
```
## Verification
![counter_verification](/VERIFICATION/register_Verification_Result.png)
## DECODER
## MULTIPLEXER
## ALU
## CU
## CPU
## LOGIC SYNTHESIS
