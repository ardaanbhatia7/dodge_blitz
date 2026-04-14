## Nexys A7-100T constraints for FPGA Dodge Game
## Changes from original vga_demo.xdc:
##   - Uncommented BtnL, BtnR
##   - Uncommented Ld0, Ld1, Ld2 for lives display
##   - Accelerometer pins left commented — uncomment in Week 3

## Clock
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports ClkPort];
create_clock -add -name ClkPort -period 10.00 [get_ports ClkPort];

## Buttons
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports {BtnC}];
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports {BtnU}];
set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports {BtnL}];
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports {BtnR}];
#set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports {BtnD}];

## LEDs — Ld0/Ld1/Ld2 for lives remaining
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports {Ld0}];
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports {Ld1}];
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports {Ld2}];
#set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports {Ld3}];
#set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports {Ld4}];
#set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {Ld5}];
#set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports {Ld6}];
#set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports {Ld7}];

## 7-segment display
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports {Ca}];
set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports {Cb}];
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports {Cc}];
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports {Cd}];
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports {Ce}];
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports {Cf}];
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports {Cg}];
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports Dp];
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports {An0}];
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports {An1}];
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports {An2}];
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports {An3}];
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports {An4}];
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports {An5}];
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports {An6}];
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports {An7}];

## VGA connector
set_property -dict { PACKAGE_PIN B4    IOSTANDARD LVCMOS33 } [get_ports { vgaR[1] }];
set_property -dict { PACKAGE_PIN A3    IOSTANDARD LVCMOS33 } [get_ports { vgaR[0] }];
set_property -dict { PACKAGE_PIN C5    IOSTANDARD LVCMOS33 } [get_ports { vgaR[2] }];
set_property -dict { PACKAGE_PIN A4    IOSTANDARD LVCMOS33 } [get_ports { vgaR[3] }];
set_property -dict { PACKAGE_PIN C6    IOSTANDARD LVCMOS33 } [get_ports { vgaG[0] }];
set_property -dict { PACKAGE_PIN A5    IOSTANDARD LVCMOS33 } [get_ports { vgaG[1] }];
set_property -dict { PACKAGE_PIN B6    IOSTANDARD LVCMOS33 } [get_ports { vgaG[2] }];
set_property -dict { PACKAGE_PIN A6    IOSTANDARD LVCMOS33 } [get_ports { vgaG[3] }];
set_property -dict { PACKAGE_PIN B7    IOSTANDARD LVCMOS33 } [get_ports { vgaB[0] }];
set_property -dict { PACKAGE_PIN C7    IOSTANDARD LVCMOS33 } [get_ports { vgaB[1] }];
set_property -dict { PACKAGE_PIN D7    IOSTANDARD LVCMOS33 } [get_ports { vgaB[2] }];
set_property -dict { PACKAGE_PIN D8    IOSTANDARD LVCMOS33 } [get_ports { vgaB[3] }];
set_property -dict { PACKAGE_PIN B11   IOSTANDARD LVCMOS33 } [get_ports { hSync }];
set_property -dict { PACKAGE_PIN B12   IOSTANDARD LVCMOS33 } [get_ports { vSync }];

## Accelerometer (ADXL362 SPI) — UNCOMMENT IN WEEK 3
#set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVCMOS33 } [get_ports { ACL_MISO }];
#set_property -dict { PACKAGE_PIN F14   IOSTANDARD LVCMOS33 } [get_ports { ACL_MOSI }];
#set_property -dict { PACKAGE_PIN F15   IOSTANDARD LVCMOS33 } [get_ports { ACL_SCLK }];
#set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVCMOS33 } [get_ports { ACL_CSN }];

## Quad SPI Flash (must be driven to disable)
set_property -dict { PACKAGE_PIN L13   IOSTANDARD LVCMOS33 } [get_ports {QuadSpiFlashCS}];
