module ALU(
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire [3:0] ALU_FUN,
    input  wire CLK,
    output reg  Carry_Flag,
    output reg  Arith_Flag,
    output reg  Logic_flag,
    output reg  CMP_Flag,
    output reg  Shift_Flag,
    output reg  [15:0] ALU_OUT
  );

  reg [15:0] ALU_OUT_reg;

  always @(posedge CLK)
  begin
    ALU_OUT <= ALU_OUT_reg;
  end

  always @(*)
  begin
    ALU_OUT_reg = 16'b0;  // avoid unintentinal latch
    Carry_Flag = 1'b0;
    Arith_Flag = 1'b0;
    Logic_flag = 1'b0;
    CMP_Flag = 1'b0;
    Shift_Flag = 1'b0;
    case (ALU_FUN)

      4'b0000:
        {Carry_Flag,ALU_OUT_reg} = A + B;
      4'b0001:
        {Carry_Flag,ALU_OUT_reg} = A - B;
      4'b0010:
        ALU_OUT_reg = A * B;
      4'b0011:
        ALU_OUT_reg = A / B;
      4'b0100:
        ALU_OUT_reg = A & B;
      4'b0101:
        ALU_OUT_reg = A | B;
      4'b0110:
        ALU_OUT_reg = ~(A & B);
      4'b0111:
        ALU_OUT_reg = ~(A | B);
      4'b1000:
        ALU_OUT_reg = A ^ B;
      4'b1001:
        ALU_OUT_reg = (A ~^ B);
      4'b1010:
        if(A == B)
        begin
          ALU_OUT_reg = 16'b1;
        end
        else
        begin
          ALU_OUT_reg = 16'b0;
        end
      4'b1011:
        if(A > B)
        begin
          ALU_OUT_reg = 16'b10;
        end
        else
        begin
          ALU_OUT_reg = 16'b0;
        end
      4'b1100:
        if(A<B)
        begin
          ALU_OUT_reg = 16'b11;
        end
        else
        begin
          ALU_OUT_reg = 16'b0;
        end
      4'b1101:
        ALU_OUT_reg = A >>1;
      4'b1110:
        ALU_OUT_reg = A << 1;

      default:
      begin
        ALU_OUT_reg = 16'b0;
        Carry_Flag = 1'b0;
        Arith_Flag = 1'b0;
        Logic_flag = 1'b0;
        CMP_Flag = 1'b0;
        Shift_Flag = 1'b0;
      end


    endcase

    Arith_Flag = (ALU_FUN <= 4'b0011) ? 1 : 0;
    Logic_flag = ((4'b0100 <= ALU_FUN) && (ALU_FUN <= 4'b1001)) ? 1 : 0;
    CMP_Flag  = ((4'b1010 <= ALU_FUN) && (ALU_FUN <= 4'b1100)) ? 1 : 0;
    Shift_Flag = ((4'b1101 <= ALU_FUN) && (ALU_FUN <= 4'b1110)) ? 1 : 0;


  end

endmodule
