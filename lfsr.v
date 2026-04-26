`timescale 1ns / 1ps

module lfsr(
	input clk,
	input reset,
	input enable,
	output reg [7:0] random
	);

	wire feedback;

	assign feedback = random[7] ^ random[5] ^ random[4] ^ random[3];

	initial begin
		random = 8'hA5;
	end

	always @(posedge clk)
		begin
		if (reset)
			random <= 8'hA5;
		else if (enable)
			random <= {random[6:0], feedback};
		end

endmodule
