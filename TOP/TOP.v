module TOP(
    input  wire clk_i,
    input  wire rstn_i,
    input  wire btnc_i,
    input  wire btnu_i,
    input  wire btnd_i,
    input  wire [15:0] switch_i,

    output wire  [6:0] seven_segment_o,
    output wire decimal_point_o,
    output wire  [7:0] anode_o,
    output wire  [4:0] led_o


  );

  reg [15:0] A_reg;
  reg [15:0] B_reg;
  reg [3: 0] ALU_FUN_reg;

  // internal connections
  wire  carry;
  wire  arith;
  wire  Logic;
  wire  comapre;
  wire  shift;
  wire  [15:0]  alu_out;

  assign led_o = {shift, comapre, Logic, arith, carry};


  always @(posedge clk_i or negedge rstn_i)
  begin
    if(!rstn_i)
    begin
      A_reg <= 16'b0;
      B_reg <= 16'b0;
      ALU_FUN_reg <= 4'b0;
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
    end

  end


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
                       .out(alu_out),
                       .seg(seven_segment_o),
                       .dp(decimal_point_o),
                       .an(anode_o)

                     );

endmodule


