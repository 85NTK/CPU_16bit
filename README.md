# CPU_16bit
## COUNTER
### Flowchart
![counter_flowchart](/FLOWCHART/counter_Block.png)

|Sequence number|Name pin|Number of bits|Terminal|Function|
|---------------|--------|--------------|--------|--------|
|1|clear|1|input||
|2|clock|1|input||
|3|state|2|output|data_out|

### RTL code
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
### Testbench
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
### Verification
![counter_verification](/VERIFICATION/counter_Verification_Result.png)

## REGISTER
### Flowchart
![register_flowchart](/FLOWCHART/register_Block.png)

|Sequence number|Name pin|Number of bits|Terminal|Function|
|---------------|--------|--------------|--------|--------|
|1|rin[...]|1|input|enable|
|2|clock|1|input||
|3|buswires|16|input|data_in|
|4|r[...]|16|output|data_out|

### RTL code
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
### Testbench
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
### Verification
![register_verification](/VERIFICATION/register_Verification_Result.png)

## MULTIPLEXER
### Flowchart
![mux_flowchart](/FLOWCHART/multiplexer_Block.png)

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
|13|rout|3|input|selection|
|14|din_en|1|input|selection|
|15|gout|1|input|selection|

### RTL code
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
### Testbench
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
### Verification
![mux_verification](/VERIFICATION/mux_Verification_Result.png)

## ALU
### Flowchart
![alu_block](/FLOWCHART/alu_Block.png)

|Sequence number|Name pin|Number of bits|Terminal|Function|
|---------------|--------|--------------|--------|--------|
|1|buswires|16|input|data_in|
|2|clock|1|input||
|3|ain|1|input|control_in|
|4|gin|1|input|control_in|
|5|sub|1|input|control_in|
|6|alu_out|16|output|data_out|

![alu_flowchart](/FLOWCHART/alu_Flowchart.png)

### RTL code
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

module AddSub(raout, buswires, sub, result);
  // Inputs
  input [15:0] raout;
  input [15:0] buswires;
  input sub;
  
  // Outputs
  output reg [15:0] result;
  
  always @(*) begin
    if (sub) begin
      result <= raout - buswires;
    end else begin
      result <= raout + buswires;
    end
  end  
endmodule

module alu (buswires, clk, ain, sub, gin, aluout);
  // Inputs
  input clk, ain, sub, gin;
  input [15:0] buswires;
  
  // Outputs
  output reg [15:0] aluout;
  wire [15:0] raout;
  wire [15:0] result;
  
  register A(.clk(clk), .r_in(ain), .buswires(buswires), .r_out(raout));
  AddSub AddSub1 (.raout(raout), .buswires(buswires), .sub(sub),.result(result));
  register G(.clk(clk), .r_in(gin), .buswires(result), .r_out(aluout));
  
endmodule
```
### Testbench
```verilog
`timescale 1ns/1ps

module alu_tb ();
  wire [15:0] aluout;
  
  reg clk, ain, sub, gin;
  reg [15:0] buswires;
  
  alu alu_tb (
    .clk(clk), 
    .ain(ain), 
    .sub(sub), 
    .gin(gin), 
    .buswires(buswires),
    .aluout(aluout)
  );
  
  always #10 clk = ~clk;
  
  initial begin
    
    clk = 1'b0;
    ain = 1'b0;
    gin = 1'b0;
    sub = 1'b0;
    buswires = 16'd0;
    #5
    ain = 1'b1;
  end
  
  initial begin
    #20
    gin = 1'b1; buswires = 16'd1; 
    #20 
    buswires = 16'd2; 
    #20 
    buswires = 16'd3; 
    #20 
    buswires = 16'd4; 
    #20 
    buswires = 16'd5; 
    #20 
    buswires = 16'd6; 
    #40
    sub = 1'b1; buswires = 16'd7;
    #20
    buswires = 16'd6;
	    #20
    buswires = 16'd5; 
    #20 
    buswires = 16'd4;
    #20 
    buswires = 16'd3; 
    #20 
    buswires = 16'd2; 
    #20 
    buswires = 16'd1; 
    #50
    $finish;
    
  end
  
  initial begin
    $dumpfile("alu.vcd");
    $dumpvars;
  end
  
endmodule
```
### Verification
![alu_verification](/VERIFICATION/alu_Verification_Result.png)

## CU
### Flowchart
![cu_block](/FLOWCHART/cu_Block.png)

|Sequence number|Name pin|Number of bits|Terminal|Function|
|---------------|--------|--------------|--------|--------|
|1|Run|1|input|Run|
|2|resetn|1|input|Reset|
|3|Ir|9|input|inst|
|4|state|2|input|Inst cycle|
|5|ain|1|output|Enable A|
|6|gin|1|output|Enable G|
|7|sub|1|output|Select add or sub|
|8|rin|8|output|Enable r0-r7|
|9|rout|3|output|-> mux|
|10|din_en|1|output|-> mux|
|11|ir_en|1|output|Enable ir|
|12|clear|1|output|Clear counter|
|13|done|1|output|complete|

