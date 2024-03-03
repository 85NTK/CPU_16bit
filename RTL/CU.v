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