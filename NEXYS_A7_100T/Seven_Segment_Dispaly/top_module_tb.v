//////////////////////////////////////////////////////////////////////////////////
// Engineer: W.A.P.N Fernando
// Module Name: top_module_tb.v
// Project Name: Seven_Segment_Display
// Target Devices: NEXYS A7 100T
// Tool: QuestaSim
// Description:
//   Testbench for top_module. Sweeps the 4-bit SWITCH input through all
//   16 values (0-15) and records the seven-segment cathode outputs
//   (CA-CG) plus the anode-enable bus (AN). The decoder is combinational,
//   so there is no clock; each input is held for 20 ns to give a clean,
//   readable waveform.
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module top_module_tb;

  // ---------------------------------------------------------------
  // DUT signals
  // ---------------------------------------------------------------
  reg  [3:0] SWITCH;          // stimulus
  wire       CA, CB, CC, CD, CE, CF, CG;
  wire [7:0] AN;

  integer i;

  // ---------------------------------------------------------------
  // Device Under Test
  // ---------------------------------------------------------------
  top_module dut (
    .SWITCH (SWITCH),
    .CA     (CA),
    .CB     (CB),
    .CC     (CC),
    .CD     (CD),
    .CE     (CE),
    .CF     (CF),
    .CG     (CG),
    .AN     (AN)
  );

  // grouped cathode bus for easy viewing in the wave window
  wire [6:0] CATHODES = {CA, CB, CC, CD, CE, CF, CG};

  // ---------------------------------------------------------------
  // Waveform dump (VCD) - for VCD-based viewers (GTKWave / iverilog).
  // QuestaSim's GUI uses its own WLF log (see wave.do "log -r /*"),
  // so this block is optional there, but harmless and portable.
  // ---------------------------------------------------------------
  initial begin
    $dumpfile("top_module_tb.vcd");
    $dumpvars(0, top_module_tb);   // 0 = dump this module and everything below
  end

  // ---------------------------------------------------------------
  // Stimulus
  // ---------------------------------------------------------------
  initial begin
    $display("------------------------------------------------------------");
    $display(" time |  SW  | CA CB CC CD CE CF CG | AN        | digit");
    $display("------------------------------------------------------------");

    for (i = 0; i < 16; i = i + 1) begin
      SWITCH = i[3:0];
      #20;
      $display(" %4t | %b | %b  %b  %b  %b  %b  %b  %b | %b |  %0d",
               $time, SWITCH, CA, CB, CC, CD, CE, CF, CG, AN, i);
    end

    $display("------------------------------------------------------------");
    $display("Simulation complete: swept all 16 SWITCH values.");
    #20 $finish;
  end

endmodule
