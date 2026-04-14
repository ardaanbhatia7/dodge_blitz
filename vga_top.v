`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module:  vga_top
// Project: FPGA Dodge Game — "Meteor Shower"
//
// Changes from original:
//   - Added BtnL, BtnR inputs for player movement
//   - Added lives_out → Ld2, Ld1, Ld0 (3 LEDs for lives)
//   - Wired new vga_bitchange ports (btnL, btnR, btnC, btnU, lives_out)
//
// Week 3 TODO: add ACL_MISO, ACL_MOSI, ACL_SCLK, ACL_CSN ports here
//              and instantiate accel_spi module
////////////////////////////////////////////////////////////////////////////////
module vga_top(
    input  ClkPort,
    input  BtnC,      // start / confirm
    input  BtnU,      // pause / resume
    input  BtnL,      // move player left   ← NEW
    input  BtnR,      // move player right  ← NEW

    // VGA signals
    output hSync, vSync,
    output [3:0] vgaR, vgaG, vgaB,

    // 7-segment display
    output An0, An1, An2, An3, An4, An5, An6, An7,
    output Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,

    // Lives LEDs  ← NEW (wire to Ld0, Ld1, Ld2 in XDC)
    output Ld0, Ld1, Ld2,

    output QuadSpiFlashCS
    );

    wire bright;
    wire [9:0] hc, vc;
    wire [15:0] score;
    wire [6:0]  ssdOut;
    wire [3:0]  anode;
    wire [11:0] rgb;
    wire [2:0]  lives_out;

    // VGA timing — unchanged
    display_controller dc(
        .clk(ClkPort),
        .hSync(hSync),
        .vSync(vSync),
        .bright(bright),
        .hCount(hc),
        .vCount(vc)
    );

    // Game logic + pixel painter
    vga_bitchange vbc(
        .clk(ClkPort),
        .bright(bright),
        .hCount(hc),
        .vCount(vc),
        .btnL(BtnL),        // ← NEW
        .btnR(BtnR),        // ← NEW
        .btnC(BtnC),
        .btnU(BtnU),
        .rgb(rgb),
        .score(score),
        .lives_out(lives_out)   // ← NEW
    );

    // 7-segment score display — unchanged
    counter cnt(
        .clk(ClkPort),
        .displayNumber(score),
        .anode(anode),
        .ssdOut(ssdOut)
    );

    // SSD wiring — unchanged
    assign Dp = 1;
    assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg} = ssdOut[6:0];
    assign {An7, An6, An5, An4, An3, An2, An1, An0} = {4'b1111, anode};

    // VGA color — unchanged
    assign vgaR = rgb[11:8];
    assign vgaG = rgb[7:4];
    assign vgaB = rgb[3:0];

    // Lives LEDs  ← NEW
    assign Ld0 = lives_out[0];
    assign Ld1 = lives_out[1];
    assign Ld2 = lives_out[2];

    // Disable flash memory — unchanged
    assign QuadSpiFlashCS = 1'b1;

endmodule