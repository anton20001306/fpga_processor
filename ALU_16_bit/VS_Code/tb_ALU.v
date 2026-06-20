`timescale 1ns/1ps
`include "ALU_16bit.v"

module tb_ALU();

reg reset;
reg clk;
reg[15:0] sw;
reg BTNC;
reg BTNU;
wire[15:0] out;
wire Carry_flag;
wire Arith; 
wire Logic; 
wire Cmp; 
wire Shift;

ALU_16bit dut(
    .reset(reset),
    .clk(clk),
    .sw(sw),
    .BTNC(BTNC),
    .BTNU(BTNU),
    .out(out),
    .Carry_flag(Carry_flag),
    .Arith(Arith), .Logic(Logic), .Cmp(Cmp), .Shift(Shift)
);

// 100 MHz clock (10ns period)

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    
    reset = 1'b1; #10; // reset
    reset = 1'b0;

    BTNC = 1; sw = 16'd32; #10; // set operand A
    BTNC = 0; BTNU = 1; sw = 16'd45; #10; // set operand B
    BTNU = 0; 
    
    // Setting operations
    sw = 16'd0; #10; // Unsigned addition
    sw = 16'd1; #10; // Unsigned subtraction
    sw = 16'd2; #10; // Unsigned Multiplication
    sw = 16'd3; #10; // Unsigned Division
    sw = 16'd4; #10; // AND
    sw = 16'd5; #10; // OR
    sw = 16'd6; #10; // NAND
    sw = 16'd7; #10; // NOR
    sw = 16'd8; #10; // XOR
    sw = 16'd9; #10; // XNOR;
    sw = 16'd10; #10; // Equals
    sw = 16'd11; #10; // Greater
    sw = 16'd12; #10; // Lesser
    sw = 16'd13; #10; // Right shift
    sw = 16'd14; #10; // Light shift

    reset = 1'b1; #10; // reset system

    $finish;

end

initial begin
    $dumpfile("tb_ALU.vcd");
    $dumpvars(0, tb_ALU);
end

endmodule