### RTL code
```verilog
module decoder_3to8 (input [2:0] iIn, output [7:0] oOut);
    assign oOut = (iIn == 3'b000) ? 8'b0000_0001 :
                (iIn == 3'b001) ? 8'b0000_0010 :
                (iIn == 3'b010) ? 8'b0000_0100 :
                (iIn == 3'b011) ? 8'b0000_1000 :
                (iIn == 3'b100) ? 8'b0001_0000 :
                (iIn == 3'b101) ? 8'b0010_0000 :
                (iIn == 3'b110) ? 8'b0100_0000 :
                                 8'b1000_0000 ;
endmodule

module control_unit(
	// Inputs
	input iRun, iRst_n,
	input [8:0] ir,
	input [1:0] iState,
	
	// Output regs
	output reg oAin,
	output reg oGin,
	output reg oSub,
	output reg oGout,
	output reg oDin_en,
	output reg oIr_en,
	output reg oDone,
	output reg oClear,
	output reg [2:0] oRout,
	output reg [7:0] oRin
);

	wire [2:0] opcode;
	wire [2:0] rx_address_undecoded;
	wire [2:0] ry_address_undecoded;
	wire [7:0] rx_address_decoded;
	
	assign opcode = ir[8:6]; // Ma lenh
	assign rx_address_undecoded = ir[5:3]; // Dia chi rx
	assign ry_address_undecoded = ir[2:0]; // Dia chi ry
	
	
	always @(*) begin
		if (iRun) begin
			if (~iRst_n) begin
				oAin    <= 1'b0;
				oGin    <= 1'b0;
				oSub    <= 1'b0;
				oGout 	<= 1'b0;
				oDin_en <= 1'b0;
				oIr_en  <= 1'b0;
				oDone   <= 1'b0;
				oClear  <= 1'b1; // Xoa counter
				oRout   <= 3'b0;
				oRin    <= 8'b0;
			end	else begin
				oClear <= 1'b0;
				case(iState)
					2'b00: begin
						oIr_en <= 1'b1;
					end
					2'b01: begin
						case(opcode)
							3'b000: begin
								oRout <= ry_address_undecoded;
								oRin  <= rx_address_decoded;
								oDone <= 1'b1;
							end
							3'b001: begin
								oRin  <= rx_address_decoded;
								oDone <= 1'b1;
							end
							3'b010, 3'b011: begin
								oRout <= rx_address_undecoded;
								oAin <= 1'b1;
							end
						endcase
					end
					2'b10: begin
						case(opcode)
							3'b010: begin
								oRout <= ry_address_undecoded;
								oSub <= 1'b0;
								oGin <= 1'b1;
							end
							3'b011: begin
								oRout <= ry_address_undecoded;
								oSub <= 1'b1;
								oGin <= 1'b1;
							end
						endcase
					end
					2'b11: begin
						oRin <= rx_address_decoded;
						oGout <= 1'b1;
						oDin_en <= 1'b1;
					end
				endcase
			end
		end
	end
	
decoder_3to8 decoder_3to8(
	.iIn (rx_address_undecoded),
	.oOut (rx_address_decoded)
);

endmodule
```
### Testbench
```verilog
`timescale 1ns / 1ps

module control_unit_tb;

    // Inputs
    reg iRun;
    reg iRst_n;
    reg [8:0] ir;
    reg [1:0] iState;

    // Output regs
    wire oAin;
    wire oGin;
    wire oSub;
    wire oGout;
    wire oDin_en;
    wire oIr_en;
    wire oDone;
    wire oClear;
    wire [2:0] oRout;
    wire [7:0] oRin;

    // Instantiate the Unit Under Test (UUT)
    control_unit uut (
        .iRun(iRun), 
        .iRst_n(iRst_n), 
        .ir(ir), 
        .iState(iState), 
        .oAin(oAin), 
        .oGin(oGin), 
        .oSub(oSub), 
        .oGout(oGout), 
        .oDin_en(oDin_en), 
        .oIr_en(oIr_en), 
        .oDone(oDone), 
        .oClear(oClear), 
        .oRout(oRout), 
        .oRin(oRin)
    );

    initial begin
        // Initialize Inputs
        iRun = 0;
        iRst_n = 0;
        ir = 0;
        iState = 0;
        #10;
        iRun = 1;
        iRst_n = 0;
        ir = 0;
        iState = 0;
      	#10;

        // Add stimulus here
        iRun = 1;
        iRst_n = 1'b1;
      	iState = 2'b00;
        #10;
        iState = 2'b01;
      	ir = 9'b000_000_000;
        #10;
      	ir = 9'b001_000_000;
      	#10;
      	ir = 9'b010_000_000;
      	#10
        iState = 2'b10;
      	ir = 9'b010_000_000;
      	#10;
      	ir = 9'b011_000_000;
        #10;
        iState = 2'b11;
        #10;
        $finish;
    end
  	initial begin
		$dumpfile("cu.vcd");
		$dumpvars;
	end

