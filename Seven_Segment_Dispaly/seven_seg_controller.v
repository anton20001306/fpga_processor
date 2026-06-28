`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 06/20/2026 10:09:29 PM
// Design Name:
// Module Name: seven_seg_controller
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


module seven_seg_controller(
    input  wire clk_i,
    input  wire rstn_i,
    input  wire [15:0] opd_A,
    input  wire [15:0] opd_B,
    input  wire [15:0] out,
    output reg  [6:0] seg,      // 7 segments, of the 7segment display
    output wire dp,             // For decimal points
    output reg  [7:0] an        // Anode | Power switch to activate each display block. Board consists of 8 blocks, hence 8 bits used
  );

  assign dp = 1'b1; // Turn off decimal points (Active Low)

  // Shift and add-3 algorithm used for binary to BCD conversion (Double Dabble algorithm)
  function [7:0] bin8_to_bcd2; // returns {tens[3:0], ones[3:0]} for an 8-bit input
    input [7:0] bin;
    integer i;
    reg [15:0] shift_reg; // [15:12]=tens, [11:8]=ones, [7:0]=binary remainder
    begin
      shift_reg = {8'b0, bin};
      for (i = 0; i < 8; i = i + 1)
      begin
        if (shift_reg[11:8] >= 5)
          shift_reg[11:8] = shift_reg[11:8] + 3;
        if (shift_reg[15:12] >= 5)
          shift_reg[15:12] = shift_reg[15:12] + 3;
        shift_reg = shift_reg << 1;
      end
      bin8_to_bcd2 = shift_reg[15:8]; // {tens, ones}
    end
  endfunction

  function [15:0] bin16_to_bcd4; // returns {th[3:0], h[3:0], t[3:0], o[3:0]} for a 16-bit input
    input [15:0] bin;
    integer i;
    reg [31:0] shift_reg; // 16 BCD bits (4 digits) + 16 binary bits
    begin
      shift_reg = {16'b0, bin};
      for (i = 0; i < 16; i = i + 1)
      begin
        if (shift_reg[19:16] >= 5)
          shift_reg[19:16] = shift_reg[19:16] + 3;
        if (shift_reg[23:20] >= 5)
          shift_reg[23:20] = shift_reg[23:20] + 3;
        if (shift_reg[27:24] >= 5)
          shift_reg[27:24] = shift_reg[27:24] + 3;
        if (shift_reg[31:28] >= 5)
          shift_reg[31:28] = shift_reg[31:28] + 3;
        shift_reg = shift_reg << 1;
      end
      bin16_to_bcd4 = shift_reg[31:16];
    end
  endfunction

  wire[7:0] opd_A_bcd = bin8_to_bcd2(opd_A[7:0]); // tens | ones (A)
  wire[7:0] opd_B_bcd = bin8_to_bcd2(opd_B[7:0]); // tens | ones (B)
  wire[15:0] out_bcd = bin16_to_bcd4(out); // thousands | hundereds | tens | ones (Out)

  reg[19:0] refresh_counter; // Clock divider, high refresh rate

  // Clock adjustment with reset
  always @(posedge clk_i or negedge rstn_i)
  begin
    if(!rstn_i)
    begin
      refresh_counter <= 20'b0;
    end
    else
    begin
      refresh_counter <= refresh_counter + 1;
    end
  end

  wire[2:0] led_activating_counter = refresh_counter[19:17]; // Acts as a counter for multiplexing
  reg[3:0] current_digit; // Represent a digit 0-9 for a block

  // Mux selecting illuminating digit
  always @(*)
  begin
    case (led_activating_counter)
      // Left most 2 digits (Operand A)
      3'b111:
      begin
        an = 8'b01111111;
        current_digit = opd_A_bcd[7:4];
      end // A
      3'b110:
      begin
        an = 8'b10111111;
        current_digit = opd_A_bcd[3:0];
      end // A

      // Middle 2 digits (Operand B)
      3'b101:
      begin
        an = 8'b11011111;
        current_digit = opd_B_bcd[7:4];
      end // B
      3'b100:
      begin
        an = 8'b11101111;
        current_digit = opd_B_bcd[3:0];
      end // B

      // Right most 4 digits (ALU Outputs)
      3'b011:
      begin
        an = 8'b11110111;
        current_digit = out_bcd[15:12];
      end // Out
      3'b010:
      begin
        an = 8'b11111011;
        current_digit = out_bcd[11:8];
      end // Out
      3'b001:
      begin
        an = 8'b11111101;
        current_digit = out_bcd[7:4];
      end // Out
      3'b000:
      begin
        an = 8'b11111110;
        current_digit = out_bcd[3:0];
      end // Out

      default:
      begin
        an = 8'b11111111;
        current_digit = 4'b0;
      end
    endcase
  end

  // Hexadecimal to 7Segment Decoder (Active Low)
  always @(*)
  begin
    case(current_digit)
      4'd0:
        seg = 7'b1000000;
      4'd1:
        seg = 7'b1111001;
      4'd2:
        seg = 7'b0100100;
      4'd3:
        seg = 7'b0110000;
      4'd4:
        seg = 7'b0011001;
      4'd5:
        seg = 7'b0010010;
      4'd6:
        seg = 7'b0000010;
      4'd7:
        seg = 7'b1111000;
      4'd8:
        seg = 7'b0000000;
      4'd9:
        seg = 7'b0010000;
      default:
        seg = 7'b1111111; // Turn all off
    endcase
  end

endmodule
