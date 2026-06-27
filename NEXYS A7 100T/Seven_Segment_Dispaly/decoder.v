//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: W.A.P.N Fernando
// 
// Create Date: 06/27/2026 05:10:48 PM
// Design Name: decoder
// Module Name: decoder.v
// Project Name: Seven_Segement_Display
// Target Devices: NEXYS A7 100T
// Tool Versions: Vivado Xilinx 2024.01
// Description: 
// 
// Description: 
//   Combinational BCD-to-seven-segment decoder. Maps a 4-bit input
//   (SWITCH, 0-9) to the active-low cathode signals (CA-CG) that
//   display the corresponding decimal digit. Inputs 10-15 show an
//   error pattern via the default case.

// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module decoder(

    // ---------------------------------------------------------------
    // Parameters
    // ---------------------------------------------------------------

    // Data inputs
    input  wire [3:0] SWITCH,

    // Data outputs
    output reg CA,
    output reg CB,
    output reg CC,
    output reg CD,
    output reg CE,
    output reg CF,
    output reg CG

  );


  // ---------------------------------------------------------------
  // Design Implementation
  // ---------------------------------------------------------------

  // Combinational logic
  always @(*)
  begin
    case(SWITCH)
      4'b0000:
        {CA, CB, CC, CD, CE, CF, CG} = 7'b0000001;
      4'b0001:
        {CA, CB, CC, CD, CE, CF, CG} = 7'b1001111;
      4'b0010:
        {CA, CB, CC, CD, CE, CF, CG} = 7'b0010010;
      4'b0011:
        {CA, CB, CC, CD, CE, CF, CG} = 7'b0000110;
      4'b0100:
        {CA, CB, CC, CD, CE, CF, CG} = 7'b1001100;
      4'b0101:
        {CA, CB, CC, CD, CE, CF, CG} = 7'b0100100;
      4'b0110:
        {CA, CB, CC, CD, CE, CF, CG} = 7'b0100000;
      4'b0111:
        {CA, CB, CC, CD, CE, CF, CG} = 7'b0001111;
      4'b1000:
        {CA, CB, CC, CD, CE, CF, CG} = 7'b0000000;
      4'b1001:
        {CA, CB, CC, CD, CE, CF, CG} = 7'b0000100;
      default:
        {CA, CB, CC, CD, CE, CF, CG} = 7'b0110000;
    endcase
  end
endmodule