endmodule
```
### Verification
![cu_verification](/VERIFICATION/cu_Verification_Result.png)

## CPU
### Flowchart
![CPU_block](/FLOWCHART/CPU_Block.png)
### CPU includes:
- 8 register 16bit R0, R1, ..., R7: store the necessary data
- 1 mux 10 input, 1 output: control the data flow in CPU
- 1 alu: perform addition and subtraction operations
- 1 register IR 9bit decryption of commands: help CPU signal from outside in
- 1 counter (2bit): help the control block manage the process
- 1 control unit: throttle the entire operation of the CPU
### RTL code
```verilog
module CPU(
	// Inputs
	input clk,
	input run,
	input resetn,
	input [15:0] din,
	
	// Outputs
	output [15:0] Bus,
	output Done
	);
	
	
	wire [7:0] Rin_en;
	
	wire [15:0] R0_out;
	wire [15:0] R1_out;
	wire [15:0] R2_out;
	wire [15:0] R3_out;
	wire [15:0] R4_out;
	wire [15:0] R5_out;
	wire [15:0] R6_out;
	wire [15:0] R7_out;
	
	// IR block
	wire [8:0] IR_in;
	wire IR_en;
	wire [8:0] IR_out;
	
	// Counter block
	wire clear;
	wire [1:0] counter_out;
	
	// Alu block
	wire alu_ain;
	wire alu_sub;
	wire alu_gin;
	wire [15:0] alu_out;
	
	// Multiplexer
	wire Din_en; // Din_out
	wire Alu_en; // Gout
	wire [2:0] Reg_en;
	
	assign IR_in = din[8:0];
	
	
	// Control Unit
	control_unit control_unit(
		.iRun (run),
		.iRst_n (resetn),
		.ir (IR_out),
		.iState (counter_out),
		.oAin (alu_ain),
		.oGin (alu_gin),
		.oSub (alu_sub),
		.oGout (Alu_en),
		.oDin_en (Din_en),
		.oIr_en (IR_en),
		.oDone (Done),
		.oClear (clear),
		.oRout (Reg_en),
		.oRin (Rin_en)
	);
		
	// Register 0 to 7
	register Rin_0(
		.buswires (Bus),
		.clk (clk),
		.r_in (Rin_en[0]),
		.r_out (R0_out)
	);
	register Rin_1(
		.buswires (Bus),
		.clk (clk),
		.r_in (Rin_en[1]),
		.r_out (R1_out)
	);		
	register Rin_2(
		.buswires (Bus),
		.clk (clk),
		.r_in (Rin_en[2]),
		.r_out (R2_out)
	);	
	register Rin_3(
		.buswires (Bus),
		.clk (clk),
		.r_in (Rin_en[3]),
		.r_out (R3_out)
	);
	register Rin_4(
		.buswires (Bus),
		.clk (clk),
		.r_in (Rin_en[4]),
		.r_out (R4_out)
	);
	register Rin_5(
		.buswires (Bus),
		.clk (clk),
		.r_in (Rin_en[5]),
		.r_out (R5_out)
	);
	register Rin_6(
		.buswires (Bus),
		.clk (clk),
		.r_in (Rin_en[6]),
		.r_out (R6_out)
	);
	register Rin_7(
		.buswires (Bus),
		.clk (clk),
		.r_in (Rin_en[7]),
		.r_out (R7_out)
	);
		
		
	// IR block
	reg_9b IR_block(
		.clk (clk),
		.enable (IR_en),
		.data_in (IR_in),
		.data_out (IR_out)
	);
		
	// Counter block
	counter counter(
		.clk (clk),
		.clear (clear),
		.state (counter_out)
	);
		
	// ALU block
	alu alu(
		.clk (clk),
		.buswires (Bus),
		.ain (alu_ain),
		.gin (alu_gin),
		.sub (alu_sub),
		.aluout (alu_out)
	);
		
	// Multiplexer block
	multiplexer mux(
		.din (din),
		.aluout (alu_out),
		.r0 (R0_out),
		.r1 (R1_out),
		.r2 (R2_out),
		.r3 (R3_out),	
		.r4 (R4_out),
		.r5 (R5_out),
		.r6 (R6_out),
		.r7 (R7_out),
		.din_en (Din_en),
		.gout (Alu_en),
		.r_out (Reg_en),
		.buswires (Bus)
	);
		
