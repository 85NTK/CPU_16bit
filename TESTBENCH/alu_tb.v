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
    