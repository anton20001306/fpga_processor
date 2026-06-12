## System Clock (100 MHz Onboard Oscillator)
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }];

## Slide Switches
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { mode }];  ;# SW0 (Rightmost switch)
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { reset }]; ;# SW1 (Second switch)

## LEDs
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { count[0] }]; ;# LD0
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { count[1] }]; ;# LD1
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { count[2] }]; ;# LD2

set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { mode_out }]; ;# LD15 (Leftmost LED)