`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2026 11:10:54 AM
// Design Name: 
// Module Name: up_down_counter
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

// RTL code of up_down_counter using NEXYS A7 - 100T Development Board
// Consists of a crystal oscillator of 100MHz
// Hence clock division logic is separately added to ease visualization

module up_down_counter(
input wire clk,
input wire mode, // 0 - Up Counter |1 - Down Counter
input wire reset,
output reg[2:0]count, // 3 bit input counter
output wire mode_out
    );
    
    // Output mode
assign mode_out = mode;

// Clk division
reg[28:0] clk_div_counter;
wire div_clk = (clk_div_counter == 499999999); // Active for 1 clock cycle for every 1 second

// Clock division logic
always @(posedge clk or posedge reset) begin
  if(reset) clk_div_counter <= 29'b0;
  else if(div_clk) clk_div_counter <= 29'b0;
  else clk_div_counter <= clk_div_counter + 1'b1;
end

// Up Down counter logic
always @(posedge clk or posedge reset) begin
    if(reset) begin
      count <= 3'b000; // Reset count
    end

    else if(div_clk) begin
      // Up Counter logic
      if(mode == 1'b0) begin
        if(count == 3'b111) count <= 3'b000;
        else count <= count + 1'b1;
      end

      // Down counter logic
      else begin
        if(count == 3'b000) count <= 3'b111;
        else count <= count - 1'b1;
      end
    end

end
endmodule
