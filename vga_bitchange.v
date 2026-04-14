`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module:  vga_bitchange
// Project: FPGA Dodge Game — "Meteor Shower"
//
// Replaces the original timing-game demo with a dodge game.
// The player is a rectangle near the bottom of the screen.
// Meteors fall from the top at increasing speed.
//
// Screen coordinate reference (VGA 640x480 @ 60Hz):
//   Visible area : hCount 144..783  (640px wide)
//                  vCount  35..514  (480px tall)
//   Origin (0,0) is top-left of the VISIBLE area, so:
//       pixel_x = hCount - 144
//       pixel_y = vCount - 35
//
// Inputs
//   clk        : 100 MHz board clock
//   bright     : 1 when beam is in visible area (from display_controller)
//   hCount     : horizontal beam counter (0..799)
//   vCount     : vertical   beam counter (0..524)
//   btnL       : move player left  (active high, already debounced or raw)
//   btnR       : move player right (active high)
//   btnC       : start game / confirm on title screen
//   btnU       : pause / resume
//
// Outputs
//   rgb        : 12-bit color {R[3:0], G[3:0], B[3:0]}
//   score      : 16-bit score sent to the 7-segment display driver
//   lives_out  : 3-bit lives remaining — wire this to 3 LEDs in vga_top
////////////////////////////////////////////////////////////////////////////////
module vga_bitchange(
    input  clk,
    input  bright,
    input  [9:0] hCount,
    input  [9:0] vCount,
    input  btnL,
    input  btnR,
    input  btnC,
    input  btnU,
    output reg [11:0] rgb,
    output reg [15:0] score,
    output [2:0] lives_out
    );

    // -------------------------------------------------------------------------
    // Color palette
    // -------------------------------------------------------------------------
    localparam BLACK      = 12'h000;
    localparam WHITE      = 12'hFFF;
    localparam DARK_SPACE = 12'h001;   // near-black blue — space background
    localparam PLAYER_COL = 12'h4AF;   // cyan-ish spaceship
    localparam METEOR_COL = 12'hA52;   // dark orange-brown meteor
    localparam METEOR_HI  = 12'hD74;   // lighter highlight on meteor
    localparam HUD_BG     = 12'h112;   // very dark blue HUD bar
    localparam SCORE_COL  = 12'hFF8;   // gold text color (used as box tint)
    localparam GAMEOVER_C = 12'hF22;   // red game-over tint
    localparam LIVES_COL  = 12'hF44;   // red lives indicator blocks

    // -------------------------------------------------------------------------
    // Screen layout constants (all in VISIBLE pixel coords, 0-based)
    // Visible: x = hCount-144 (0..639), y = vCount-35 (0..479)
    // -------------------------------------------------------------------------
    localparam SCREEN_W   = 640;
    localparam SCREEN_H   = 480;

    // HUD strip at the top
    localparam HUD_H      = 28;        // top 28 rows reserved for HUD

    // Player geometry
    localparam PLAYER_W   = 30;        // player width  (pixels)
    localparam PLAYER_H   = 20;        // player height (pixels)
    localparam PLAYER_Y   = 440;       // player top-edge Y (near bottom)
    localparam PLAYER_MIN = 0;         // leftmost playerX allowed
    localparam PLAYER_MAX = SCREEN_W - PLAYER_W; // rightmost playerX

    // Meteor geometry
    localparam MTR_W      = 24;        // meteor width
    localparam MTR_H      = 20;        // meteor height
    localparam NUM_MTRS   = 4;         // number of simultaneous meteors

    // Ground line (purely visual)
    localparam GROUND_Y   = 462;

    // -------------------------------------------------------------------------
    // Game FSM states
    // -------------------------------------------------------------------------
    localparam S_IDLE     = 2'd0;   // title / waiting
    localparam S_PLAY     = 2'd1;   // active gameplay
    localparam S_PAUSE    = 2'd2;   // paused
    localparam S_GAMEOVER = 2'd3;   // game over screen

    reg [1:0] state;

    // -------------------------------------------------------------------------
    // Pixel coordinates (combinational, updated every pixel)
    // -------------------------------------------------------------------------
    wire [9:0] px = hCount - 10'd144;   // 0..639 when in visible area
    wire [9:0] py = vCount - 10'd35;    // 0..479 when in visible area

    // -------------------------------------------------------------------------
    // Player state
    // -------------------------------------------------------------------------
    reg [9:0] playerX;     // left edge of player in visible coords

    // -------------------------------------------------------------------------
    // Meteor state — arrays of X, Y, active flag
    // -------------------------------------------------------------------------
    reg [9:0] meteorX [0:NUM_MTRS-1];
    reg [9:0] meteorY [0:NUM_MTRS-1];
    reg       meteorActive [0:NUM_MTRS-1];

    // -------------------------------------------------------------------------
    // Lives and score
    // -------------------------------------------------------------------------
    reg [2:0] lives;          // 3 lives max
    assign lives_out = lives;

    // -------------------------------------------------------------------------
    // Speed / difficulty counter
    // Speed thresholds: every SPEED_STEP score points, subtract SPEED_DEC
    // from the move-interval so meteors fall faster.
    // -------------------------------------------------------------------------
    // Meteor fall speed: one pixel per FALL_INTERVAL clk cycles
    // At 100MHz, 1 000 000 cycles ≈ 10ms per row → ~5 seconds to cross screen
    // Increase score → reduce interval → faster meteors
    localparam FALL_BASE  = 32'd800_000;   // starting interval (slow)
    localparam FALL_MIN   = 32'd150_000;   // minimum interval (fast)
    localparam SPEED_STEP = 16'd10;        // score increment between speedups
    localparam SPEED_DEC  = 32'd50_000;    // how much to reduce interval each step

    reg [31:0] fallInterval;   // current interval between meteor moves
    reg [31:0] fallCounter;    // counts up to fallInterval

    // Spawn interval: how often a new meteor is sent
    localparam SPAWN_BASE = 32'd6_000_000;
    localparam SPAWN_MIN  = 32'd1_500_000;
    reg [31:0] spawnInterval;
    reg [31:0] spawnCounter;

    // Player move rate limiter (one step per MOVE_INTERVAL cycles)
    localparam MOVE_INTERVAL = 32'd300_000;
    reg [31:0] moveCounter;

    // -------------------------------------------------------------------------
    // Pseudo-random spawn X — simple LFSR (15-bit)
    // -------------------------------------------------------------------------
    reg [14:0] lfsr;

    // -------------------------------------------------------------------------
    // Button edge detection (detect rising edge to avoid holding)
    // -------------------------------------------------------------------------
    reg btnC_prev, btnU_prev;
    wire btnC_rise = btnC & ~btnC_prev;
    wire btnU_rise = btnU & ~btnU_prev;

    // -------------------------------------------------------------------------
    // Star field — fixed positions baked in (decorative background)
    // We use a simple function: star at pixel if ((px*31 + py*17) % 97 == 0)
    // This is evaluated combinationally in the pixel painter.
    // -------------------------------------------------------------------------
    wire isStar = ( ( (px[4:0] ^ py[5:1]) == 5'b10110 ) ||
                    ( (px[6:1] ^ py[3:0]) == 6'b001101 ) ||
                    ( (px[3:0] ^ py[6:2]) == 4'b1010  ) );

    // -------------------------------------------------------------------------
    // Pixel membership wires (combinational)
    // -------------------------------------------------------------------------
    wire inHUD      = (py < HUD_H);
    wire inGround   = (py == GROUND_Y || py == GROUND_Y+1);

    // Player bounding box
    wire inPlayer   = (px >= playerX) && (px < playerX + PLAYER_W) &&
                      (py >= PLAYER_Y) && (py < PLAYER_Y + PLAYER_H);
    // Player cockpit window (small rectangle inside player)
    wire inCockpit  = (px >= playerX + PLAYER_W/2 - 4) &&
                      (px <  playerX + PLAYER_W/2 + 4) &&
                      (py >= PLAYER_Y + 4) &&
                      (py <  PLAYER_Y + 12);
    // Player thruster glow (bottom strip)
    wire inThruster = (px >= playerX + 8) && (px < playerX + PLAYER_W - 8) &&
                      (py >= PLAYER_Y + PLAYER_H - 4) &&
                      (py < PLAYER_Y + PLAYER_H);

    // Meteor bounding boxes (unrolled for synthesis — no dynamic indexing in wire)
    wire inMeteor0 = meteorActive[0] &&
                     (px >= meteorX[0]) && (px < meteorX[0] + MTR_W) &&
                     (py >= meteorY[0]) && (py < meteorY[0] + MTR_H);
    wire inMeteor1 = meteorActive[1] &&
                     (px >= meteorX[1]) && (px < meteorX[1] + MTR_W) &&
                     (py >= meteorY[1]) && (py < meteorY[1] + MTR_H);
    wire inMeteor2 = meteorActive[2] &&
                     (px >= meteorX[2]) && (px < meteorX[2] + MTR_W) &&
                     (py >= meteorY[2]) && (py < meteorY[2] + MTR_H);
    wire inMeteor3 = meteorActive[3] &&
                     (px >= meteorX[3]) && (px < meteorX[3] + MTR_W) &&
                     (py >= meteorY[3]) && (py < meteorY[3] + MTR_H);
    wire inAnyMeteor = inMeteor0 | inMeteor1 | inMeteor2 | inMeteor3;

    // Meteor highlight (top-left corner of each meteor — lighter pixel)
    wire inMHi0 = inMeteor0 && (px < meteorX[0] + 8) && (py < meteorY[0] + 6);
    wire inMHi1 = inMeteor1 && (px < meteorX[1] + 8) && (py < meteorY[1] + 6);
    wire inMHi2 = inMeteor2 && (px < meteorX[2] + 8) && (py < meteorY[2] + 6);
    wire inMHi3 = inMeteor3 && (px < meteorX[3] + 8) && (py < meteorY[3] + 6);
    wire inMeteorHi = inMHi0 | inMHi1 | inMHi2 | inMHi3;

    // Lives display in HUD: three small red blocks on the right side
    wire inLife0 = (px >= 10'd530) && (px < 10'd550) && (py >= 10'd7) && (py < 10'd21);
    wire inLife1 = (px >= 10'd555) && (px < 10'd575) && (py >= 10'd7) && (py < 10'd21);
    wire inLife2 = (px >= 10'd580) && (px < 10'd600) && (py >= 10'd7) && (py < 10'd21);

    // -------------------------------------------------------------------------
    // Collision detection (sampled once per frame at vCount==0, hCount==0)
    // Check player bounding box vs each meteor bounding box
    // -------------------------------------------------------------------------
    wire hitMeteor0 = meteorActive[0] &&
        (playerX < meteorX[0] + MTR_W) && (playerX + PLAYER_W > meteorX[0]) &&
        (PLAYER_Y < meteorY[0] + MTR_H) && (PLAYER_Y + PLAYER_H > meteorY[0]);
    wire hitMeteor1 = meteorActive[1] &&
        (playerX < meteorX[1] + MTR_W) && (playerX + PLAYER_W > meteorX[1]) &&
        (PLAYER_Y < meteorY[1] + MTR_H) && (PLAYER_Y + PLAYER_H > meteorY[1]);
    wire hitMeteor2 = meteorActive[2] &&
        (playerX < meteorX[2] + MTR_W) && (playerX + PLAYER_W > meteorX[2]) &&
        (PLAYER_Y < meteorY[2] + MTR_H) && (PLAYER_Y + PLAYER_H > meteorY[2]);
    wire hitMeteor3 = meteorActive[3] &&
        (playerX < meteorX[3] + MTR_W) && (playerX + PLAYER_W > meteorX[3]) &&
        (PLAYER_Y < meteorY[3] + MTR_H) && (PLAYER_Y + PLAYER_H > meteorY[3]);
    wire anyHit = hitMeteor0 | hitMeteor1 | hitMeteor2 | hitMeteor3;

    // -------------------------------------------------------------------------
    // Initialization
    // -------------------------------------------------------------------------
    integer i;
    initial begin
        state         = S_IDLE;
        playerX       = (SCREEN_W - PLAYER_W) / 2;   // start centered
        score         = 16'd0;
        lives         = 3'd3;
        fallInterval  = FALL_BASE;
        spawnInterval = SPAWN_BASE;
        fallCounter   = 32'd0;
        spawnCounter  = 32'd0;
        moveCounter   = 32'd0;
        lfsr          = 15'b101_0101_0101_0101;
        btnC_prev     = 1'b0;
        btnU_prev     = 1'b0;
        for (i = 0; i < NUM_MTRS; i = i + 1) begin
            meteorX[i]      = 10'd0;
            meteorY[i]      = 10'd0;
            meteorActive[i] = 1'b0;
        end
    end

    // -------------------------------------------------------------------------
    // Main game logic — sequential, runs every clock cycle
    // -------------------------------------------------------------------------
    always @(posedge clk) begin

        // Button edge detection
        btnC_prev <= btnC;
        btnU_prev <= btnU;

        // LFSR always ticks (gives pseudo-random values for spawn X)
        lfsr <= {lfsr[13:0], lfsr[14] ^ lfsr[13]};

        case (state)

            // ------------------------------------------------------------------
            S_IDLE: begin
                // Show title screen, wait for BtnC to start
                score  <= 16'd0;
                lives  <= 3'd3;
                playerX <= (SCREEN_W - PLAYER_W) / 2;
                fallInterval  <= FALL_BASE;
                spawnInterval <= SPAWN_BASE;
                for (i = 0; i < NUM_MTRS; i = i + 1)
                    meteorActive[i] <= 1'b0;
                if (btnC_rise)
                    state <= S_PLAY;
            end

            // ------------------------------------------------------------------
            S_PLAY: begin

                // -- Pause check --
                if (btnU_rise)
                    state <= S_PAUSE;

                // -- Player movement --
                moveCounter <= moveCounter + 1;
                if (moveCounter >= MOVE_INTERVAL) begin
                    moveCounter <= 32'd0;
                    if (btnL && playerX > PLAYER_MIN)
                        playerX <= playerX - 10'd4;
                    if (btnR && playerX < PLAYER_MAX)
                        playerX <= playerX + 10'd4;
                    // TODO (Week 3): replace btnL/btnR with accelerometer:
                    //   if (accel_x < -TILT_THRESH && playerX > PLAYER_MIN) playerX -= 4;
                    //   if (accel_x >  TILT_THRESH && playerX < PLAYER_MAX) playerX += 4;
                end

                // -- Meteor movement (all active meteors fall together) --
                fallCounter <= fallCounter + 1;
                if (fallCounter >= fallInterval) begin
                    fallCounter <= 32'd0;
                    for (i = 0; i < NUM_MTRS; i = i + 1) begin
                        if (meteorActive[i]) begin
                            if (meteorY[i] >= SCREEN_H) begin
                                // Meteor exited bottom — deactivate and add score
                                meteorActive[i] <= 1'b0;
                                score <= score + 16'd1;
                            end else begin
                                meteorY[i] <= meteorY[i] + 10'd1;
                            end
                        end
                    end
                end

                // -- Meteor spawn --
                spawnCounter <= spawnCounter + 1;
                if (spawnCounter >= spawnInterval) begin
                    spawnCounter <= 32'd0;
                    // Find the first inactive meteor slot and activate it
                    // Using a priority encoder (first match wins each spawn)
                    if (!meteorActive[0]) begin
                        meteorActive[0] <= 1'b1;
                        meteorY[0]      <= 10'd(HUD_H);
                        // Use LFSR bits to pick a random X within visible area
                        meteorX[0]      <= {1'b0, lfsr[8:0]} % (SCREEN_W - MTR_W);
                    end else if (!meteorActive[1]) begin
                        meteorActive[1] <= 1'b1;
                        meteorY[1]      <= 10'd(HUD_H);
                        meteorX[1]      <= {1'b0, lfsr[9:1]} % (SCREEN_W - MTR_W);
                    end else if (!meteorActive[2]) begin
                        meteorActive[2] <= 1'b1;
                        meteorY[2]      <= 10'd(HUD_H);
                        meteorX[2]      <= {1'b0, lfsr[10:2]} % (SCREEN_W - MTR_W);
                    end else if (!meteorActive[3]) begin
                        meteorActive[3] <= 1'b1;
                        meteorY[3]      <= 10'd(HUD_H);
                        meteorX[3]      <= {1'b0, lfsr[11:3]} % (SCREEN_W - MTR_W);
                    end
                    // If all 4 slots full, skip this spawn cycle
                end

                // -- Collision detection (check once per scanline at hCount=0) --
                if (hCount == 10'd0) begin
                    if (anyHit) begin
                        // Deactivate the meteor that was hit
                        if (hitMeteor0) meteorActive[0] <= 1'b0;
                        if (hitMeteor1) meteorActive[1] <= 1'b0;
                        if (hitMeteor2) meteorActive[2] <= 1'b0;
                        if (hitMeteor3) meteorActive[3] <= 1'b0;
                        // Lose a life
                        if (lives > 0)
                            lives <= lives - 3'd1;
                        if (lives == 3'd1)   // about to hit 0
                            state <= S_GAMEOVER;
                    end
                end

                // -- Difficulty scaling --
                // Every SPEED_STEP dodged meteors, speed up
                if (score > 0 && (score % SPEED_STEP == 0)) begin
                    if (fallInterval > FALL_MIN + SPEED_DEC)
                        fallInterval <= fallInterval - SPEED_DEC;
                    else
                        fallInterval <= FALL_MIN;
                    if (spawnInterval > SPAWN_MIN + 32'd200_000)
                        spawnInterval <= spawnInterval - 32'd200_000;
                    else
                        spawnInterval <= SPAWN_MIN;
                end

            end

            // ------------------------------------------------------------------
            S_PAUSE: begin
                // Nothing moves; BtnU to resume, BtnC to reset to idle
                if (btnU_rise) state <= S_PLAY;
                if (btnC_rise) state <= S_IDLE;
            end

            // ------------------------------------------------------------------
            S_GAMEOVER: begin
                // Show game over screen; BtnC to return to idle
                if (btnC_rise) state <= S_IDLE;
            end

        endcase
    end

    // -------------------------------------------------------------------------
    // Pixel painter — purely combinational
    // Runs every pixel: decides rgb based on hCount/vCount and game state
    // -------------------------------------------------------------------------
    always @(*) begin
        if (~bright) begin
            // Outside visible area — must output black
            rgb = BLACK;
        end else begin
            case (state)

                // --------------------------------------------------------------
                S_IDLE: begin
                    // Simple title screen: dark background + centered white bar
                    // You can replace this with a proper title sprite later
                    if (py < HUD_H)
                        rgb = HUD_BG;
                    else if (py >= 200 && py < 260 && px >= 160 && px < 480)
                        rgb = 12'hAAF;   // title box (light blue)
                    else if (py >= 300 && py < 320 && px >= 220 && px < 420)
                        rgb = 12'hFF8;   // "press btnC" hint box
                    else if (isStar)
                        rgb = WHITE;
                    else
                        rgb = DARK_SPACE;
                end

                // --------------------------------------------------------------
                S_PLAY: begin
                    if (inHUD) begin
                        // HUD bar
                        rgb = HUD_BG;
                        // Lives as 3 small red blocks (right side of HUD)
                        if ((inLife0 && lives >= 3'd1) ||
                            (inLife1 && lives >= 3'd2) ||
                            (inLife2 && lives >= 3'd3))
                            rgb = LIVES_COL;
                        // Score label area (left side) — solid tint
                        if (px < 10'd120 && py >= 10'd6 && py < 10'd22)
                            rgb = 12'h224;
                    end else if (inGround) begin
                        rgb = 12'h336;   // faint ground line
                    end else if (inPlayer) begin
                        // Player sprite: cockpit window is lighter
                        if (inCockpit)
                            rgb = 12'hAEF;
                        else if (inThruster)
                            rgb = 12'hFA4;   // orange thruster glow
                        else
                            rgb = PLAYER_COL;
                    end else if (inAnyMeteor) begin
                        // Meteor with highlight
                        rgb = inMeteorHi ? METEOR_HI : METEOR_COL;
                    end else if (isStar) begin
                        rgb = WHITE;
                    end else begin
                        rgb = DARK_SPACE;
                    end
                end

                // --------------------------------------------------------------
                S_PAUSE: begin
                    // Darken the whole screen with a pause overlay tint
                    // Meteors and player still visible but dimmed
                    if (inPlayer)
                        rgb = 12'h246;
                    else if (inAnyMeteor)
                        rgb = 12'h532;
                    else if (py >= 200 && py < 240 && px >= 200 && px < 440)
                        rgb = 12'h44A;   // "PAUSED" box
                    else
                        rgb = 12'h001;   // very dark
                end

                // --------------------------------------------------------------
                S_GAMEOVER: begin
                    // Red-tinted game over screen
                    if (py >= 180 && py < 260 && px >= 140 && px < 500)
                        rgb = GAMEOVER_C;  // "GAME OVER" box
                    else if (py >= 290 && py < 310 && px >= 200 && px < 440)
                        rgb = 12'hFF8;     // final score highlight
                    else if (isStar)
                        rgb = 12'hF88;     // stars tinted red
                    else
                        rgb = 12'h100;     // very dark red background
                end

                default: rgb = BLACK;
            endcase
        end
    end

endmodule