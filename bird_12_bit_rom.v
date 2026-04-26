module bird_rom
	(
		input wire clk,
		input wire [5:0] row,
		input wire [5:0] col,
		output reg [11:0] color_data
	);

	(* rom_style = "block" *)

	//signal declaration
	reg [5:0] row_reg;
	reg [5:0] col_reg;

	always @(posedge clk)
		begin
		row_reg <= row;
		col_reg <= col;
		end

	always @(*) begin









		if(({row_reg, col_reg}>=12'b000000000000) && ({row_reg, col_reg}<12'b001001001001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001001001001)) color_data = 12'b110100001101;
		if(({row_reg, col_reg}>=12'b001001001010) && ({row_reg, col_reg}<12'b001001001101)) color_data = 12'b001000000100;
		if(({row_reg, col_reg}==12'b001001001101)) color_data = 12'b111000001110;

		if(({row_reg, col_reg}>=12'b001001001110) && ({row_reg, col_reg}<12'b001010001000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001010001000)) color_data = 12'b110100001101;
		if(({row_reg, col_reg}==12'b001010001001)) color_data = 12'b001100100110;
		if(({row_reg, col_reg}==12'b001010001010)) color_data = 12'b001101111100;
		if(({row_reg, col_reg}==12'b001010001011)) color_data = 12'b001110001100;
		if(({row_reg, col_reg}==12'b001010001100)) color_data = 12'b010010101100;
		if(({row_reg, col_reg}==12'b001010001101)) color_data = 12'b001100010101;
		if(({row_reg, col_reg}==12'b001010001110)) color_data = 12'b110100001110;

		if(({row_reg, col_reg}>=12'b001010001111) && ({row_reg, col_reg}<12'b001011001000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001011001000)) color_data = 12'b101100001100;
		if(({row_reg, col_reg}==12'b001011001001)) color_data = 12'b000000100010;
		if(({row_reg, col_reg}==12'b001011001010)) color_data = 12'b001101111101;
		if(({row_reg, col_reg}==12'b001011001011)) color_data = 12'b010010011111;
		if(({row_reg, col_reg}==12'b001011001100)) color_data = 12'b010110101111;
		if(({row_reg, col_reg}==12'b001011001101)) color_data = 12'b010010101100;
		if(({row_reg, col_reg}==12'b001011001110)) color_data = 12'b001100100110;
		if(({row_reg, col_reg}==12'b001011001111)) color_data = 12'b110100001110;
		if(({row_reg, col_reg}>=12'b001011010000) && ({row_reg, col_reg}<12'b001011010110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001011010110)) color_data = 12'b101000001011;
		if(({row_reg, col_reg}==12'b001011010111)) color_data = 12'b001000000100;
		if(({row_reg, col_reg}==12'b001011011000)) color_data = 12'b010000000101;
		if(({row_reg, col_reg}==12'b001011011001)) color_data = 12'b001100000101;
		if(({row_reg, col_reg}==12'b001011011010)) color_data = 12'b010100000110;

		if(({row_reg, col_reg}>=12'b001011011011) && ({row_reg, col_reg}<12'b001100001000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001100001000)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}==12'b001100001001)) color_data = 12'b100000001010;
		if(({row_reg, col_reg}==12'b001100001010)) color_data = 12'b000100110110;
		if(({row_reg, col_reg}==12'b001100001011)) color_data = 12'b001101111100;
		if(({row_reg, col_reg}==12'b001100001100)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b001100001101)) color_data = 12'b010110101111;
		if(({row_reg, col_reg}==12'b001100001110)) color_data = 12'b001001111011;
		if(({row_reg, col_reg}==12'b001100001111)) color_data = 12'b010000010110;
		if(({row_reg, col_reg}==12'b001100010000)) color_data = 12'b110100001101;
		if(({row_reg, col_reg}==12'b001100010001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001100010010)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}==12'b001100010011)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001100010100)) color_data = 12'b101000001011;
		if(({row_reg, col_reg}==12'b001100010101)) color_data = 12'b010000000101;
		if(({row_reg, col_reg}==12'b001100010110)) color_data = 12'b001100111000;
		if(({row_reg, col_reg}>=12'b001100010111) && ({row_reg, col_reg}<12'b001100011001)) color_data = 12'b010010011011;
		if(({row_reg, col_reg}==12'b001100011001)) color_data = 12'b010010101100;
		if(({row_reg, col_reg}==12'b001100011010)) color_data = 12'b010010001010;
		if(({row_reg, col_reg}==12'b001100011011)) color_data = 12'b010100000110;
		if(({row_reg, col_reg}==12'b001100011100)) color_data = 12'b011000000111;

		if(({row_reg, col_reg}>=12'b001100011101) && ({row_reg, col_reg}<12'b001101001001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001101001001)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}==12'b001101001010)) color_data = 12'b000000000010;
		if(({row_reg, col_reg}==12'b001101001011)) color_data = 12'b000000100100;
		if(({row_reg, col_reg}==12'b001101001100)) color_data = 12'b001101111100;
		if(({row_reg, col_reg}==12'b001101001101)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b001101001110)) color_data = 12'b010010011111;
		if(({row_reg, col_reg}==12'b001101001111)) color_data = 12'b001001111011;
		if(({row_reg, col_reg}==12'b001101010000)) color_data = 12'b010000010110;
		if(({row_reg, col_reg}==12'b001101010001)) color_data = 12'b110100001101;
		if(({row_reg, col_reg}==12'b001101010010)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001101010011)) color_data = 12'b101000001011;
		if(({row_reg, col_reg}==12'b001101010100)) color_data = 12'b001100111000;
		if(({row_reg, col_reg}==12'b001101010101)) color_data = 12'b001001101001;
		if(({row_reg, col_reg}==12'b001101010110)) color_data = 12'b001101111100;
		if(({row_reg, col_reg}>=12'b001101010111) && ({row_reg, col_reg}<12'b001101011001)) color_data = 12'b010110111111;
		if(({row_reg, col_reg}>=12'b001101011001) && ({row_reg, col_reg}<12'b001101011011)) color_data = 12'b011010111111;
		if(({row_reg, col_reg}==12'b001101011011)) color_data = 12'b010010001010;
		if(({row_reg, col_reg}==12'b001101011100)) color_data = 12'b001001011001;
		if(({row_reg, col_reg}==12'b001101011101)) color_data = 12'b011000000111;

		if(({row_reg, col_reg}>=12'b001101011110) && ({row_reg, col_reg}<12'b001110001000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001110001000)) color_data = 12'b110100001110;
		if(({row_reg, col_reg}==12'b001110001001)) color_data = 12'b011000011000;
		if(({row_reg, col_reg}==12'b001110001010)) color_data = 12'b001001101001;
		if(({row_reg, col_reg}==12'b001110001011)) color_data = 12'b001101101010;
		if(({row_reg, col_reg}==12'b001110001100)) color_data = 12'b001001001001;
		if(({row_reg, col_reg}==12'b001110001101)) color_data = 12'b001101111100;
		if(({row_reg, col_reg}==12'b001110001110)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b001110001111)) color_data = 12'b010010101111;
		if(({row_reg, col_reg}==12'b001110010000)) color_data = 12'b001001111011;
		if(({row_reg, col_reg}==12'b001110010001)) color_data = 12'b010100010111;
		if(({row_reg, col_reg}==12'b001110010010)) color_data = 12'b100000011000;
		if(({row_reg, col_reg}==12'b001110010011)) color_data = 12'b001100100110;
		if(({row_reg, col_reg}==12'b001110010100)) color_data = 12'b001001011001;
		if(({row_reg, col_reg}>=12'b001110010101) && ({row_reg, col_reg}<12'b001110010111)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b001110010111)) color_data = 12'b010010001101;
		if(({row_reg, col_reg}>=12'b001110011000) && ({row_reg, col_reg}<12'b001110011010)) color_data = 12'b001110001110;
		if(({row_reg, col_reg}==12'b001110011010)) color_data = 12'b001110011110;
		if(({row_reg, col_reg}>=12'b001110011011) && ({row_reg, col_reg}<12'b001110011101)) color_data = 12'b011010111111;
		if(({row_reg, col_reg}==12'b001110011101)) color_data = 12'b001001101001;
		if(({row_reg, col_reg}==12'b001110011110)) color_data = 12'b011000011000;
		if(({row_reg, col_reg}==12'b001110011111)) color_data = 12'b111000001110;

		if(({row_reg, col_reg}>=12'b001110100000) && ({row_reg, col_reg}<12'b001111001000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001111001000)) color_data = 12'b101100001100;
		if(({row_reg, col_reg}==12'b001111001001)) color_data = 12'b000000100010;
		if(({row_reg, col_reg}==12'b001111001010)) color_data = 12'b001110001110;
		if(({row_reg, col_reg}==12'b001111001011)) color_data = 12'b010110111111;
		if(({row_reg, col_reg}>=12'b001111001100) && ({row_reg, col_reg}<12'b001111001110)) color_data = 12'b001101111100;
		if(({row_reg, col_reg}==12'b001111001110)) color_data = 12'b001101111101;
		if(({row_reg, col_reg}==12'b001111001111)) color_data = 12'b010010001101;
		if(({row_reg, col_reg}==12'b001111010000)) color_data = 12'b010010101111;
		if(({row_reg, col_reg}==12'b001111010001)) color_data = 12'b001001111011;
		if(({row_reg, col_reg}==12'b001111010010)) color_data = 12'b000000100010;
		if(({row_reg, col_reg}==12'b001111010011)) color_data = 12'b000100110110;
		if(({row_reg, col_reg}>=12'b001111010100) && ({row_reg, col_reg}<12'b001111010110)) color_data = 12'b001101111101;
		if(({row_reg, col_reg}==12'b001111010110)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b001111010111)) color_data = 12'b010010001110;
		if(({row_reg, col_reg}==12'b001111011000)) color_data = 12'b010110011110;
		if(({row_reg, col_reg}==12'b001111011001)) color_data = 12'b101111011111;
		if(({row_reg, col_reg}==12'b001111011010)) color_data = 12'b100111001111;
		if(({row_reg, col_reg}==12'b001111011011)) color_data = 12'b001110001110;
		if(({row_reg, col_reg}==12'b001111011100)) color_data = 12'b010110101111;
		if(({row_reg, col_reg}==12'b001111011101)) color_data = 12'b010010011111;
		if(({row_reg, col_reg}==12'b001111011110)) color_data = 12'b000000100010;
		if(({row_reg, col_reg}==12'b001111011111)) color_data = 12'b110100001101;

		if(({row_reg, col_reg}>=12'b001111100000) && ({row_reg, col_reg}<12'b010000001000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010000001000)) color_data = 12'b110100001110;
		if(({row_reg, col_reg}==12'b010000001001)) color_data = 12'b011000011000;
		if(({row_reg, col_reg}==12'b010000001010)) color_data = 12'b000100111000;
		if(({row_reg, col_reg}==12'b010000001011)) color_data = 12'b001101111101;
		if(({row_reg, col_reg}>=12'b010000001100) && ({row_reg, col_reg}<12'b010000001110)) color_data = 12'b010010011111;
		if(({row_reg, col_reg}==12'b010000001110)) color_data = 12'b001101111101;
		if(({row_reg, col_reg}==12'b010000001111)) color_data = 12'b010010001110;
		if(({row_reg, col_reg}==12'b010000010000)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b010000010001)) color_data = 12'b010010101111;
		if(({row_reg, col_reg}==12'b010000010010)) color_data = 12'b001101111011;
		if(({row_reg, col_reg}==12'b010000010011)) color_data = 12'b000100110110;
		if(({row_reg, col_reg}==12'b010000010100)) color_data = 12'b001001011010;
		if(({row_reg, col_reg}>=12'b010000010101) && ({row_reg, col_reg}<12'b010000010111)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b010000010111)) color_data = 12'b010110011110;
		if(({row_reg, col_reg}==12'b010000011000)) color_data = 12'b101111011111;
		if(({row_reg, col_reg}==12'b010000011001)) color_data = 12'b111111101110;
		if(({row_reg, col_reg}==12'b010000011010)) color_data = 12'b101010011001;
		if(({row_reg, col_reg}==12'b010000011011)) color_data = 12'b100111001111;
		if(({row_reg, col_reg}>=12'b010000011100) && ({row_reg, col_reg}<12'b010000011110)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b010000011110)) color_data = 12'b000100100101;
		if(({row_reg, col_reg}==12'b010000011111)) color_data = 12'b011100001001;

		if(({row_reg, col_reg}>=12'b010000100000) && ({row_reg, col_reg}<12'b010001001001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010001001001)) color_data = 12'b110100001110;
		if(({row_reg, col_reg}==12'b010001001010)) color_data = 12'b000000010011;
		if(({row_reg, col_reg}==12'b010001001011)) color_data = 12'b001001011010;
		if(({row_reg, col_reg}==12'b010001001100)) color_data = 12'b001101111100;
		if(({row_reg, col_reg}==12'b010001001101)) color_data = 12'b001101111101;
		if(({row_reg, col_reg}>=12'b010001001110) && ({row_reg, col_reg}<12'b010001010001)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b010001010001)) color_data = 12'b010010001110;
		if(({row_reg, col_reg}==12'b010001010010)) color_data = 12'b010010101111;
		if(({row_reg, col_reg}==12'b010001010011)) color_data = 12'b001101101010;
		if(({row_reg, col_reg}==12'b010001010100)) color_data = 12'b000100110110;
		if(({row_reg, col_reg}==12'b010001010101)) color_data = 12'b001001101011;
		if(({row_reg, col_reg}==12'b010001010110)) color_data = 12'b001110011110;
		if(({row_reg, col_reg}==12'b010001010111)) color_data = 12'b100010111110;
		if(({row_reg, col_reg}==12'b010001011000)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==12'b010001011001)) color_data = 12'b101110101011;
		if(({row_reg, col_reg}==12'b010001011010)) color_data = 12'b000000000000;
		if(({row_reg, col_reg}==12'b010001011011)) color_data = 12'b100110011001;
		if(({row_reg, col_reg}==12'b010001011100)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b010001011101)) color_data = 12'b001101111011;
		if(({row_reg, col_reg}==12'b010001011110)) color_data = 12'b100001110110;
		if(({row_reg, col_reg}==12'b010001011111)) color_data = 12'b011001100010;
		if(({row_reg, col_reg}==12'b010001100000)) color_data = 12'b100000011000;
		if(({row_reg, col_reg}==12'b010001100001)) color_data = 12'b110100001110;

		if(({row_reg, col_reg}>=12'b010001100010) && ({row_reg, col_reg}<12'b010010001001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010010001001)) color_data = 12'b110100001110;
		if(({row_reg, col_reg}==12'b010010001010)) color_data = 12'b010000010110;
		if(({row_reg, col_reg}==12'b010010001011)) color_data = 12'b000100110110;
		if(({row_reg, col_reg}==12'b010010001100)) color_data = 12'b001001001000;
		if(({row_reg, col_reg}==12'b010010001101)) color_data = 12'b001001011011;
		if(({row_reg, col_reg}==12'b010010001110)) color_data = 12'b001101111101;
		if(({row_reg, col_reg}>=12'b010010001111) && ({row_reg, col_reg}<12'b010010010010)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b010010010010)) color_data = 12'b010010001110;
		if(({row_reg, col_reg}==12'b010010010011)) color_data = 12'b010010101111;
		if(({row_reg, col_reg}==12'b010010010100)) color_data = 12'b001001011001;
		if(({row_reg, col_reg}==12'b010010010101)) color_data = 12'b001001001000;
		if(({row_reg, col_reg}==12'b010010010110)) color_data = 12'b010010011111;
		if(({row_reg, col_reg}==12'b010010010111)) color_data = 12'b011010101110;
		if(({row_reg, col_reg}==12'b010010011000)) color_data = 12'b111111111111;
		if(({row_reg, col_reg}==12'b010010011001)) color_data = 12'b110111001011;
		if(({row_reg, col_reg}==12'b010010011010)) color_data = 12'b000000000000;
		if(({row_reg, col_reg}==12'b010010011011)) color_data = 12'b000100100101;
		if(({row_reg, col_reg}==12'b010010011100)) color_data = 12'b001101101010;
		if(({row_reg, col_reg}==12'b010010011101)) color_data = 12'b011101000011;
		if(({row_reg, col_reg}>=12'b010010011110) && ({row_reg, col_reg}<12'b010010100000)) color_data = 12'b110110100010;
		if(({row_reg, col_reg}==12'b010010100000)) color_data = 12'b010100100100;
		if(({row_reg, col_reg}==12'b010010100001)) color_data = 12'b110000001101;

		if(({row_reg, col_reg}>=12'b010010100010) && ({row_reg, col_reg}<12'b010011001010)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010011001010)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}==12'b010011001011)) color_data = 12'b010000010110;
		if(({row_reg, col_reg}==12'b010011001100)) color_data = 12'b000100110110;
		if(({row_reg, col_reg}==12'b010011001101)) color_data = 12'b001001001001;
		if(({row_reg, col_reg}==12'b010011001110)) color_data = 12'b001001011010;
		if(({row_reg, col_reg}==12'b010011001111)) color_data = 12'b001110001101;
		if(({row_reg, col_reg}==12'b010011010000)) color_data = 12'b001110001110;
		if(({row_reg, col_reg}==12'b010011010001)) color_data = 12'b010010001110;
		if(({row_reg, col_reg}>=12'b010011010010) && ({row_reg, col_reg}<12'b010011010100)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b010011010100)) color_data = 12'b001110001101;
		if(({row_reg, col_reg}==12'b010011010101)) color_data = 12'b001101111101;
		if(({row_reg, col_reg}==12'b010011010110)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b010011010111)) color_data = 12'b001110001110;
		if(({row_reg, col_reg}==12'b010011011000)) color_data = 12'b010110101111;
		if(({row_reg, col_reg}==12'b010011011001)) color_data = 12'b100110111100;
		if(({row_reg, col_reg}==12'b010011011010)) color_data = 12'b000100110110;
		if(({row_reg, col_reg}==12'b010011011011)) color_data = 12'b011110111110;
		if(({row_reg, col_reg}==12'b010011011100)) color_data = 12'b011101100110;
		if(({row_reg, col_reg}==12'b010011011101)) color_data = 12'b101101010010;
		if(({row_reg, col_reg}==12'b010011011110)) color_data = 12'b011000110001;
		if(({row_reg, col_reg}==12'b010011011111)) color_data = 12'b001000000100;
		if(({row_reg, col_reg}==12'b010011100000)) color_data = 12'b110100001110;

		if(({row_reg, col_reg}>=12'b010011100001) && ({row_reg, col_reg}<12'b010100001100)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010100001100)) color_data = 12'b010100000110;
		if(({row_reg, col_reg}==12'b010100001101)) color_data = 12'b001100010101;
		if(({row_reg, col_reg}==12'b010100001110)) color_data = 12'b001000110111;
		if(({row_reg, col_reg}==12'b010100001111)) color_data = 12'b001001001000;
		if(({row_reg, col_reg}==12'b010100010000)) color_data = 12'b001001011010;
		if(({row_reg, col_reg}==12'b010100010001)) color_data = 12'b001101111101;
		if(({row_reg, col_reg}==12'b010100010010)) color_data = 12'b001110001110;
		if(({row_reg, col_reg}==12'b010100010011)) color_data = 12'b010010001101;
		if(({row_reg, col_reg}>=12'b010100010100) && ({row_reg, col_reg}<12'b010100010110)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b010100010110)) color_data = 12'b010010001110;
		if(({row_reg, col_reg}==12'b010100010111)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b010100011000)) color_data = 12'b011010101110;
		if(({row_reg, col_reg}==12'b010100011001)) color_data = 12'b010110011110;
		if(({row_reg, col_reg}==12'b010100011010)) color_data = 12'b100010111110;
		if(({row_reg, col_reg}>=12'b010100011011) && ({row_reg, col_reg}<12'b010100011101)) color_data = 12'b111111111110;
		if(({row_reg, col_reg}==12'b010100011101)) color_data = 12'b001000110011;
		if(({row_reg, col_reg}==12'b010100011110)) color_data = 12'b001000000100;
		if(({row_reg, col_reg}==12'b010100011111)) color_data = 12'b111000001110;

		if(({row_reg, col_reg}>=12'b010100100000) && ({row_reg, col_reg}<12'b010101001001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}>=12'b010101001001) && ({row_reg, col_reg}<12'b010101001110)) color_data = 12'b110100001101;
		if(({row_reg, col_reg}==12'b010101001110)) color_data = 12'b001100010101;
		if(({row_reg, col_reg}==12'b010101001111)) color_data = 12'b000000010011;
		if(({row_reg, col_reg}==12'b010101010000)) color_data = 12'b001001001001;
		if(({row_reg, col_reg}==12'b010101010001)) color_data = 12'b001001101011;
		if(({row_reg, col_reg}==12'b010101010010)) color_data = 12'b001001011011;
		if(({row_reg, col_reg}==12'b010101010011)) color_data = 12'b001110001101;
		if(({row_reg, col_reg}>=12'b010101010100) && ({row_reg, col_reg}<12'b010101010111)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b010101010111)) color_data = 12'b100111001110;
		if(({row_reg, col_reg}>=12'b010101011000) && ({row_reg, col_reg}<12'b010101011011)) color_data = 12'b111111111110;
		if(({row_reg, col_reg}==12'b010101011011)) color_data = 12'b111111101110;
		if(({row_reg, col_reg}==12'b010101011100)) color_data = 12'b110111001011;
		if(({row_reg, col_reg}==12'b010101011101)) color_data = 12'b001100100110;
		if(({row_reg, col_reg}==12'b010101011110)) color_data = 12'b110100001110;

		if(({row_reg, col_reg}>=12'b010101011111) && ({row_reg, col_reg}<12'b010110001000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010110001000)) color_data = 12'b101100001100;
		if(({row_reg, col_reg}>=12'b010110001001) && ({row_reg, col_reg}<12'b010110001101)) color_data = 12'b000000100100;
		if(({row_reg, col_reg}==12'b010110001101)) color_data = 12'b000000010011;
		if(({row_reg, col_reg}==12'b010110001110)) color_data = 12'b000100111000;
		if(({row_reg, col_reg}==12'b010110001111)) color_data = 12'b001001011011;
		if(({row_reg, col_reg}>=12'b010110010000) && ({row_reg, col_reg}<12'b010110010010)) color_data = 12'b001001101011;
		if(({row_reg, col_reg}==12'b010110010010)) color_data = 12'b001110001101;
		if(({row_reg, col_reg}>=12'b010110010011) && ({row_reg, col_reg}<12'b010110010101)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b010110010101)) color_data = 12'b010010001110;
		if(({row_reg, col_reg}==12'b010110010110)) color_data = 12'b100111001110;
		if(({row_reg, col_reg}>=12'b010110010111) && ({row_reg, col_reg}<12'b010110011010)) color_data = 12'b111111111110;
		if(({row_reg, col_reg}==12'b010110011010)) color_data = 12'b111111101101;
		if(({row_reg, col_reg}==12'b010110011011)) color_data = 12'b101010011001;
		if(({row_reg, col_reg}==12'b010110011100)) color_data = 12'b001100010101;
		if(({row_reg, col_reg}==12'b010110011101)) color_data = 12'b111000001110;

		if(({row_reg, col_reg}>=12'b010110011110) && ({row_reg, col_reg}<12'b010111000111)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010111000111)) color_data = 12'b101100001100;
		if(({row_reg, col_reg}==12'b010111001000)) color_data = 12'b000100100101;
		if(({row_reg, col_reg}==12'b010111001001)) color_data = 12'b010010001101;
		if(({row_reg, col_reg}>=12'b010111001010) && ({row_reg, col_reg}<12'b010111001100)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b010111001100)) color_data = 12'b010010001101;
		if(({row_reg, col_reg}==12'b010111001101)) color_data = 12'b001001001001;
		if(({row_reg, col_reg}==12'b010111001110)) color_data = 12'b001001011010;
		if(({row_reg, col_reg}==12'b010111001111)) color_data = 12'b001001101011;
		if(({row_reg, col_reg}==12'b010111010000)) color_data = 12'b001110001101;
		if(({row_reg, col_reg}>=12'b010111010001) && ({row_reg, col_reg}<12'b010111010101)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b010111010101)) color_data = 12'b100111001110;
		if(({row_reg, col_reg}>=12'b010111010110) && ({row_reg, col_reg}<12'b010111011001)) color_data = 12'b111111111110;
		if(({row_reg, col_reg}==12'b010111011001)) color_data = 12'b111111101101;
		if(({row_reg, col_reg}==12'b010111011010)) color_data = 12'b100110011001;
		if(({row_reg, col_reg}==12'b010111011011)) color_data = 12'b001100010101;
		if(({row_reg, col_reg}==12'b010111011100)) color_data = 12'b111000001110;

		if(({row_reg, col_reg}>=12'b010111011101) && ({row_reg, col_reg}<12'b011000001000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011000001000)) color_data = 12'b101100001100;
		if(({row_reg, col_reg}==12'b011000001001)) color_data = 12'b000100100101;
		if(({row_reg, col_reg}==12'b011000001010)) color_data = 12'b001001101011;
		if(({row_reg, col_reg}==12'b011000001011)) color_data = 12'b001101101100;
		if(({row_reg, col_reg}==12'b011000001100)) color_data = 12'b010010001110;
		if(({row_reg, col_reg}==12'b011000001101)) color_data = 12'b001001101011;
		if(({row_reg, col_reg}==12'b011000001110)) color_data = 12'b001001011011;
		if(({row_reg, col_reg}==12'b011000001111)) color_data = 12'b001110001101;
		if(({row_reg, col_reg}>=12'b011000010000) && ({row_reg, col_reg}<12'b011000010010)) color_data = 12'b010010011110;
		if(({row_reg, col_reg}==12'b011000010010)) color_data = 12'b010010001110;
		if(({row_reg, col_reg}==12'b011000010011)) color_data = 12'b101011001110;
		if(({row_reg, col_reg}>=12'b011000010100) && ({row_reg, col_reg}<12'b011000011000)) color_data = 12'b111111111110;
		if(({row_reg, col_reg}==12'b011000011000)) color_data = 12'b111111101101;
		if(({row_reg, col_reg}==12'b011000011001)) color_data = 12'b100110011001;
		if(({row_reg, col_reg}==12'b011000011010)) color_data = 12'b001100010101;
		if(({row_reg, col_reg}==12'b011000011011)) color_data = 12'b111000001110;

		if(({row_reg, col_reg}>=12'b011000011100) && ({row_reg, col_reg}<12'b011001001001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011001001001)) color_data = 12'b101100001100;
		if(({row_reg, col_reg}==12'b011001001010)) color_data = 12'b000000100100;
		if(({row_reg, col_reg}==12'b011001001011)) color_data = 12'b001001001001;
		if(({row_reg, col_reg}==12'b011001001100)) color_data = 12'b001001011010;
		if(({row_reg, col_reg}==12'b011001001101)) color_data = 12'b001001011011;
		if(({row_reg, col_reg}==12'b011001001110)) color_data = 12'b000100100101;
		if(({row_reg, col_reg}==12'b011001001111)) color_data = 12'b001001011010;
		if(({row_reg, col_reg}==12'b011001010000)) color_data = 12'b001110001110;
		if(({row_reg, col_reg}==12'b011001010001)) color_data = 12'b101011001110;
		if(({row_reg, col_reg}==12'b011001010010)) color_data = 12'b111111101101;
		if(({row_reg, col_reg}==12'b011001010011)) color_data = 12'b111111101110;
		if(({row_reg, col_reg}>=12'b011001010100) && ({row_reg, col_reg}<12'b011001010110)) color_data = 12'b111111111110;
		if(({row_reg, col_reg}==12'b011001010110)) color_data = 12'b111011011101;
		if(({row_reg, col_reg}==12'b011001010111)) color_data = 12'b110111001011;
		if(({row_reg, col_reg}==12'b011001011000)) color_data = 12'b100110011001;
		if(({row_reg, col_reg}==12'b011001011001)) color_data = 12'b001100010101;
		if(({row_reg, col_reg}==12'b011001011010)) color_data = 12'b110100001110;

		if(({row_reg, col_reg}>=12'b011001011011) && ({row_reg, col_reg}<12'b011010001010)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011010001010)) color_data = 12'b101100001100;
		if(({row_reg, col_reg}>=12'b011010001011) && ({row_reg, col_reg}<12'b011010001101)) color_data = 12'b000000010011;
		if(({row_reg, col_reg}==12'b011010001101)) color_data = 12'b000000100100;
		if(({row_reg, col_reg}==12'b011010001110)) color_data = 12'b101000001011;
		if(({row_reg, col_reg}==12'b011010001111)) color_data = 12'b010000010110;
		if(({row_reg, col_reg}==12'b011010010000)) color_data = 12'b000100100101;
		if(({row_reg, col_reg}==12'b011010010001)) color_data = 12'b100110011001;
		if(({row_reg, col_reg}==12'b011010010010)) color_data = 12'b111011001011;
		if(({row_reg, col_reg}==12'b011010010011)) color_data = 12'b110010111011;
		if(({row_reg, col_reg}==12'b011010010100)) color_data = 12'b101110101011;
		if(({row_reg, col_reg}==12'b011010010101)) color_data = 12'b110010111011;
		if(({row_reg, col_reg}==12'b011010010110)) color_data = 12'b100001110110;
		if(({row_reg, col_reg}==12'b011010010111)) color_data = 12'b000000100010;
		if(({row_reg, col_reg}==12'b011010011000)) color_data = 12'b001100100110;
		if(({row_reg, col_reg}==12'b011010011001)) color_data = 12'b110100001101;

		if(({row_reg, col_reg}>=12'b011010011010) && ({row_reg, col_reg}<12'b011011001011)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}>=12'b011011001011) && ({row_reg, col_reg}<12'b011011001110)) color_data = 12'b101100001100;
		if(({row_reg, col_reg}==12'b011011001110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011011001111)) color_data = 12'b001100000101;
		if(({row_reg, col_reg}==12'b011011010000)) color_data = 12'b100001100010;
		if(({row_reg, col_reg}==12'b011011010001)) color_data = 12'b101001100011;
		if(({row_reg, col_reg}==12'b011011010010)) color_data = 12'b010000110101;
		if(({row_reg, col_reg}>=12'b011011010011) && ({row_reg, col_reg}<12'b011011010101)) color_data = 12'b001000110011;
		if(({row_reg, col_reg}==12'b011011010101)) color_data = 12'b000100110011;
		if(({row_reg, col_reg}==12'b011011010110)) color_data = 12'b011000010111;
		if(({row_reg, col_reg}==12'b011011010111)) color_data = 12'b101100001100;
		if(({row_reg, col_reg}==12'b011011011000)) color_data = 12'b110000001101;

		if(({row_reg, col_reg}>=12'b011011011001) && ({row_reg, col_reg}<12'b011100001110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011100001110)) color_data = 12'b011000000111;
		if(({row_reg, col_reg}==12'b011100001111)) color_data = 12'b101001100011;
		if(({row_reg, col_reg}==12'b011100010000)) color_data = 12'b100001100010;
		if(({row_reg, col_reg}==12'b011100010001)) color_data = 12'b101101010010;
		if(({row_reg, col_reg}==12'b011100010010)) color_data = 12'b001100100001;
		if(({row_reg, col_reg}==12'b011100010011)) color_data = 12'b010000000101;
		if(({row_reg, col_reg}==12'b011100010100)) color_data = 12'b101000001011;
		if(({row_reg, col_reg}==12'b011100010101)) color_data = 12'b100000001010;
		if(({row_reg, col_reg}==12'b011100010110)) color_data = 12'b110100001101;

		if(({row_reg, col_reg}>=12'b011100010111) && ({row_reg, col_reg}<12'b011101001110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011101001110)) color_data = 12'b100100001011;
		if(({row_reg, col_reg}==12'b011101001111)) color_data = 12'b011101000011;
		if(({row_reg, col_reg}==12'b011101010000)) color_data = 12'b000000100010;
		if(({row_reg, col_reg}==12'b011101010001)) color_data = 12'b001100100001;
		if(({row_reg, col_reg}==12'b011101010010)) color_data = 12'b011100100110;
		if(({row_reg, col_reg}==12'b011101010011)) color_data = 12'b110100001110;

		if(({row_reg, col_reg}>=12'b011101010100) && ({row_reg, col_reg}<12'b011110001111)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011110001111)) color_data = 12'b100100001011;
		if(({row_reg, col_reg}==12'b011110010000)) color_data = 12'b100000001010;
		if(({row_reg, col_reg}==12'b011110010001)) color_data = 12'b011100001001;
		if(({row_reg, col_reg}==12'b011110010010)) color_data = 12'b110100001101;
		if(({row_reg, col_reg}==12'b011110010011)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011110010100)) color_data = 12'b111000001111;










		if(({row_reg, col_reg}>=12'b011110010101) && ({row_reg, col_reg}<=12'b100111100111)) color_data = 12'b111100001111;
	end
endmodule