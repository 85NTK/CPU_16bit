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