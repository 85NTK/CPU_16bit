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

## MULTIPLEXER
## Flowchart
![counter_flowchart](/FLOWCHART/multiplexer_Block.png)

|Sequence number|Name pin|Number of bits|Terminal|Function|
|---------------|--------|--------------|--------|--------|
|1|din|16|input|datatin|
|2|r0|16|input|data_in|
|3|r1|16|input|data_in|
|4|r2|16|input|data_in|
|5|r3|16|input|data_in|
|6|r4|16|input|data_in|
|7|r5|16|input|data_in|
|8|r6|16|input|data_in|
|9|r7|16|input|data_in|
|---------------|--------|--------------|--------|--------|
|11|aluout|16|input|data_in|
|12|buswires|16|output|data_out|
|13|rout|3|i|selection|
|14|din_en|1|i|selection|
|15|gout|1|i|selection|

## RTL code
```verilog
module multiplexer (din, r0, r1, r2, r3, r4, r5, r6, r7, aluout, r_out, din_en, gout, buswires);
	input [15:0] din, r0, r1, r2, r3, r4, r5, r6, r7, aluout;
	input [2:0] r_out;
	input din_en, gout;
	
	output [15:0] buswires;
	reg [15:0] buswires;

    always @(*) begin
        if (din_en) begin
            buswires = din;
        end else begin
            if (gout) begin
                buswires = aluout;
            end else begin
                case (r_out)
                    3'b000: buswires = r0;
                    3'b001: buswires = r1;
                    3'b010: buswires = r2;
                    3'b011: buswires = r3;
                    3'b100: buswires = r4;
                    3'b101: buswires = r5;
                    3'b110: buswires = r6;
                    3'b111: buswires = r7;
                    default: buswires = r0;
                endcase
            end
        end
    end

endmodule
```
## Testbench
```verilog
`timescale 1ns/1ps

module multiplexer_tb ();
	reg [15:0] din, r0, r1, r2, r3, r4, r5, r6, r7, aluout;
	reg [2:0] r_out;
	reg din_en, gout;

	wire [15:0] buswires;
	
    multiplexer mux_tb (
        .din(din), 
        .r0(r0), 
        .r1(r1), 
        .r2(r2), 
        .r3(r3), 
        .r4(r4), 
        .r5(r5), 
        .r6(r6), 
        .r7(r7), 
        .aluout(aluout), 
        .r_out(r_out), 
        .din_en(din_en), 
        .gout(gout), 
        .buswires(buswires)
    );

	
	   initial begin
        // Initialize Inputs
        din = 16'h0;
        r0 = 16'h0;
        r1 = 16'h0;
        r2 = 16'h0;
        r3 = 16'h0;
        r4 = 16'h0;
        r5 = 16'h0;
        r6 = 16'h0;
        r7 = 16'h0;
        aluout = 16'h0;
        r_out = 3'b000;
        din_en = 1'b0;
        gout = 1'b0;

        // Wait 10 ns for global reset to finish
        #10;

        // Add stimulus here
        din = 16'h0;
        r0 = 16'h1;
        r1 = 16'h2;
        r2 = 16'h3;
        r3 = 16'h4;
        r4 = 16'h5;
        r5 = 16'h6;
        r6 = 16'h7;
        r7 = 16'h8;
        aluout = 16'h9;
        #10
        din_en = 1'b1;
        #10;
        din_en = 1'b0;
        gout = 1'b1;
        #10;
        din_en = 1'b0;
        gout = 1'b0;
        r_out = 3'b000;
        #10;
        din_en = 1'b0;
        gout = 1'b0;
        r_out = 3'b001;
        #10;
        din_en = 1'b0;
        gout = 1'b0;
        r_out = 3'b010;
        #10
        din_en = 1'b0;
        gout = 1'b0;
        r_out = 3'b011;
        #10
        din_en = 1'b0;
        gout = 1'b0;
        r_out = 3'b100;
        #10
        din_en = 1'b0;
        gout = 1'b0;
        r_out = 3'b101;
        #10
        din_en = 1'b0;
        gout = 1'b0;
        r_out = 3'b110;
        #10
        din_en = 1'b0;
        gout = 1'b0;
        r_out = 3'b111;
        #10;
        $finish;
    end
	
	initial begin 
		$dumpfile("multiplexer.vcd");
		$dumpvars;
	end
	
endmodule
```
## Verification
![counter_verification](/VERIFICATION/multiplexer_Verification_Result.png)
## ALU
## CU
## CPU
## LOGIC SYNTHESIS
