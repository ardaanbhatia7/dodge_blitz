`timescale 1ns / 1ps

module accelerometer_reader(
	input clk,
	input reset,
	input ACL_MISO,
	output reg ACL_MOSI,
	output reg ACL_SCLK,
	output reg ACL_CSN,
	output reg signed [15:0] accel_y,
	output tilt_left,
	output tilt_right,
	output tilt_neutral
	);

	parameter signed ACCEL_DEADZONE_POS = 16'sd80;
	parameter signed ACCEL_DEADZONE_NEG = -16'sd80;
	parameter SPI_DIVIDER = 8'd50;
	parameter READ_WAIT_MAX = 17'd100000;

	localparam ST_START_WRITE = 3'd0;
	localparam ST_START_READ  = 3'd1;
	localparam ST_SHIFT_LOW   = 3'd2;
	localparam ST_SHIFT_HIGH  = 3'd3;
	localparam ST_FINISH      = 3'd4;
	localparam ST_WAIT        = 3'd5;

	reg [2:0] state;
	reg [7:0] div_count;
	reg [1:0] byte_index;
	reg [2:0] bit_index;
	reg [7:0] rx_shift;
	reg [7:0] y_low;
	reg transaction_read;
	reg configured;
	reg [16:0] read_wait;

	wire [7:0] sampled_byte;
	wire [7:0] current_tx_byte;

	assign sampled_byte = {rx_shift[6:0], ACL_MISO};
	assign current_tx_byte = tx_byte(transaction_read, byte_index);
	assign tilt_left = (accel_y > ACCEL_DEADZONE_POS);
	assign tilt_right = (accel_y < ACCEL_DEADZONE_NEG);
	assign tilt_neutral = !tilt_left && !tilt_right;

	function [7:0] tx_byte;
		input read_transaction;
		input [1:0] index;
		begin
			if (read_transaction)
				begin
				case (index)
					2'd0: tx_byte = 8'h0B;
					2'd1: tx_byte = 8'h10;
					default: tx_byte = 8'h00;
				endcase
				end
			else
				begin
				case (index)
					2'd0: tx_byte = 8'h0A;
					2'd1: tx_byte = 8'h2D;
					default: tx_byte = 8'h02;
				endcase
				end
		end
	endfunction

	initial begin
		state = ST_START_WRITE;
		div_count = 8'd0;
		byte_index = 2'd0;
		bit_index = 3'd7;
		rx_shift = 8'd0;
		y_low = 8'd0;
		transaction_read = 1'b0;
		configured = 1'b0;
		read_wait = 17'd0;
		ACL_MOSI = 1'b0;
		ACL_SCLK = 1'b0;
		ACL_CSN = 1'b1;
		accel_y = 16'sd0;
	end

	always @(posedge clk)
		begin
		if (reset)
			begin
			state <= ST_START_WRITE;
			div_count <= 8'd0;
			byte_index <= 2'd0;
			bit_index <= 3'd7;
			rx_shift <= 8'd0;
			y_low <= 8'd0;
			transaction_read <= 1'b0;
			configured <= 1'b0;
			read_wait <= 17'd0;
			ACL_MOSI <= 1'b0;
			ACL_SCLK <= 1'b0;
			ACL_CSN <= 1'b1;
			accel_y <= 16'sd0;
			end
		else
			begin
			case (state)
				ST_START_WRITE:
					begin
					ACL_CSN <= 1'b0;
					ACL_SCLK <= 1'b0;
					transaction_read <= 1'b0;
					byte_index <= 2'd0;
					bit_index <= 3'd7;
					div_count <= 8'd0;
					rx_shift <= 8'd0;
					ACL_MOSI <= 1'b0;
					state <= ST_SHIFT_LOW;
					end
				ST_START_READ:
					begin
					ACL_CSN <= 1'b0;
					ACL_SCLK <= 1'b0;
					transaction_read <= 1'b1;
					byte_index <= 2'd0;
					bit_index <= 3'd7;
					div_count <= 8'd0;
					rx_shift <= 8'd0;
					ACL_MOSI <= 1'b0;
					state <= ST_SHIFT_LOW;
					end
				ST_SHIFT_LOW:
					begin
					ACL_SCLK <= 1'b0;
					ACL_MOSI <= current_tx_byte[bit_index];
					if (div_count == SPI_DIVIDER - 8'd1)
						begin
						div_count <= 8'd0;
						state <= ST_SHIFT_HIGH;
						end
					else
						div_count <= div_count + 8'd1;
					end
				ST_SHIFT_HIGH:
					begin
					ACL_SCLK <= 1'b1;
					if (div_count == SPI_DIVIDER - 8'd1)
						begin
						div_count <= 8'd0;
						rx_shift <= sampled_byte;
						if (bit_index == 3'd0)
							begin
							if (transaction_read && (byte_index == 2'd2))
								y_low <= sampled_byte;
							if (transaction_read && (byte_index == 2'd3))
								accel_y <= {{4{sampled_byte[3]}}, sampled_byte[3:0], y_low};

							if ((!transaction_read && (byte_index == 2'd2)) ||
							    (transaction_read && (byte_index == 2'd3)))
								state <= ST_FINISH;
							else
								begin
								byte_index <= byte_index + 2'd1;
								bit_index <= 3'd7;
								rx_shift <= 8'd0;
								state <= ST_SHIFT_LOW;
								end
							end
						else
							begin
							bit_index <= bit_index - 3'd1;
							state <= ST_SHIFT_LOW;
							end
						end
					else
						div_count <= div_count + 8'd1;
					end
				ST_FINISH:
					begin
					ACL_CSN <= 1'b1;
					ACL_SCLK <= 1'b0;
					ACL_MOSI <= 1'b0;
					read_wait <= 17'd0;
					configured <= 1'b1;
					state <= ST_WAIT;
					end
				ST_WAIT:
					begin
					if (read_wait == READ_WAIT_MAX - 17'd1)
						begin
						read_wait <= 17'd0;
						state <= configured ? ST_START_READ : ST_START_WRITE;
						end
					else
						read_wait <= read_wait + 17'd1;
					end
				default:
					state <= ST_START_WRITE;
			endcase
			end
		end

endmodule
