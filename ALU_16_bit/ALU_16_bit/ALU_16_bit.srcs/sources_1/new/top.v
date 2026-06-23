`timescale 1ns / 1ps
`include "ALU_16_bit.v"
`include "seven_seg_controller.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2026 11:19:05 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input wire clk,
    input wire reset,
    input wire[15:0] sw,
    input wire BTNC,
    input wire BTNU,
    input wire BTNL,
    output wire Carry_flag,
    output wire Arith,
    output wire Logic,
    output wire Cmp,
    output wire Shift,
    output wire ALU_ready,
    output wire[6:0] seg,
    output wire dp,
    output wire[7:0] an
);

wire[15:0] opd_A;
wire[15:0] opd_B;
wire[15:0] out;

wire[9:0] clk_counter;
wire new_clk; // New clk set to 100kHz

// Modifying clock 100MHz (clk) -> 100kHz (new_clk)
/*always @(posedge clk or posedge reset) begin
    if(reset) begin
      clk_counter <= 10'b0;
      new_clk <= 1'b0;
    end
    else if(clk_counter < 10'd999) begin
      clk_counter <= clk_counter + 1;
    end
    else if(clk_counter == 10'd999) begin
      clk_counter <= 10'b0;
      new_clk <= 1'b1;
    end
end*/

// ALU_16_bit Instantiation
ALU_16bit sys_alu(
    .reset(reset), // Used to reset operands
    .clk(clk), // Setting clk
    .sw(sw), // Physical slide switches | Use to set operand values
    .BTNC(BTNC), // Sets for Operand A
    .BTNU(BTNU), // Sets for Operand B
    .BTNL(BTNL), // Sets opcode
    .out(out),
    .opd_A(opd_A),
    .opd_B(opd_B),
    .Carry_flag(Carry_flag), // Carry flag set
    .Arith(Arith), 
    .Logic(Logic), 
    .Cmp(Cmp), 
    .Shift(Shift)
);

// 7 segment controller Instantiation
seven_seg_controller sys_display(
    .clk(clk),
    .reset(reset),
    .opd_A(opd_A),
    .opd_B(opd_B),
    .out(out),
    .seg(seg), // 7 segments, of the 7segment display
    .dp(dp), // For decimal points
    .an(an)
);

endmodule
