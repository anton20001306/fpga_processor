module ALU(
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire [3:0] ALU_FUN,
    input  wire clk_i,
    input  wire rstn_i,

    output reg  Carry_Flag,
    output reg  Arith_Flag,
    output reg  Logic_flag,
    output reg  CMP_Flag,
    output reg  Shift_Flag,
    output reg  [15:0] ALU_OUT
  );


  reg Carry_Flag_c;
  reg Arith_Flag_c;
  reg Logic_flag_c;
  reg CMP_Flag_c;
  reg Shift_Flag_c;
  reg [15:0] ALU_OUT_c;

  always @(posedge clk_i or negedge rstn_i)
  begin
    if (!rstn_i)
    begin
      ALU_OUT_c <= 16'b0;
      Carry_Flag_c <= 1'b0;
      Arith_Flag_c <= 1'b0;
      Logic_flag_c <= 1'b0;
      CMP_Flag_c <= 1'b0;
      Shift_Flag_c <=1'b0;
    end
    else
    begin
      ALU_OUT <= ALU_OUT_c;
      Carry_Flag <= Carry_Flag_c;
      Arith_Flag <= Arith_Flag;
      Logic_flag <= Logic_flag_c;
      CMP_Flag <= CMP_Flag_c;
      Shift_Flag <= Shift_Flag_c;
    end

  end

  always @(*)
  begin
    ALU_OUT_c = 16'b0;  // avoid unintentinal latch
    Carry_Flag_c = 1'b0;
    Arith_Flag_c = 1'b0;
    Logic_flag = 1'b0;
    CMP_Flag = 1'b0;
    Shift_Flag = 1'b0;
    case (ALU_FUN)

      4'b0000:
        {Carry_Flag_c,ALU_OUT_c} = A + B;
      4'b0001:
        {Carry_Flag_c,ALU_OUT_c} = A - B;
      4'b0010:
        ALU_OUT_c = A * B;
      4'b0011:
        ALU_OUT_c = A / B;
      4'b0100:
        ALU_OUT_c = A & B;
      4'b0101:
        ALU_OUT_c = A | B;
      4'b0110:
        ALU_OUT_c = ~(A & B);
      4'b0111:
        ALU_OUT_c = ~(A | B);
      4'b1000:
        ALU_OUT_c = A ^ B;
      4'b1001:
        ALU_OUT_c = (A ~^ B);
      4'b1010:
        if(A == B)
        begin
          ALU_OUT_c = 16'b1;
        end
        else
        begin
          ALU_OUT_c = 16'b0;
        end
      4'b1011:
        if(A > B)
        begin
          ALU_OUT_c = 16'b10;
        end
        else
        begin
          ALU_OUT_c = 16'b0;
        end
      4'b1100:
        if(A<B)
        begin
          ALU_OUT_c = 16'b11;
        end
        else
        begin
          ALU_OUT_c = 16'b0;
        end
      4'b1101:
        ALU_OUT_c = A >>1;
      4'b1110:
        ALU_OUT_c = A << 1;

      default:
      begin
        ALU_OUT_c = 16'b0;
        Carry_Flag_c = 1'b0;
        Arith_Flag_c = 1'b0;
        Logic_flag_c = 1'b0;
        CMP_Flag_c = 1'b0;
        Shift_Flag_c = 1'b0;
      end


    endcase

    Arith_Flag_c = (ALU_FUN <= 4'b0011) ? 1 : 0;
    Logic_flag_c = ((4'b0100 <= ALU_FUN) && (ALU_FUN <= 4'b1001)) ? 1 : 0;
    CMP_Flag_c  = ((4'b1010 <= ALU_FUN) && (ALU_FUN <= 4'b1100)) ? 1 : 0;
    Shift_Flag_c = ((4'b1101 <= ALU_FUN) && (ALU_FUN <= 4'b1110)) ? 1 : 0;


  end

endmodule
