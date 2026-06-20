`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2026 02:13:49 AM
// Design Name: 
// Module Name: ALU_16_bit
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

// 16bit ALU Operations
// Responsible for carrying out the unsigned arithmetic, logic functions,
// shift functions and comparion functions.

// A,B -> Operands (16 bit)
// ALU_OUT -> Result (16 bit)

module ALU_16_bit(
input wire reset, // Used to reset operands
input wire clk, // Setting clk
input wire[15:0] sw, // Physical slide switches | Use to set operand values
input wire BTNC, // Sets for Operand A
input wire BTNU, // Sets for Operand B
output reg[15:0] out,
output reg Carry_flag, // Carry flag set
output reg Arith, Logic, Cmp, Shift, // Used to represent the type of operations | Setting flags
output reg ALU_ready // Tells the processor the ALU is done
);

// Defining opcodes and operations
parameter usgn_add = 4'b0000;
parameter usgn_sub = 4'b0001;
parameter usgn_mul = 4'b0010;
parameter usgn_div = 4'b0011;
parameter AND = 4'b0100;
parameter OR = 4'b0101;
parameter NAND = 4'b0110;
parameter NOR = 4'b0111;
parameter XOR = 4'b1000;
parameter XNOR = 4'b1001;
parameter A_eq_B = 4'b1010;
parameter A_gr_B = 4'b1011;
parameter A_ls_B = 4'b1100;
parameter R_shift = 4'b1101; // Only opd_A (A)
parameter L_shift = 4'b1110; // Only opd_A (A)

// Defining and initializing internal variables

wire [31:0] div_result; // Holds both quotient and remainder
wire div_valid; // Goes high when division is complete
reg div_start; // Reg to tell IP Core (division) to start
reg [15:0] opd_A = 16'b0; // Operand A
reg [15:0] opd_B = 16'b0; // Operand B
reg [3:0] op_code = 4'b0; // 4 bit opcode with 15 operations (ALU_FUN)

// Instantiating IP Core for Division
div_gen_0 my_divider(
.aclk(clk),
.s_axis_divisor_tvalid(div_start),
.s_axis_divisor_tdata(opd_B),
.s_axis_dividend_tvalid(div_start),
.s_axis_dividend_tdata(opd_A),
.m_axis_dout_tvalid(div_valid),
.m_axis_dout_tdata(div_result)
);

// Logic for updating operands and opcode
always @(posedge clk or posedge reset) begin

    if(reset) begin
      opd_A <= 16'b0;
      opd_B <= 16'b0;
      op_code <= 4'b0;
    end

    else if(BTNC) opd_A <= sw;
    else if(BTNU) opd_B <= sw;
    else op_code <= sw[3:0];
    
end

// Logic for operations
always @(posedge clk or posedge reset) begin

    if(reset) begin
      Arith <= 1'b0;
      Logic <= 1'b0;
      Cmp <= 1'b0; 
      Shift <= 1'b0;
      Carry_flag <= 1'b0;
      ALU_ready <= 1'b0;
      div_start <= 1'b0;
      out <= 16'b0;
    end

    else begin
      Arith <= 1'b0;
      Logic <= 1'b0;
      Cmp <= 1'b0;
      Shift <= 1'b0;
      Carry_flag <= 1'b0;
      ALU_ready <= 1'b1;
      div_start <= 1'b0;

      case (op_code)

        usgn_add: begin
          Arith <= 1'b1;
          {Carry_flag, out} <= opd_A + opd_B;
        end

        usgn_sub: begin
          Arith <= 1'b1;
          {Carry_flag, out} <= opd_A - opd_B;
        end

        usgn_mul: begin
          Arith <= 1'b1;
          out <= opd_A * opd_B;
        end

        usgn_div: begin
          ALU_ready <= 1'b0; // Telling processor to hold
          div_start <= ~div_valid; // Trigger IP core
          Arith <= 1'b1;
          
          if(div_valid) begin
            out <= div_result[15:0];
            ALU_ready <= 1'b1;
            div_start <= 1'b0; // Turn off IP core
          end
        end

        AND: begin
          Logic <= 1'b1;
          out <= opd_A & opd_B;
        end

        OR: begin
          Logic <= 1'b1;
          out <= opd_A | opd_B;
        end

        NAND: begin
          Logic <= 1'b1;
          out <= ~(opd_A & opd_B);
        end

        NOR: begin
          Logic <= 1'b1;
          out <= ~(opd_A | opd_B);
        end

        XOR: begin
          Logic <= 1'b1;
          out <= opd_A ^ opd_B;
        end

        XNOR: begin
          Logic <= 1'b1;
          out <= ~(opd_A ^ opd_B);
        end

        A_eq_B: begin
          Cmp <= 1'b1;
          out <= opd_A == opd_B;
        end

        A_gr_B: begin
          Cmp <= 1'b1;
          out <= opd_A > opd_B;
        end

        A_ls_B: begin
          Cmp <= 1'b1;
          out <= opd_A < opd_B;
        end

        R_shift: begin
          Shift <= 1'b1;
          out <= opd_A >> 1;
        end

        L_shift: begin
          Shift <= 1'b1;
          out <= opd_A << 1;
        end

        default:begin
          out <= 16'b0;
        end
      endcase
    end

end

endmodule
