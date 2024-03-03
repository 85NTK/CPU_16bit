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
		