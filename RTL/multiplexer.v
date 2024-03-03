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
	
	