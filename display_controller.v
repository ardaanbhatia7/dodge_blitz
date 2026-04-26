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
	input btnL,
	input btnR,
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
	parameter GAME_TICK_MAX = 23'd5000000;
	parameter SPAWN_TICKS = 5'd16;
	parameter SCORE_TICKS = 5'd20;
	
	reg [1:0] pix_div;
	reg pixel_tick;
	reg [22:0] slow_counter;
	reg game_tick;
	reg [9:0] player_x;
	reg [9:0] block_x [0:7];
	reg [9:0] block_y [0:7];
	reg active [0:7];
	reg [1:0] lives;
	reg game_over;
	reg [2:0] spawn_index;
	reg [4:0] spawn_counter;
	reg [4:0] score_counter;
	wire [7:0] random_value;
	wire [9:0] random_x_raw;
	wire [9:0] random_block_x;
	integer i;

	lfsr random_block_generator(
		.clk(clk),
		.reset(reset),
		.enable(game_tick && !game_over),
		.random(random_value)
	);

	assign random_x_raw = {1'b0, random_value, 1'b0} + {2'b00, random_value};
	assign random_block_x = (random_x_raw > SCREEN_W - BLOCK_SIZE) ? random_x_raw - 10'd160 : random_x_raw;

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
		game_over = 1'b0;
		spawn_index = 3'd0;
		spawn_counter = 5'd0;
		score_counter = 5'd0;
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
		
	assign hSync = (hCount < 96) ? 1:0;
	assign vSync = (vCount < 2) ? 1:0;
	
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
			game_over <= 1'b0;
			spawn_index <= 3'd0;
			spawn_counter <= 5'd0;
			score_counter <= 5'd0;
			for (i = 0; i < 8; i = i + 1)
				begin
				block_x[i] <= 10'd0;
				block_y[i] <= 10'd0;
				active[i] <= 1'b0;
				end
			end
		else
			begin
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
			
			if (game_tick && !game_over)
				begin
				if (score_counter == SCORE_TICKS - 5'd1)
					begin
					score <= score + 16'd1;
					score_counter <= 5'd0;
					end
				else
					score_counter <= score_counter + 5'd1;
				
				if (btnL && (player_x >= PLAYER_STEP))
					player_x <= player_x - PLAYER_STEP;
				else if (btnL)
					player_x <= 10'd0;
				else if (btnR && (player_x <= SCREEN_W - PLAYER_SIZE - PLAYER_STEP))
					player_x <= player_x + PLAYER_STEP;
				else if (btnR)
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
							block_y[i] <= block_y[i] + BLOCK_STEP;
						
						if ((player_x < block_x[i] + BLOCK_SIZE) &&
						    (player_x + PLAYER_SIZE > block_x[i]) &&
						    (PLAYER_Y < block_y[i] + BLOCK_SIZE) &&
						    (PLAYER_Y + PLAYER_SIZE > block_y[i]))
							begin
							active[i] <= 1'b0;
							if (lives > 2'd0)
								lives <= lives - 2'd1;
							if (lives <= 2'd1)
								game_over <= 1'b1;
							end
						end
					end
				end
			
			if (!video_on)
				rgb <= BLACK;
			else if (player_on)
				rgb <= GREEN;
			else if (block_on)
				rgb <= RED;
			else if (lives_on)
				rgb <= WHITE;
			else
				rgb <= BLACK;
			end
		end	
		
endmodule
