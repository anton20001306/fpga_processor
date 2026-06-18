module ALU(
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire [3:0] ALU_FUN,
    input  wire CLK,
    output reg  Carry_Flag,
    output wire Arith_Flag,
    output wire Logic_flag,
    output wire CMP_Flag,
    output wire Shift_Flag,
    output reg  [15:0] ALU_OUT
  );

  always @(*)
  begin
    case (ALU_FUN)

      4'b0000:
        {Carry_Flag,ALU_OUT} = A + B;
      4'b0001:
        {Carry_Flag,ALU_OUT} = A - B;
      4'b0010:
        ALU_OUT = A * B;
      4'b0011:
        ALU_OUT = A / B;
      4'b0100:
        ALU_OUT = A & B;
      4'b0101:
        ALU_OUT = A | B;
      4'b0110:
        ALU_OUT = ~(A & B);
      4'b0111:
        ALU_OUT = ~(A | B);
      4'b1000:
        ALU_OUT = A ^ B;
      4'b1001:
        ALU_OUT = (A ~^ B);
      4'b1010:
        if(A == B)
        begin
          ALU_OUT = 16'b1;
        end
        else
        begin
          ALU_OUT = 16'b0;
        end

      4'b1011:
        if(A > B) begin
            ALU_OUT = 16'b10;
        end
        else begin
            ALU_OUT = 16'b0;
        end

          default:
            {Carry_Flag,ALU_OUT} = 17'b0;

    endcase
  end

endmodule
