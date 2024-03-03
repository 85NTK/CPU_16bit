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
