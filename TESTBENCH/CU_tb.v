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