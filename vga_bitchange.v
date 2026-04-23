`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// vga_bitchange v5 — Meteor Shower dodge game
//
// Written to exactly mirror the style of the original vga_bitchange.v:
//  - blocking assignments (=) for all game registers, just like the original
//  - hCount/vCount used directly, not px/py offsets
//  - initial block for starting values (same as original)
//  - score uses blocking assignment (same as original)
//  - button input used directly (same pattern as original)
//
// Controls:
//   BtnC = reset/restart
//   BtnL = move left (hold)
//   BtnR = move right (hold)
//   BtnU = pause/unpause
////////////////////////////////////////////////////////////////////////////////
module vga_bitchange(
    input             clk,
    input             bright,
    input  [9:0]      hCount,
    input  [9:0]      vCount,
    input             btnL,
    input             btnR,
    input             btnC,
    input             btnU,
    output reg [11:0] rgb,
    output reg [15:0] score,
    output reg [2:0]  lives_out
);

    // =========================================================================
    // Colors
    // =========================================================================
    parameter BLACK  = 12'h000;
    parameter BGCOL  = 12'h001;   // dark blue background
    parameter BGMID  = 12'h002;   // slightly lighter mid-screen
    parameter PLCOL  = 12'h4CF;   // cyan player
    parameter MTCOL  = 12'hA42;   // orange-brown meteor
    parameter MTHI   = 12'hD75;   // meteor highlight
    parameter HUDCOL = 12'h112;   // HUD bar
    parameter LVCOL  = 12'hF22;   // red lives

    // =========================================================================
    // Screen bounds (in hCount/vCount space, matching display_controller)
    //   Visible: hCount 144..783, vCount 35..514
    // =========================================================================
    // Player (fixed Y row in hCount/vCount space)
    parameter PL_W   = 10'd30;
    parameter PL_H   = 10'd18;
    parameter PL_HCY = 10'd475;   // top of player in vCount space (vCount 475..492)
    parameter PL_MAX = 10'd754;   // rightmost left-edge: 784 - 30

    // HUD: top 30 visible rows = vCount 35..64
    parameter HUD_BOT = 10'd65;   // vCount of HUD bottom edge

    // Ground: vCount ~505
    parameter GND_Y  = 10'd505;

    // Meteor size
    parameter MT_W   = 10'd24;
    parameter MT_H   = 10'd20;

    // =========================================================================
    // Game registers — use blocking assignments like original
    // =========================================================================
    reg [9:0]  plHC;          // player left edge in hCount space (144..754)

    reg [9:0]  mt_hc [0:3];   // meteor left edge in hCount space
    reg [9:0]  mt_vc [0:3];   // meteor top edge in vCount space
    reg        mt_on [0:3];

    reg [49:0] fall_spd;      // fall speed counter (like greenMiddleSquareSpeed)
    reg [49:0] spawn_spd;     // spawn counter
    reg [31:0] move_spd;      // player move counter
    reg [49:0] fall_period;   // current fall period (shrinks over time)
    reg [49:0] spawn_period;

    reg        paused;

    // Button edge detection
    reg btnC_prev, btnU_prev;

    // LFSR for random spawn X
    reg [15:0] lfsr;

    // =========================================================================
    // Initial values — same pattern as original
    // =========================================================================
    integer k;
    initial begin
        plHC         = 10'd454;    // centre: 144 + (640-30)/2 = 144+305 = 449
        score        = 16'd0;
        lives_out    = 3'd3;
        paused       = 1'b0;
        fall_period  = 50'd1_500_000;
        spawn_period = 50'd80_000_000;
        fall_spd     = 50'd0;
        spawn_spd    = 50'd0;
        move_spd     = 32'd0;
        lfsr         = 16'hACE1;
        btnC_prev    = 1'b0;
        btnU_prev    = 1'b0;
        for (k=0; k<4; k=k+1) begin
            mt_on[k] = 1'b0;
            mt_hc[k] = 10'd144;
            mt_vc[k] = 10'd35;
        end
    end

    // =========================================================================
    // Game logic — blocking assignments, one always block, like original
    // =========================================================================
    integer i;
    always @(posedge clk) begin

        // LFSR tick
        lfsr = {lfsr[14:0], lfsr[15]^lfsr[13]^lfsr[12]^lfsr[10]};
        if (lfsr == 16'd0) lfsr = 16'hACE1;

        // Button edges
        btnC_prev = btnC_prev; // hold
        btnU_prev = btnU_prev;

        // === RESET on BtnC ===
        if (btnC == 1'b1 && btnC_prev == 1'b0) begin
            plHC         = 10'd449;
            score        = 16'd0;
            lives_out    = 3'd3;
            paused       = 1'b0;
            fall_period  = 50'd1_500_000;
            spawn_period = 50'd80_000_000;
            fall_spd     = 50'd0;
            spawn_spd    = 50'd0;
            move_spd     = 32'd0;
            for (i=0; i<4; i=i+1) begin
                mt_on[i] = 1'b0;
            end
        end

        // === PAUSE toggle on BtnU ===
        if (btnU == 1'b1 && btnU_prev == 1'b0)
            paused = ~paused;

        btnC_prev = btnC;
        btnU_prev = btnU;

        if (!paused && lives_out > 0) begin

            // === Player movement ===
            move_spd = move_spd + 32'd1;
            if (move_spd >= 32'd200_000) begin
                move_spd = 32'd0;
                if (btnL == 1'b1 && plHC > 10'd148)
                    plHC = plHC - 10'd5;
                if (btnR == 1'b1 && plHC < PL_MAX)
                    plHC = plHC + 10'd5;
            end

            // === Meteor fall ===
            fall_spd = fall_spd + 50'd1;
            if (fall_spd >= fall_period) begin
                fall_spd = 50'd0;
                for (i=0; i<4; i=i+1) begin
                    if (mt_on[i] == 1'b1) begin
                        if (mt_vc[i] >= 10'd494) begin
                            // Exited bottom of screen
                            mt_on[i] = 1'b0;
                            score    = score + 16'd1;
                        end else begin
                            mt_vc[i] = mt_vc[i] + 10'd2;
                        end
                    end
                end
            end

            // === Spawn ===
            spawn_spd = spawn_spd + 50'd1;
            if (spawn_spd >= spawn_period) begin
                spawn_spd = 50'd0;
                // Random hCount X: 144 + (lfsr[9:0] % 616)
                // Simplified: use lfsr[9:0], cap at 616, add 144
                if (!mt_on[0]) begin
                    mt_on[0] = 1'b1;
                    mt_vc[0] = 10'd36;
                    mt_hc[0] = 10'd144 + (lfsr[9:0] > 10'd615 ? lfsr[9:0] - 10'd615 : lfsr[9:0]);
                end else if (!mt_on[1]) begin
                    mt_on[1] = 1'b1;
                    mt_vc[1] = 10'd36;
                    mt_hc[1] = 10'd144 + (lfsr[8:0] > 9'd615 ? lfsr[8:0] - 9'd615 : {1'b0,lfsr[8:0]});
                end else if (!mt_on[2]) begin
                    mt_on[2] = 1'b1;
                    mt_vc[2] = 10'd36;
                    mt_hc[2] = 10'd144 + ({lfsr[7:0],1'b0} > 10'd615 ? {lfsr[7:0],1'b0}-10'd615 : {lfsr[7:0],1'b0});
                end else if (!mt_on[3]) begin
                    mt_on[3] = 1'b1;
                    mt_vc[3] = 10'd36;
                    mt_hc[3] = 10'd144 + (lfsr[9:0] > 10'd615 ? 10'd300 : lfsr[9:0]);
                end
            end

            // === Collision — check each meteor vs player ===
            for (i=0; i<4; i=i+1) begin
                if (mt_on[i] == 1'b1 &&
                    plHC          < mt_hc[i] + MT_W &&
                    plHC + PL_W   > mt_hc[i]        &&
                    PL_HCY        < mt_vc[i] + MT_H  &&
                    PL_HCY + PL_H > mt_vc[i])
                begin
                    mt_on[i] = 1'b0;
                    if (lives_out > 3'd0)
                        lives_out = lives_out - 3'd1;
                end
            end

            // === Speed up every 5 dodges ===
            if (score != 0 && score[2:0] == 3'd0) begin
                if (fall_period > 50'd500_000)
                    fall_period = fall_period - 50'd50_000;
                if (spawn_period > 50'd20_000_000)
                    spawn_period = spawn_period - 50'd5_000_000;
            end

        end // !paused
    end

    // =========================================================================
    // Pixel membership — combinational, in hCount/vCount space directly
    // =========================================================================

    // Player rectangle
    wire inPl = (hCount >= plHC) && (hCount < plHC + PL_W) &&
                (vCount >= PL_HCY) && (vCount < PL_HCY + PL_H);

    // Player cockpit (inner window)
    wire inCk = (hCount >= plHC + 10'd9)  && (hCount < plHC + 10'd21) &&
                (vCount >= PL_HCY + 10'd3) && (vCount < PL_HCY + 10'd11);

    // Engine glow
    wire inEg = (hCount >= plHC + 10'd7)  && (hCount < plHC + PL_W - 10'd7) &&
                (vCount >= PL_HCY + PL_H - 10'd5) && (vCount < PL_HCY + PL_H);

    // Meteors
    wire inM0 = mt_on[0] && (hCount>=mt_hc[0]) && (hCount<mt_hc[0]+MT_W) && (vCount>=mt_vc[0]) && (vCount<mt_vc[0]+MT_H);
    wire inM1 = mt_on[1] && (hCount>=mt_hc[1]) && (hCount<mt_hc[1]+MT_W) && (vCount>=mt_vc[1]) && (vCount<mt_vc[1]+MT_H);
    wire inM2 = mt_on[2] && (hCount>=mt_hc[2]) && (hCount<mt_hc[2]+MT_W) && (vCount>=mt_vc[2]) && (vCount<mt_vc[2]+MT_H);
    wire inM3 = mt_on[3] && (hCount>=mt_hc[3]) && (hCount<mt_hc[3]+MT_W) && (vCount>=mt_vc[3]) && (vCount<mt_vc[3]+MT_H);
    wire inMt = inM0|inM1|inM2|inM3;

    wire mtHi_w = (inM0 && hCount<mt_hc[0]+10'd8 && vCount<mt_vc[0]+10'd6) |
                  (inM1 && hCount<mt_hc[1]+10'd8 && vCount<mt_vc[1]+10'd6) |
                  (inM2 && hCount<mt_hc[2]+10'd8 && vCount<mt_vc[2]+10'd6) |
                  (inM3 && hCount<mt_hc[3]+10'd8 && vCount<mt_vc[3]+10'd6);

    // HUD strip (vCount 35..64)
    wire inHUD = (vCount >= 10'd35) && (vCount < HUD_BOT);
    wire inDiv = (vCount == HUD_BOT);

    // Lives blocks (inside HUD, right side, in hCount space)
    wire inL0 = inHUD && (hCount>=10'd674) && (hCount<10'd692) && (vCount>=10'd43) && (vCount<=10'd57);
    wire inL1 = inHUD && (hCount>=10'd697) && (hCount<10'd715) && (vCount>=10'd43) && (vCount<=10'd57);
    wire inL2 = inHUD && (hCount>=10'd720) && (hCount<10'd738) && (vCount>=10'd43) && (vCount<=10'd57);

    // Ground line
    wire inGnd = (vCount >= GND_Y) && (vCount < GND_Y + 10'd2);

    // Background gradient
    wire [11:0] bg = (vCount < 10'd200) ? 12'h001 :
                     (vCount < 10'd370) ? 12'h002 :
                                          12'h013;

    // =========================================================================
    // Pixel painter — combinational, same pattern as original
    // =========================================================================
    always @(*) begin
        if (~bright)
            rgb = BLACK;
        else if (inDiv)
            rgb = 12'h445;
        else if (inHUD) begin
            rgb = HUDCOL;
            if      (inL2 && lives_out == 3'd3) rgb = LVCOL;
            else if (inL1 && lives_out >= 3'd2) rgb = LVCOL;
            else if (inL0 && lives_out >= 3'd1) rgb = LVCOL;
        end else if (inGnd)
            rgb = 12'h334;
        else if (inPl) begin
            if      (inCk) rgb = 12'hBDF;
            else if (inEg) rgb = 12'hF92;
            else           rgb = PLCOL;
        end else if (inMt)
            rgb = mtHi_w ? MTHI : MTCOL;
        else if (lives_out == 0) begin
            // Game over — red tint entire background
            if (vCount>=10'd215 && vCount<10'd290 && hCount>=10'd284 && hCount<10'd644)
                rgb = 12'hF11;
            else if (vCount>=10'd320 && vCount<10'd345 && hCount>=10'd310 && hCount<10'd620)
                rgb = 12'hFF8;
            else
                rgb = 12'h100;
        end else if (paused) begin
            if (vCount>=10'd245 && vCount<10'd285 && hCount>=10'd310 && hCount<10'd614)
                rgb = 12'h44B;
            else
                rgb = 12'h001;
        end else
            rgb = bg;
    end

endmodule
