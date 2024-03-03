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

## REGISTER
## DECODER
## MULTIPLEXER
## ALU
## CU
## CPU
## LOGIC SYNTHESIS