endmodule

module decoder_3to8 (input [2:0] iIn, output [7:0] oOut);

    assign oOut = (iIn == 3'b000) ? 8'b0000_0001 :
                (iIn == 3'b001) ? 8'b0000_0010 :
                (iIn == 3'b010) ? 8'b0000_0100 :
                (iIn == 3'b011) ? 8'b0000_1000 :
                (iIn == 3'b100) ? 8'b0001_0000 :
                (iIn == 3'b101) ? 8'b0010_0000 :
                (iIn == 3'b110) ? 8'b0100_0000 :
                                 8'b1000_0000 ;
								 
endmodule

module control_unit(
	// Inputs
	input iRun, iRst_n,
	input [8:0] ir,
	input [1:0] iState,
	
	// Output regs
	output reg oAin,
	output reg oGin,
	output reg oSub,
	output reg oGout,
	output reg oDin_en,
	output reg oIr_en,
	output reg oDone,
	output reg oClear,
	output reg [2:0] oRout,
	output reg [7:0] oRin
);

	wire [2:0] opcode;
	wire [2:0] rx_address_undecoded;
	wire [2:0] ry_address_undecoded;
	wire [7:0] rx_address_decoded;
	
	assign opcode = ir[8:6]; // Ma lenh
	assign rx_address_undecoded = ir[5:3]; // Dia chi rx
	assign ry_address_undecoded = ir[2:0]; // Dia chi ry
	
	
	always @(*) begin
		if (iRun) begin
			if (~iRst_n) begin
				oAin    <= 1'b0;
				oGin    <= 1'b0;
				oSub    <= 1'b0;
				oGout 	<= 1'b0;
				oDin_en <= 1'b0;
				oIr_en  <= 1'b0;
				oDone   <= 1'b0;
				oClear  <= 1'b1; // Xoa counter
				oRout   <= 3'b0;
				oRin    <= 8'b0;
			end	else begin
				oClear <= 1'b0;
				case(iState)
					2'b00: begin
						oIr_en <= 1'b1;
					end
					2'b01: begin
						case(opcode)
							3'b000: begin
								oRout <= ry_address_undecoded;
								oRin  <= rx_address_decoded;
								oDone <= 1'b1;
							end
							3'b001: begin
								oRin  <= rx_address_decoded;
								oDone <= 1'b1;
							end
							3'b010, 3'b011: begin
								oRout <= rx_address_undecoded;
								oAin <= 1'b1;
							end
						endcase
					end
					2'b10: begin
						case(opcode)
							3'b010: begin
								oRout <= ry_address_undecoded;
								oSub <= 1'b0;
								oGin <= 1'b1;
							end
							3'b011: begin
								oRout <= ry_address_undecoded;
								oSub <= 1'b1;
								oGin <= 1'b1;
							end
						endcase
					end
					2'b11: begin
						oRin <= rx_address_decoded;
						oGout <= 1'b1;
						oDin_en <= 1'b1;
					end
				endcase
			end
		end
	end
	
decoder_3to8 decoder_3to8(
	.iIn (rx_address_undecoded),
	.oOut (rx_address_decoded)
);

endmodule

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

module reg_9b (
    input clk,
    input enable,
    input [8:0] data_in,
    output [8:0] data_out
);

	reg [8:0] reg_data;

	always @(posedge clk) begin
		if (enable) begin
			reg_data <= data_in;
		end
	end

	assign data_out = reg_data;

endmodule

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

module AddSub(raout, buswires, sub, result);
	  // Inputs
	  input [15:0] raout;
	  input [15:0] buswires;
	  input sub;
	  
	  // Outputs
	  output reg [15:0] result;
	  
	  always @(*) begin
		if (sub) begin
		  result <= raout - buswires;
		end else begin
		  result <= raout + buswires;
		end
	  end  
endmodule

module alu (buswires, clk, ain, sub, gin, aluout);
	  // Inputs
	  input clk, ain, sub, gin;
	  input [15:0] buswires;
	  
	  // Outputs
	  output reg [15:0] aluout;
	  wire [15:0] raout;
	  wire [15:0] result;
	  
	  register A(.clk(clk), .r_in(ain), .buswires(buswires), .r_out(raout));
	  AddSub AddSub1 (.raout(raout), .buswires(buswires), .sub(sub),.result(result));
	  register G(.clk(clk), .r_in(gin), .buswires(result), .r_out(aluout));
  
endmodule

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
### Testbench
```verilog
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
```
### Verification
![CPU_verification](/VERIFICATION/CPU_Verification_Result.png)

## LOGIC SYNTHESIS
### Library

