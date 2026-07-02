//----------------------------------------------------------------------//
// File        : top.v
// Project     : FPGA_processor
// Author      : W.A.P.N Fernando
// Date        : 2026-07-02
// Description : Top level - captures operands/function and drives display
// -----------------------------------------------------------------------
// Revision History:
//   Rev  Date        Author        Description
//   0.1  2026-07-02  Name          Initial skeleton
//----------------------------------------------------------------------//

module TOP(
    // ---------------------------------------------------------------
    // Port Declarations
    // ---------------------------------------------------------------

    // Clock & Reset
    input  wire clk_i,
    input  wire rstn_i,

    // Push buttons
    input  wire btnc_i,
    input  wire btnu_i,
    input  wire btnd_i,

    // Data inputs
    input  wire [15:0] switch_i,

    // 7-segment display outputs
    output wire  [6:0] seven_segment_o,
    output wire decimal_point_o,
    output wire  [7:0] anode_o,

    // Status LEDs
    output wire  [4:0] led_o


  );

  // ---------------------------------------------------------------
  // Internal Signal Declarations
  // ---------------------------------------------------------------

  // Registers
  reg [15:0] A_reg;
  reg [15:0] B_reg;
  reg [3: 0] ALU_FUN_reg;
  reg        func_valid;   // 0 until an ALU_FUN is chosen with btnd

  // internal connections
  wire  carry;
  wire  arith;
  wire  Logic;
  wire  comapre;
  wire  shift;
  wire  [15:0]  alu_out;

  // Hold result and flags at zero until a function has been selected
  wire [15:0] alu_out_disp = func_valid ? alu_out : 16'b0;

  assign led_o = func_valid ? {shift, comapre, Logic, arith, carry} : 5'b0;

  // ---------------------------------------------------------------
  // Design Implementation
  // ---------------------------------------------------------------

  // Sequential Logic - capture operands and function on button press
  always @(posedge clk_i or negedge rstn_i)
  begin
    if(!rstn_i)
    begin
      A_reg <= 16'b0;
      B_reg <= 16'b0;
      ALU_FUN_reg <= 4'b0;
      func_valid <= 1'b0;
    end
    else if (btnc_i)
    begin
      A_reg <= switch_i;
    end
    else if (btnu_i)
    begin
      B_reg <= switch_i;
    end
    else if (btnd_i)
    begin
      ALU_FUN_reg <= switch_i[3:0];
      func_valid <= 1'b1;
    end

  end

  // ---------------------------------------------------------------
  // Module Instantiations
  // ---------------------------------------------------------------

ALU u_alu(
      .A(A_reg),
      .B(B_reg),
      .ALU_FUN(ALU_FUN_reg),
      .clk_i(clk_i),
      .rstn_i(rstn_i),
      .Carry_Flag(carry),
      .Arith_Flag(arith),
      .Logic_flag(Logic),
      .CMP_Flag(comapre),
      .Shift_Flag(shift),
      .ALU_OUT(alu_out)
    );

seven_seg_controller u_seg(

                       .clk_i(clk_i),
                       .rstn_i(rstn_i),
                       .opd_A(A_reg),
                       .opd_B(B_reg),
                       .out(alu_out_disp),
                       .seg(seven_segment_o),
                       .dp(decimal_point_o),
                       .an(anode_o)

                     );

endmodule


