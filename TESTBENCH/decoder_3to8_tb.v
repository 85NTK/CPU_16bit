`timescale 1ns/1ps
module decoder_3to8_tb;
    reg [2:0] iIn;
    wire [7:0] oOut;
    decoder_3to8 decoder_3to8_tb(iIn, oOut);
    
    initial begin
        iIn = 3'b000;
        #10;
        iIn = 3'b001;
        #10;
        iIn = 3'b010;
        #10;
        iIn = 3'b011;
        #10;
        iIn = 3'b100;
        #10;
        iIn = 3'b101;
        #10;
        iIn = 3'b110;
        #10;
        iIn = 3'b111;
        #10;
        $finish;
    end
  
    initial begin
        $dumpfile("alu.vcd");
        $dumpvars;
  	end
endmodule
