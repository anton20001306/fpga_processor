// 16bit ALU Operations
// Responsible for carrying out the unsigned arithmetic, logic functions,
// shift functions and comparion functions.

// A,B -> Operands (16 bit)
// ALU_OUT -> Result (16 bit)

module ALU_16bit(
    input wire reset, // Used to reset operands
    input wire clk, // Setting clk
    input wire[15:0] sw, // Physical slide switches | Use to set operand values
    input wire BTNC, // Sets for Operand A
    input wire BTNU, // Sets for Operand B
    output reg[15:0] out,
    output reg Carry_flag, // Carry flag set
    output reg Arith, Logic, Cmp, Shift // Used to represent the type of operations | Setting flags

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

reg [15:0] opd_A = 16'b0; // Operand A
reg [15:0] opd_B = 16'b0; // Operand B
reg [3:0] op_code = 4'b0; // 4 bit opcode with 15 operations (ALU_FUN)


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
      out <= 16'b0;
    end

    else begin
      Arith <= 1'b0;
      Logic <= 1'b0;
      Cmp <= 1'b0;
      Shift <= 1'b0;
      Carry_flag <= 1'b0;

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
          Arith <= 1'b1;
          out <= opd_A / opd_B;
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