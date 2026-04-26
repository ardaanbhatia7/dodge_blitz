`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:27:11 12/07/2017 
// Design Name: 
// Module Name:    DisplayController 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created

// Additional Comments:  https://learn.digilentinc.com/Documents/269
// - Use Bahavioural Modelling (always, initial)
// - Use the Following: clock divider, two counters(horizontal counter, vertical
// counter), 
//////////////////////////////////////////////////////////////////////////////////
module display_controller(
	input clk,
	input tilt_left,
	input tilt_right,
	input tilt_neutral,
	input btnL,
	input btnR,
	input btnU,
	input reset,
	output hSync, vSync,
	output reg bright,
	output reg[9:0] hCount, 
	output reg [9:0] vCount, // Covers 800, width of the screen, because it's 2^10
	output reg [11:0] rgb,
	output reg [15:0] score
	);
	
	parameter BLACK = 12'h000;
	parameter RED   = 12'hF00;
	parameter GREEN = 12'h0F0;
	parameter WHITE = 12'hFFF;
	parameter SKY_BLUE = 12'h6CF;
	parameter LAWN_GREEN = 12'h2A3;
	parameter YELLOW = 12'hFF0;
	parameter GRAY = 12'h888;
	
	parameter SCREEN_W = 10'd640;
	parameter SCREEN_H = 10'd480;
	parameter H_VISIBLE_START = 10'd144;
	parameter H_VISIBLE_END = 10'd784;
	parameter V_VISIBLE_START = 10'd35;
	parameter V_VISIBLE_END = 10'd515;
	parameter PLAYER_SIZE = 10'd20;
	parameter PLAYER_Y = 10'd440;
	parameter PLAYER_STEP = 10'd10;
	parameter BLOCK_SIZE = 10'd20;
	parameter BLOCK_STEP = 10'd2;
	parameter BLOCK_MAX_STEP = 10'd8;
	parameter DIFFICULTY_SCORE_STEP = 16'd10;
	parameter GAME_TICK_MAX = 23'd5000000;
	parameter SPAWN_TICKS = 5'd16;
	parameter SCORE_TICKS = 5'd20;
	parameter PLAYER_SPEED = 10'd5;

	localparam THEME_SPACE  = 2'd0;
	localparam THEME_SKY    = 2'd1;
	localparam THEME_GARDEN = 2'd2;

	localparam STATE_THEME_SELECT = 2'd0;
	localparam STATE_PLAYING      = 2'd1;
	localparam STATE_GAME_OVER    = 2'd2;
	
	reg [1:0] pix_div;
	reg pixel_tick;
	reg [22:0] slow_counter;
	reg game_tick;
	reg [9:0] player_x;
	reg [9:0] block_x [0:7];
	reg [9:0] block_y [0:7];
	reg active [0:7];
	reg [1:0] lives;
	reg [1:0] game_state;
	reg [1:0] selected_theme;
	reg [2:0] spawn_index;
	reg [4:0] spawn_counter;
	reg [4:0] score_counter;
	reg btnL_prev;
	reg btnR_prev;
	reg btnU_prev;
	wire [7:0] random_value;
	wire [9:0] random_x_raw;
	wire [9:0] random_block_x;
	wire [9:0] block_fall_step;
	wire game_over;
	wire theme_select;
	wire selector0_on;
	wire selector1_on;
	wire selector2_on;
	wire selector_on;
	wire selected_selector_on;
	wire [11:0] theme_background_rgb;
	integer i;

	lfsr random_block_generator(
		.clk(clk),
		.reset(reset),
		.enable(game_tick && (game_state == STATE_PLAYING)),
		.random(random_value)
	);

	assign random_x_raw = {1'b0, random_value, 1'b0} + {2'b00, random_value};
	assign random_block_x = (random_x_raw > SCREEN_W - BLOCK_SIZE) ? random_x_raw - 10'd160 : random_x_raw;
	assign block_fall_step = (score >= 16'd60) ? BLOCK_MAX_STEP :
	                         (score >= 16'd50) ? 10'd7 :
	                         (score >= 16'd40) ? 10'd6 :
	                         (score >= 16'd30) ? 10'd5 :
	                         (score >= 16'd20) ? 10'd4 :
	                         (score >= DIFFICULTY_SCORE_STEP) ? 10'd3 :
	                         BLOCK_STEP;
	assign game_over = (game_state == STATE_GAME_OVER);
	assign theme_select = (game_state == STATE_THEME_SELECT);
	assign selector0_on = video_on &&
	                      (pixel_x >= 10'd278) && (pixel_x < 10'd298) &&
	                      (pixel_y >= 10'd430) && (pixel_y < 10'd450);
	assign selector1_on = video_on &&
	                      (pixel_x >= 10'd310) && (pixel_x < 10'd330) &&
	                      (pixel_y >= 10'd430) && (pixel_y < 10'd450);
	assign selector2_on = video_on &&
	                      (pixel_x >= 10'd342) && (pixel_x < 10'd362) &&
	                      (pixel_y >= 10'd430) && (pixel_y < 10'd450);
	assign selector_on = selector0_on || selector1_on || selector2_on;
	assign selected_selector_on = ((selected_theme == THEME_SPACE) && selector0_on) ||
	                              ((selected_theme == THEME_SKY) && selector1_on) ||
	                              ((selected_theme == THEME_GARDEN) && selector2_on);
	assign theme_background_rgb = theme_rgb(pixel_x, pixel_y, selected_theme);

	initial begin
		hCount = 10'd0;
		vCount = 10'd0;
		bright = 1'b0;
		rgb = BLACK;
		score = 16'd0;
		pix_div = 2'd0;
		pixel_tick = 1'b0;
		slow_counter = 23'd0;
		game_tick = 1'b0;
		player_x = 10'd310;
		lives = 2'd3;
		game_state = STATE_THEME_SELECT;
		selected_theme = THEME_SPACE;
		spawn_index = 3'd0;
		spawn_counter = 5'd0;
		score_counter = 5'd0;
		btnL_prev = 1'b0;
		btnR_prev = 1'b0;
		btnU_prev = 1'b0;
		for (i = 0; i < 8; i = i + 1)
			begin
			block_x[i] = 10'd0;
			block_y[i] = 10'd0;
			active[i] = 1'b0;
			end
	end
	
	wire [9:0] pixel_x = hCount - H_VISIBLE_START;
	wire [9:0] pixel_y = vCount - V_VISIBLE_START;
	wire video_on = (hCount >= H_VISIBLE_START) && (hCount < H_VISIBLE_END) &&
	                (vCount >= V_VISIBLE_START) && (vCount < V_VISIBLE_END);
	wire player_on = video_on &&
	                 (pixel_x >= player_x) && (pixel_x < player_x + PLAYER_SIZE) &&
	                 (pixel_y >= PLAYER_Y) && (pixel_y < PLAYER_Y + PLAYER_SIZE);
	wire block0_on = video_on && active[0] &&
	                 (pixel_x >= block_x[0]) && (pixel_x < block_x[0] + BLOCK_SIZE) &&
	                 (pixel_y >= block_y[0]) && (pixel_y < block_y[0] + BLOCK_SIZE);
	wire block1_on = video_on && active[1] &&
	                 (pixel_x >= block_x[1]) && (pixel_x < block_x[1] + BLOCK_SIZE) &&
	                 (pixel_y >= block_y[1]) && (pixel_y < block_y[1] + BLOCK_SIZE);
	wire block2_on = video_on && active[2] &&
	                 (pixel_x >= block_x[2]) && (pixel_x < block_x[2] + BLOCK_SIZE) &&
	                 (pixel_y >= block_y[2]) && (pixel_y < block_y[2] + BLOCK_SIZE);
	wire block3_on = video_on && active[3] &&
	                 (pixel_x >= block_x[3]) && (pixel_x < block_x[3] + BLOCK_SIZE) &&
	                 (pixel_y >= block_y[3]) && (pixel_y < block_y[3] + BLOCK_SIZE);
	wire block4_on = video_on && active[4] &&
	                 (pixel_x >= block_x[4]) && (pixel_x < block_x[4] + BLOCK_SIZE) &&
	                 (pixel_y >= block_y[4]) && (pixel_y < block_y[4] + BLOCK_SIZE);
	wire block5_on = video_on && active[5] &&
	                 (pixel_x >= block_x[5]) && (pixel_x < block_x[5] + BLOCK_SIZE) &&
	                 (pixel_y >= block_y[5]) && (pixel_y < block_y[5] + BLOCK_SIZE);
	wire block6_on = video_on && active[6] &&
	                 (pixel_x >= block_x[6]) && (pixel_x < block_x[6] + BLOCK_SIZE) &&
	                 (pixel_y >= block_y[6]) && (pixel_y < block_y[6] + BLOCK_SIZE);
	wire block7_on = video_on && active[7] &&
	                 (pixel_x >= block_x[7]) && (pixel_x < block_x[7] + BLOCK_SIZE) &&
	                 (pixel_y >= block_y[7]) && (pixel_y < block_y[7] + BLOCK_SIZE);
	wire block_on = block0_on || block1_on || block2_on || block3_on ||
	                block4_on || block5_on || block6_on || block7_on;
	wire life0_on = video_on && (lives > 2'd0) &&
	                (pixel_x >= 10'd580) && (pixel_x < 10'd592) &&
	                (pixel_y >= 10'd10) && (pixel_y < 10'd22);
	wire life1_on = video_on && (lives > 2'd1) &&
	                (pixel_x >= 10'd600) && (pixel_x < 10'd612) &&
	                (pixel_y >= 10'd10) && (pixel_y < 10'd22);
	wire life2_on = video_on && (lives > 2'd2) &&
	                (pixel_x >= 10'd620) && (pixel_x < 10'd632) &&
	                (pixel_y >= 10'd10) && (pixel_y < 10'd22);
	wire lives_on = life0_on || life1_on || life2_on;
	wire game_over_text_on = game_over && video_on &&
	                         (text_pixel(pixel_x, pixel_y, 10'd236, 10'd145, 4'd4, 5'd0) ||
	                          text_pixel(pixel_x, pixel_y, 10'd148, 10'd215, 4'd3, 5'd1) ||
	                          text_pixel(pixel_x, pixel_y, 10'd172, 10'd265, 4'd3, 5'd2));
		
	assign hSync = (hCount < 96) ? 1:0;
	assign vSync = (vCount < 2) ? 1:0;

	function [4:0] glyph_row;
		input [7:0] ch;
		input [2:0] row;
		begin
			case (ch)
				8'h20: glyph_row = 5'b00000;
				8'h41: case (row) 3'd0: glyph_row = 5'b01110; 3'd1: glyph_row = 5'b10001; 3'd2: glyph_row = 5'b10001; 3'd3: glyph_row = 5'b11111; 3'd4: glyph_row = 5'b10001; 3'd5: glyph_row = 5'b10001; default: glyph_row = 5'b10001; endcase
				8'h42: case (row) 3'd0: glyph_row = 5'b11110; 3'd1: glyph_row = 5'b10001; 3'd2: glyph_row = 5'b10001; 3'd3: glyph_row = 5'b11110; 3'd4: glyph_row = 5'b10001; 3'd5: glyph_row = 5'b10001; default: glyph_row = 5'b11110; endcase
				8'h43: case (row) 3'd0: glyph_row = 5'b01110; 3'd1: glyph_row = 5'b10001; 3'd2: glyph_row = 5'b10000; 3'd3: glyph_row = 5'b10000; 3'd4: glyph_row = 5'b10000; 3'd5: glyph_row = 5'b10001; default: glyph_row = 5'b01110; endcase
				8'h44: case (row) 3'd0: glyph_row = 5'b11110; 3'd1: glyph_row = 5'b10001; 3'd2: glyph_row = 5'b10001; 3'd3: glyph_row = 5'b10001; 3'd4: glyph_row = 5'b10001; 3'd5: glyph_row = 5'b10001; default: glyph_row = 5'b11110; endcase
				8'h45: case (row) 3'd0: glyph_row = 5'b11111; 3'd1: glyph_row = 5'b10000; 3'd2: glyph_row = 5'b10000; 3'd3: glyph_row = 5'b11110; 3'd4: glyph_row = 5'b10000; 3'd5: glyph_row = 5'b10000; default: glyph_row = 5'b11111; endcase
				8'h46: case (row) 3'd0: glyph_row = 5'b11111; 3'd1: glyph_row = 5'b10000; 3'd2: glyph_row = 5'b10000; 3'd3: glyph_row = 5'b11110; 3'd4: glyph_row = 5'b10000; 3'd5: glyph_row = 5'b10000; default: glyph_row = 5'b10000; endcase
				8'h47: case (row) 3'd0: glyph_row = 5'b01110; 3'd1: glyph_row = 5'b10001; 3'd2: glyph_row = 5'b10000; 3'd3: glyph_row = 5'b10111; 3'd4: glyph_row = 5'b10001; 3'd5: glyph_row = 5'b10001; default: glyph_row = 5'b01110; endcase
				8'h49: case (row) 3'd0: glyph_row = 5'b11111; 3'd1: glyph_row = 5'b00100; 3'd2: glyph_row = 5'b00100; 3'd3: glyph_row = 5'b00100; 3'd4: glyph_row = 5'b00100; 3'd5: glyph_row = 5'b00100; default: glyph_row = 5'b11111; endcase
				8'h4C: case (row) 3'd0: glyph_row = 5'b10000; 3'd1: glyph_row = 5'b10000; 3'd2: glyph_row = 5'b10000; 3'd3: glyph_row = 5'b10000; 3'd4: glyph_row = 5'b10000; 3'd5: glyph_row = 5'b10000; default: glyph_row = 5'b11111; endcase
				8'h4D: case (row) 3'd0: glyph_row = 5'b10001; 3'd1: glyph_row = 5'b11011; 3'd2: glyph_row = 5'b10101; 3'd3: glyph_row = 5'b10101; 3'd4: glyph_row = 5'b10001; 3'd5: glyph_row = 5'b10001; default: glyph_row = 5'b10001; endcase
				8'h4E: case (row) 3'd0: glyph_row = 5'b10001; 3'd1: glyph_row = 5'b11001; 3'd2: glyph_row = 5'b10101; 3'd3: glyph_row = 5'b10011; 3'd4: glyph_row = 5'b10001; 3'd5: glyph_row = 5'b10001; default: glyph_row = 5'b10001; endcase
				8'h4F: case (row) 3'd0: glyph_row = 5'b01110; 3'd1: glyph_row = 5'b10001; 3'd2: glyph_row = 5'b10001; 3'd3: glyph_row = 5'b10001; 3'd4: glyph_row = 5'b10001; 3'd5: glyph_row = 5'b10001; default: glyph_row = 5'b01110; endcase
				8'h50: case (row) 3'd0: glyph_row = 5'b11110; 3'd1: glyph_row = 5'b10001; 3'd2: glyph_row = 5'b10001; 3'd3: glyph_row = 5'b11110; 3'd4: glyph_row = 5'b10000; 3'd5: glyph_row = 5'b10000; default: glyph_row = 5'b10000; endcase
				8'h52: case (row) 3'd0: glyph_row = 5'b11110; 3'd1: glyph_row = 5'b10001; 3'd2: glyph_row = 5'b10001; 3'd3: glyph_row = 5'b11110; 3'd4: glyph_row = 5'b10100; 3'd5: glyph_row = 5'b10010; default: glyph_row = 5'b10001; endcase
				8'h53: case (row) 3'd0: glyph_row = 5'b01111; 3'd1: glyph_row = 5'b10000; 3'd2: glyph_row = 5'b10000; 3'd3: glyph_row = 5'b01110; 3'd4: glyph_row = 5'b00001; 3'd5: glyph_row = 5'b00001; default: glyph_row = 5'b11110; endcase
				8'h54: case (row) 3'd0: glyph_row = 5'b11111; 3'd1: glyph_row = 5'b00100; 3'd2: glyph_row = 5'b00100; 3'd3: glyph_row = 5'b00100; 3'd4: glyph_row = 5'b00100; 3'd5: glyph_row = 5'b00100; default: glyph_row = 5'b00100; endcase
				8'h56: case (row) 3'd0: glyph_row = 5'b10001; 3'd1: glyph_row = 5'b10001; 3'd2: glyph_row = 5'b10001; 3'd3: glyph_row = 5'b10001; 3'd4: glyph_row = 5'b10001; 3'd5: glyph_row = 5'b01010; default: glyph_row = 5'b00100; endcase
				default: glyph_row = 5'b00000;
			endcase
		end
	endfunction

	function [7:0] text_char;
		input [4:0] line;
		input [4:0] index;
		begin
			case (line)
				5'd0:
					case (index)
						5'd0: text_char = "G"; 5'd1: text_char = "A"; 5'd2: text_char = "M"; 5'd3: text_char = "E"; 5'd4: text_char = " ";
						5'd5: text_char = "O"; 5'd6: text_char = "V"; 5'd7: text_char = "E"; 5'd8: text_char = "R"; default: text_char = " ";
					endcase
				5'd1:
					case (index)
						5'd0: text_char = "P"; 5'd1: text_char = "R"; 5'd2: text_char = "E"; 5'd3: text_char = "S"; 5'd4: text_char = "S"; 5'd5: text_char = " ";
						5'd6: text_char = "C"; 5'd7: text_char = "E"; 5'd8: text_char = "N"; 5'd9: text_char = "T"; 5'd10: text_char = "R"; 5'd11: text_char = "E"; 5'd12: text_char = " ";
						5'd13: text_char = "B"; 5'd14: text_char = "T"; 5'd15: text_char = "N"; default: text_char = " ";
					endcase
				5'd2:
					case (index)
						5'd0: text_char = "F"; 5'd1: text_char = "I"; 5'd2: text_char = "N"; 5'd3: text_char = "A"; 5'd4: text_char = "L"; 5'd5: text_char = " ";
						5'd6: text_char = "S"; 5'd7: text_char = "C"; 5'd8: text_char = "O"; 5'd9: text_char = "R"; 5'd10: text_char = "E"; 5'd11: text_char = " ";
						5'd12: text_char = "S"; 5'd13: text_char = "S"; 5'd14: text_char = "D"; default: text_char = " ";
					endcase
				default: text_char = " ";
			endcase
		end
	endfunction

	function text_pixel;
		input [9:0] x;
		input [9:0] y;
		input [9:0] origin_x;
		input [9:0] origin_y;
		input [3:0] scale;
		input [4:0] line;
		reg [9:0] rel_x;
		reg [9:0] rel_y;
		reg [4:0] char_index;
		reg [2:0] glyph_x;
		reg [2:0] glyph_y;
		reg [4:0] row_bits;
		begin
			if ((x >= origin_x) && (y >= origin_y) &&
			    (x < origin_x + (16 * 6 * scale)) &&
			    (y < origin_y + (7 * scale)))
				begin
				rel_x = x - origin_x;
				rel_y = y - origin_y;
				char_index = rel_x / (6 * scale);
				glyph_x = (rel_x % (6 * scale)) / scale;
				glyph_y = rel_y / scale;
				row_bits = glyph_row(text_char(line, char_index), glyph_y);
				if (glyph_x < 3'd5)
					text_pixel = row_bits[4 - glyph_x];
				else
					text_pixel = 1'b0;
				end
			else
				text_pixel = 1'b0;
		end
	endfunction

	function [11:0] theme_rgb;
		input [9:0] x;
		input [9:0] y;
		input [1:0] theme;
		begin
			case (theme)
				THEME_SPACE:
					begin
					if (((x[4:0] == 5'd3) && (y[5:0] == 6'd9)) ||
					    ((x[6:1] == y[6:1]) && (x[3:0] == 4'd0)) ||
					    ((x[7:2] + y[7:2]) == 6'd47))
						theme_rgb = WHITE;
					else if ((x >= 10'd520) && (x < 10'd570) &&
					         (y >= 10'd55) && (y < 10'd105))
						theme_rgb = 12'hCC8;
					else
						theme_rgb = 12'h001;
					end
				THEME_SKY:
					begin
					if ((x >= 10'd520) && (x < 10'd575) &&
					    (y >= 10'd35) && (y < 10'd90))
						theme_rgb = YELLOW;
					else if (((x >= 10'd90) && (x < 10'd190) && (y >= 10'd75) && (y < 10'd105)) ||
					         ((x >= 10'd120) && (x < 10'd165) && (y >= 10'd55) && (y < 10'd120)) ||
					         ((x >= 10'd360) && (x < 10'd500) && (y >= 10'd120) && (y < 10'd150)) ||
					         ((x >= 10'd400) && (x < 10'd455) && (y >= 10'd95) && (y < 10'd165)))
						theme_rgb = WHITE;
					else
						theme_rgb = SKY_BLUE;
					end
				THEME_GARDEN:
					begin
					if (y >= 10'd360)
						begin
						if (((x[5:0] == 6'd12) || (x[5:0] == 6'd42)) &&
						    (y >= 10'd390) && (y < 10'd430))
							theme_rgb = 12'hF4F;
						else
							theme_rgb = LAWN_GREEN;
						end
					else if (((x >= 10'd70) && (x < 10'd95) && (y >= 10'd250) && (y < 10'd360)) ||
					         ((x >= 10'd520) && (x < 10'd545) && (y >= 10'd245) && (y < 10'd360)))
						theme_rgb = 12'h840;
					else if (((x >= 10'd35) && (x < 10'd130) && (y >= 10'd205) && (y < 10'd265)) ||
					         ((x >= 10'd485) && (x < 10'd580) && (y >= 10'd200) && (y < 10'd265)))
						theme_rgb = 12'h0A0;
					else
						theme_rgb = SKY_BLUE;
					end
				default:
					theme_rgb = BLACK;
			endcase
		end
	endfunction
	
	always @(posedge clk)
		begin
		if (reset)
			begin
			hCount <= 10'd0;
			vCount <= 10'd0;
			bright <= 1'b0;
			rgb <= BLACK;
			score <= 16'd0;
			pix_div <= 2'd0;
			pixel_tick <= 1'b0;
			slow_counter <= 23'd0;
			game_tick <= 1'b0;
			player_x <= 10'd310;
			lives <= 2'd3;
			game_state <= STATE_THEME_SELECT;
			selected_theme <= THEME_SPACE;
			spawn_index <= 3'd0;
			spawn_counter <= 5'd0;
			score_counter <= 5'd0;
			btnL_prev <= 1'b0;
			btnR_prev <= 1'b0;
			btnU_prev <= 1'b0;
			for (i = 0; i < 8; i = i + 1)
				begin
				block_x[i] <= 10'd0;
				block_y[i] <= 10'd0;
				active[i] <= 1'b0;
				end
			end
			else
			begin
			btnL_prev <= btnL;
			btnR_prev <= btnR;
			btnU_prev <= btnU;
			pix_div <= pix_div + 2'd1;
			pixel_tick <= (pix_div == 2'd3);
			if (slow_counter == GAME_TICK_MAX - 23'd1)
				begin
				slow_counter <= 23'd0;
				game_tick <= 1'b1;
				end
			else
				begin
				slow_counter <= slow_counter + 23'd1;
				game_tick <= 1'b0;
				end
			
			if (pixel_tick)
				begin
				if (hCount < 10'd799)
					begin
					hCount <= hCount + 10'd1;
					end
				else if (vCount < 10'd524)
					begin
					hCount <= 10'd0;
					vCount <= vCount + 10'd1;
					end
				else
					begin
					hCount <= 10'd0;
					vCount <= 10'd0;
					end
				
				if(hCount > 10'd143 && hCount < 10'd784 && vCount > 10'd34 && vCount < 10'd516)
					bright <= 1'b1;
				else
					bright <= 1'b0;
				end
			
			if (theme_select)
				begin
				if (btnL && !btnL_prev)
					begin
					if (selected_theme == THEME_SPACE)
						selected_theme <= THEME_GARDEN;
					else
						selected_theme <= selected_theme - 2'd1;
					end
				else if (btnR && !btnR_prev)
					begin
					if (selected_theme == THEME_GARDEN)
						selected_theme <= THEME_SPACE;
					else
						selected_theme <= selected_theme + 2'd1;
					end
				else if (btnU && !btnU_prev)
					game_state <= STATE_PLAYING;
				end

			if (game_tick && (game_state == STATE_PLAYING))
				begin
				if (score_counter == SCORE_TICKS - 5'd1)
					begin
					score <= score + 16'd1;
					score_counter <= 5'd0;
					end
				else
					score_counter <= score_counter + 5'd1;
				
				if (tilt_left && (player_x >= PLAYER_SPEED))
					player_x <= player_x - PLAYER_SPEED;
				else if (tilt_left)
					player_x <= 10'd0;
				else if (tilt_right && (player_x <= SCREEN_W - PLAYER_SIZE - PLAYER_SPEED))
					player_x <= player_x + PLAYER_SPEED;
				else if (tilt_right)
					player_x <= SCREEN_W - PLAYER_SIZE;
				
				if (spawn_counter == SPAWN_TICKS - 5'd1)
					begin
					spawn_counter <= 5'd0;
					if (!active[spawn_index])
						begin
						active[spawn_index] <= 1'b1;
						block_y[spawn_index] <= 10'd0;
						block_x[spawn_index] <= random_block_x;
						end
					spawn_index <= spawn_index + 3'd1;
					end
				else
					spawn_counter <= spawn_counter + 5'd1;
				
				for (i = 0; i < 8; i = i + 1)
					begin
					if (active[i])
						begin
						if (block_y[i] >= SCREEN_H - BLOCK_SIZE)
							active[i] <= 1'b0;
						else
							block_y[i] <= block_y[i] + block_fall_step;
						
						if ((player_x < block_x[i] + BLOCK_SIZE) &&
						    (player_x + PLAYER_SIZE > block_x[i]) &&
						    (PLAYER_Y < block_y[i] + BLOCK_SIZE) &&
						    (PLAYER_Y + PLAYER_SIZE > block_y[i]))
							begin
							active[i] <= 1'b0;
							if (lives > 2'd0)
								lives <= lives - 2'd1;
							if (lives <= 2'd1)
								game_state <= STATE_GAME_OVER;
							end
						end
					end
				end
			
			if (!video_on)
				rgb <= BLACK;
			else if (game_over)
				begin
				if (game_over_text_on)
					rgb <= WHITE;
				else
					rgb <= BLACK;
				end
			else if (theme_select && selected_selector_on)
				rgb <= WHITE;
			else if (theme_select && selector_on)
				rgb <= GRAY;
			else if (theme_select)
				rgb <= theme_background_rgb;
			else if (player_on)
				rgb <= GREEN;
			else if (block_on)
				rgb <= RED;
			else if (lives_on)
				rgb <= WHITE;
			else
				rgb <= theme_background_rgb;
			end
		end	
		
endmodule
