`timescale 1ps/1ps

module seven_seg_controller(
    input wire clk,
    input wire reset,
    input wire[15:0] opd_A,
    input wire[15:0] opd_B,
    input wire[15:0] out,
    output reg[6:0] seg, // 7 segments, of the 7segment display
    output wire dp, // For decimal points
    output reg[7:0] an // Anode | Power switch to activate each display block. Board consists of 8 blocks, hence 8 bits used
);

assign dp = 1'b1; // Turn off decimal points (Active Low)

reg[19:0] refresh_counter; // Clock divider, high refresh rate

// Clock adjustment with reset
always @(posedge clk or posedge reset) begin
    if(reset) begin
      refresh_counter <= 20'b0;
    end
    else begin
      refresh_counter <= refresh_counter + 1;
    end
end

wire[2:0] led_activating_counter = refresh_counter[19:17]; // Acts as a counter for multiplexing
reg[3:0] current_hex_digit; // Represent a digit 0-9 for a block

// Mux selecting illuminating digit
always @(*) begin
    case (led_activating_counter)
        // Left most 2 digits (Operand A)
        3'b111: begin an = 8'b01111111; current_hex_digit = opd_A[7:4]; end
        3'b110: begin an = 8'b10111111; current_hex_digit = opd_A[3:0]; end

        // Middle 2 digits (Operand B)
        3'b101: begin an = 8'b11011111; current_hex_digit = opd_B[7:4]; end
        3'b100: begin an = 8'b11101111; current_hex_digit = opd_B[3:0]; end

        // Right most 4 digits (ALU Outputs)
        3'b011: begin an = 8'b11110111; current_hex_digit = out[15:12]; end 
        3'b010: begin an = 8'b11111011; current_hex_digit = out[11:8]; end 
        3'b001: begin an = 8'b11111101; current_hex_digit = out[7:4]; end 
        3'b000: begin an = 8'b11111110; current_hex_digit = out[3:0]; end

        default: begin an = 8'b11111111; current_hex_digit = 4'b0; end
    endcase
end

// Hexadecimal to 7Segment Decoder (Active Low)
always @(*) begin
   case(current_hex_digit)
        4'h0: seg = 7'b1000000; 
        4'h1: seg = 7'b1111001; 
        4'h2: seg = 7'b0100100; 
        4'h3: seg = 7'b0110000; 
        4'h4: seg = 7'b0011001; 
        4'h5: seg = 7'b0010010; 
        4'h6: seg = 7'b0000010; 
        4'h7: seg = 7'b1111000; 
        4'h8: seg = 7'b0000000; 
        4'h9: seg = 7'b0010000; 
        4'hA: seg = 7'b0001000; 
        4'hB: seg = 7'b0000011; 
        4'hC: seg = 7'b1000110; 
        4'hD: seg = 7'b0100001; 
        4'hE: seg = 7'b0000110; 
        4'hF: seg = 7'b0001110; 
        default: seg = 7'b1111111; // Turn all off
    endcase 
end

endmodule