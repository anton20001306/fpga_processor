//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: W.A.P.N Fernando
// 
// Create Date: 06/27/2026 05:10:48 PM
// Design Name: top_module
// Module Name: top_module.v
// Project Name: Seven_Segment_Display
// Target Devices: NEXYS A7 100T
// Tool Versions: Vivado Xilinx 2024.01
// Description: 
//   Top-level wrapper for the seven-segment display demo on the NEXYS
//   A7 100T. Reads the 4-bit SWITCH input and instantiates the decoder
//   to drive the segment cathodes (CA-CG). Drives AN = 8'b11111110 to
//   enable only the rightmost (digit 0) display, since the anodes are
//   active-low.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module top_module(

    // ---------------------------------------------------------------
    // Port Declarations
    // ---------------------------------------------------------------

    // Data inputs
    input  wire [3:0] SWITCH,

    // Data outputs
    output wire CA,
    output wire CB,
    output wire CC,
    output wire CD,
    output wire CE,
    output wire CF,
    output wire CG,
    output wire [7:0] AN

  );

  // Output Assignments
  assign AN = 8'b11111110;
  decoder seven_segment(.SWITCH(SWITCH), .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG));

endmodule
