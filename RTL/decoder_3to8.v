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