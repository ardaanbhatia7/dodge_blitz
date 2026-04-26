module spaceship_rom
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









		if(({row_reg, col_reg}>=12'b000000000000) && ({row_reg, col_reg}<12'b001001010010)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}>=12'b001001010010) && ({row_reg, col_reg}<12'b001001010110)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b001001010110) && ({row_reg, col_reg}<12'b001010010000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}>=12'b001010010000) && ({row_reg, col_reg}<12'b001010010010)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}>=12'b001010010010) && ({row_reg, col_reg}<12'b001010010110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}>=12'b001010010110) && ({row_reg, col_reg}<12'b001010011000)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b001010011000) && ({row_reg, col_reg}<12'b001011001111)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001011001111)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}>=12'b001011010000) && ({row_reg, col_reg}<12'b001011010010)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001011010010)) color_data = 12'b110000001011;
		if(({row_reg, col_reg}>=12'b001011010011) && ({row_reg, col_reg}<12'b001011010101)) color_data = 12'b101000001010;
		if(({row_reg, col_reg}==12'b001011010101)) color_data = 12'b110000001011;
		if(({row_reg, col_reg}>=12'b001011010110) && ({row_reg, col_reg}<12'b001011011000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001011011000)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b001011011001) && ({row_reg, col_reg}<12'b001100001110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001100001110)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}==12'b001100001111)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001100010000)) color_data = 12'b110000001011;
		if(({row_reg, col_reg}==12'b001100010001)) color_data = 12'b011100000111;
		if(({row_reg, col_reg}>=12'b001100010010) && ({row_reg, col_reg}<12'b001100010110)) color_data = 12'b001101010101;
		if(({row_reg, col_reg}==12'b001100010110)) color_data = 12'b011100000111;
		if(({row_reg, col_reg}==12'b001100010111)) color_data = 12'b110000001011;
		if(({row_reg, col_reg}==12'b001100011000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001100011001)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b001100011010) && ({row_reg, col_reg}<12'b001101001101)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001101001101)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}==12'b001101001110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001101001111)) color_data = 12'b110000001011;
		if(({row_reg, col_reg}==12'b001101010000)) color_data = 12'b001000110101;
		if(({row_reg, col_reg}==12'b001101010001)) color_data = 12'b001110001000;
		if(({row_reg, col_reg}==12'b001101010010)) color_data = 12'b110011111111;
		if(({row_reg, col_reg}>=12'b001101010011) && ({row_reg, col_reg}<12'b001101010101)) color_data = 12'b100011101111;
		if(({row_reg, col_reg}==12'b001101010101)) color_data = 12'b011111011111;
		if(({row_reg, col_reg}==12'b001101010110)) color_data = 12'b001110001000;
		if(({row_reg, col_reg}==12'b001101010111)) color_data = 12'b001000110101;
		if(({row_reg, col_reg}==12'b001101011000)) color_data = 12'b110000001011;
		if(({row_reg, col_reg}==12'b001101011001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001101011010)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b001101011011) && ({row_reg, col_reg}<12'b001110001100)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001110001100)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}==12'b001110001101)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001110001110)) color_data = 12'b110100001101;
		if(({row_reg, col_reg}==12'b001110001111)) color_data = 12'b001000110101;
		if(({row_reg, col_reg}==12'b001110010000)) color_data = 12'b011111011111;
		if(({row_reg, col_reg}==12'b001110010001)) color_data = 12'b111011111111;
		if(({row_reg, col_reg}==12'b001110010010)) color_data = 12'b100111011111;
		if(({row_reg, col_reg}>=12'b001110010011) && ({row_reg, col_reg}<12'b001110010110)) color_data = 12'b011011001111;
		if(({row_reg, col_reg}==12'b001110010110)) color_data = 12'b011111011111;
		if(({row_reg, col_reg}==12'b001110010111)) color_data = 12'b001010111110;
		if(({row_reg, col_reg}==12'b001110011000)) color_data = 12'b001000110101;
		if(({row_reg, col_reg}==12'b001110011001)) color_data = 12'b110000001011;
		if(({row_reg, col_reg}==12'b001110011010)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001110011011)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b001110011100) && ({row_reg, col_reg}<12'b001111001011)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001111001011)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}>=12'b001111001100) && ({row_reg, col_reg}<12'b001111001110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001111001110)) color_data = 12'b101000001010;
		if(({row_reg, col_reg}==12'b001111001111)) color_data = 12'b000001010111;
		if(({row_reg, col_reg}==12'b001111010000)) color_data = 12'b011111011111;
		if(({row_reg, col_reg}==12'b001111010001)) color_data = 12'b100111011111;
		if(({row_reg, col_reg}>=12'b001111010010) && ({row_reg, col_reg}<12'b001111010111)) color_data = 12'b011011001111;
		if(({row_reg, col_reg}==12'b001111010111)) color_data = 12'b001110101101;
		if(({row_reg, col_reg}==12'b001111011000)) color_data = 12'b000001000101;
		if(({row_reg, col_reg}==12'b001111011001)) color_data = 12'b100100001001;
		if(({row_reg, col_reg}>=12'b001111011010) && ({row_reg, col_reg}<12'b001111011100)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b001111011100)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b001111011101) && ({row_reg, col_reg}<12'b010000001100)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010000001100)) color_data = 12'b110100001101;
		if(({row_reg, col_reg}==12'b010000001101)) color_data = 12'b100100001001;
		if(({row_reg, col_reg}==12'b010000001110)) color_data = 12'b000100010011;
		if(({row_reg, col_reg}==12'b010000001111)) color_data = 12'b001010111110;
		if(({row_reg, col_reg}>=12'b010000010000) && ({row_reg, col_reg}<12'b010000010010)) color_data = 12'b001111001111;
		if(({row_reg, col_reg}>=12'b010000010010) && ({row_reg, col_reg}<12'b010000010110)) color_data = 12'b011011011111;
		if(({row_reg, col_reg}==12'b010000010110)) color_data = 12'b001111001111;
		if(({row_reg, col_reg}==12'b010000010111)) color_data = 12'b001110101101;
		if(({row_reg, col_reg}==12'b010000011000)) color_data = 12'b001110001100;
		if(({row_reg, col_reg}==12'b010000011001)) color_data = 12'b000100010011;
		if(({row_reg, col_reg}==12'b010000011010)) color_data = 12'b100100001001;
		if(({row_reg, col_reg}==12'b010000011011)) color_data = 12'b110100001101;

		if(({row_reg, col_reg}>=12'b010000011100) && ({row_reg, col_reg}<12'b010001001000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010001001000)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}==12'b010001001001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010001001010)) color_data = 12'b111000001110;
		if(({row_reg, col_reg}==12'b010001001011)) color_data = 12'b011100000111;
		if(({row_reg, col_reg}==12'b010001001100)) color_data = 12'b011000110110;
		if(({row_reg, col_reg}==12'b010001001101)) color_data = 12'b010101010100;
		if(({row_reg, col_reg}==12'b010001001110)) color_data = 12'b010001000100;
		if(({row_reg, col_reg}==12'b010001001111)) color_data = 12'b000001000101;
		if(({row_reg, col_reg}>=12'b010001010000) && ({row_reg, col_reg}<12'b010001010111)) color_data = 12'b000001010111;
		if(({row_reg, col_reg}>=12'b010001010111) && ({row_reg, col_reg}<12'b010001011001)) color_data = 12'b000001000101;
		if(({row_reg, col_reg}==12'b010001011001)) color_data = 12'b001000110011;
		if(({row_reg, col_reg}==12'b010001011010)) color_data = 12'b000100100001;
		if(({row_reg, col_reg}==12'b010001011011)) color_data = 12'b010100010101;
		if(({row_reg, col_reg}==12'b010001011100)) color_data = 12'b100000001000;
		if(({row_reg, col_reg}==12'b010001011101)) color_data = 12'b111000001110;
		if(({row_reg, col_reg}==12'b010001011110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010001011111)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b010001100000) && ({row_reg, col_reg}<12'b010010001001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010010001001)) color_data = 12'b111000001110;
		if(({row_reg, col_reg}==12'b010010001010)) color_data = 12'b010100010101;
		if(({row_reg, col_reg}==12'b010010001011)) color_data = 12'b010101100101;
		if(({row_reg, col_reg}==12'b010010001100)) color_data = 12'b100110011001;
		if(({row_reg, col_reg}==12'b010010001101)) color_data = 12'b101110111011;
		if(({row_reg, col_reg}==12'b010010001110)) color_data = 12'b101010101010;
		if(({row_reg, col_reg}>=12'b010010001111) && ({row_reg, col_reg}<12'b010010010110)) color_data = 12'b011101110111;
		if(({row_reg, col_reg}>=12'b010010010110) && ({row_reg, col_reg}<12'b010010011001)) color_data = 12'b010101010100;
		if(({row_reg, col_reg}==12'b010010011001)) color_data = 12'b011101110111;
		if(({row_reg, col_reg}==12'b010010011010)) color_data = 12'b100010001000;
		if(({row_reg, col_reg}==12'b010010011011)) color_data = 12'b011001100110;
		if(({row_reg, col_reg}==12'b010010011100)) color_data = 12'b001101000011;
		if(({row_reg, col_reg}==12'b010010011101)) color_data = 12'b010100010101;
		if(({row_reg, col_reg}==12'b010010011110)) color_data = 12'b111000001110;

		if(({row_reg, col_reg}>=12'b010010011111) && ({row_reg, col_reg}<12'b010011001001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010011001001)) color_data = 12'b010100010101;
		if(({row_reg, col_reg}==12'b010011001010)) color_data = 12'b100010001000;
		if(({row_reg, col_reg}==12'b010011001011)) color_data = 12'b101010101010;
		if(({row_reg, col_reg}>=12'b010011001100) && ({row_reg, col_reg}<12'b010011001110)) color_data = 12'b100010001000;
		if(({row_reg, col_reg}==12'b010011001110)) color_data = 12'b100110011001;
		if(({row_reg, col_reg}>=12'b010011001111) && ({row_reg, col_reg}<12'b010011010001)) color_data = 12'b101010111011;
		if(({row_reg, col_reg}==12'b010011010001)) color_data = 12'b101110111011;
		if(({row_reg, col_reg}>=12'b010011010010) && ({row_reg, col_reg}<12'b010011010101)) color_data = 12'b101010111011;
		if(({row_reg, col_reg}==12'b010011010101)) color_data = 12'b101010101010;
		if(({row_reg, col_reg}==12'b010011010110)) color_data = 12'b100110011001;
		if(({row_reg, col_reg}==12'b010011010111)) color_data = 12'b100010001000;
		if(({row_reg, col_reg}==12'b010011011000)) color_data = 12'b100110011001;
		if(({row_reg, col_reg}>=12'b010011011001) && ({row_reg, col_reg}<12'b010011011011)) color_data = 12'b011101110111;
		if(({row_reg, col_reg}==12'b010011011011)) color_data = 12'b011001100110;
		if(({row_reg, col_reg}==12'b010011011100)) color_data = 12'b011101110111;
		if(({row_reg, col_reg}==12'b010011011101)) color_data = 12'b010101010101;
		if(({row_reg, col_reg}==12'b010011011110)) color_data = 12'b010100010101;
		if(({row_reg, col_reg}==12'b010011011111)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b010011100000) && ({row_reg, col_reg}<12'b010100000110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010100000110)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}==12'b010100000111)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010100001000)) color_data = 12'b010100000101;
		if(({row_reg, col_reg}==12'b010100001001)) color_data = 12'b011101110111;
		if(({row_reg, col_reg}==12'b010100001010)) color_data = 12'b101010101010;
		if(({row_reg, col_reg}>=12'b010100001011) && ({row_reg, col_reg}<12'b010100001101)) color_data = 12'b011110100101;
		if(({row_reg, col_reg}>=12'b010100001101) && ({row_reg, col_reg}<12'b010100010000)) color_data = 12'b100110011001;
		if(({row_reg, col_reg}==12'b010100010000)) color_data = 12'b010101010101;
		if(({row_reg, col_reg}==12'b010100010001)) color_data = 12'b010010010010;
		if(({row_reg, col_reg}==12'b010100010010)) color_data = 12'b010101100101;
		if(({row_reg, col_reg}>=12'b010100010011) && ({row_reg, col_reg}<12'b010100010101)) color_data = 12'b100010001000;
		if(({row_reg, col_reg}==12'b010100010101)) color_data = 12'b010101100101;
		if(({row_reg, col_reg}==12'b010100010110)) color_data = 12'b010010010010;
		if(({row_reg, col_reg}==12'b010100010111)) color_data = 12'b010001000100;
		if(({row_reg, col_reg}>=12'b010100011000) && ({row_reg, col_reg}<12'b010100011011)) color_data = 12'b011101110111;
		if(({row_reg, col_reg}>=12'b010100011011) && ({row_reg, col_reg}<12'b010100011101)) color_data = 12'b010010010010;
		if(({row_reg, col_reg}==12'b010100011101)) color_data = 12'b011001100110;
		if(({row_reg, col_reg}==12'b010100011110)) color_data = 12'b010001100100;
		if(({row_reg, col_reg}==12'b010100011111)) color_data = 12'b010100000101;
		if(({row_reg, col_reg}==12'b010100100000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010100100001)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b010100100010) && ({row_reg, col_reg}<12'b010101000110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010101000110)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}==12'b010101000111)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010101001000)) color_data = 12'b011100000111;
		if(({row_reg, col_reg}==12'b010101001001)) color_data = 12'b000100100001;
		if(({row_reg, col_reg}==12'b010101001010)) color_data = 12'b001101000011;
		if(({row_reg, col_reg}>=12'b010101001011) && ({row_reg, col_reg}<12'b010101001111)) color_data = 12'b011101110111;
		if(({row_reg, col_reg}==12'b010101001111)) color_data = 12'b100010001000;
		if(({row_reg, col_reg}==12'b010101010000)) color_data = 12'b011001100110;
		if(({row_reg, col_reg}==12'b010101010001)) color_data = 12'b001101000011;
		if(({row_reg, col_reg}==12'b010101010010)) color_data = 12'b011001100110;
		if(({row_reg, col_reg}>=12'b010101010011) && ({row_reg, col_reg}<12'b010101010101)) color_data = 12'b100110011001;
		if(({row_reg, col_reg}==12'b010101010101)) color_data = 12'b011101110111;
		if(({row_reg, col_reg}==12'b010101010110)) color_data = 12'b001101000011;
		if(({row_reg, col_reg}==12'b010101010111)) color_data = 12'b010101010100;
		if(({row_reg, col_reg}==12'b010101011000)) color_data = 12'b011101110111;
		if(({row_reg, col_reg}>=12'b010101011001) && ({row_reg, col_reg}<12'b010101011011)) color_data = 12'b011001100110;
		if(({row_reg, col_reg}==12'b010101011011)) color_data = 12'b010101010101;
		if(({row_reg, col_reg}==12'b010101011100)) color_data = 12'b010101010100;
		if(({row_reg, col_reg}==12'b010101011101)) color_data = 12'b001000110011;
		if(({row_reg, col_reg}==12'b010101011110)) color_data = 12'b000100100001;
		if(({row_reg, col_reg}==12'b010101011111)) color_data = 12'b011100000111;
		if(({row_reg, col_reg}==12'b010101100000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010101100001)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b010101100010) && ({row_reg, col_reg}<12'b010110001001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010110001001)) color_data = 12'b100000001000;
		if(({row_reg, col_reg}==12'b010110001010)) color_data = 12'b010000000100;
		if(({row_reg, col_reg}>=12'b010110001011) && ({row_reg, col_reg}<12'b010110001101)) color_data = 12'b000100100010;
		if(({row_reg, col_reg}>=12'b010110001101) && ({row_reg, col_reg}<12'b010110001111)) color_data = 12'b010001000100;
		if(({row_reg, col_reg}==12'b010110001111)) color_data = 12'b010101010101;
		if(({row_reg, col_reg}>=12'b010110010000) && ({row_reg, col_reg}<12'b010110010110)) color_data = 12'b011101110111;
		if(({row_reg, col_reg}>=12'b010110010110) && ({row_reg, col_reg}<12'b010110011000)) color_data = 12'b011001100110;
		if(({row_reg, col_reg}==12'b010110011000)) color_data = 12'b010101010100;
		if(({row_reg, col_reg}>=12'b010110011001) && ({row_reg, col_reg}<12'b010110011011)) color_data = 12'b010001000100;
		if(({row_reg, col_reg}==12'b010110011011)) color_data = 12'b000100100010;
		if(({row_reg, col_reg}==12'b010110011100)) color_data = 12'b000100100001;
		if(({row_reg, col_reg}==12'b010110011101)) color_data = 12'b010000000100;
		if(({row_reg, col_reg}==12'b010110011110)) color_data = 12'b100000001000;

		if(({row_reg, col_reg}>=12'b010110011111) && ({row_reg, col_reg}<12'b010111001000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010111001000)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}==12'b010111001001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010111001010)) color_data = 12'b111000001110;
		if(({row_reg, col_reg}==12'b010111001011)) color_data = 12'b100100001001;
		if(({row_reg, col_reg}==12'b010111001100)) color_data = 12'b001000000010;
		if(({row_reg, col_reg}==12'b010111001101)) color_data = 12'b000000010000;
		if(({row_reg, col_reg}>=12'b010111001110) && ({row_reg, col_reg}<12'b010111010000)) color_data = 12'b000100010001;
		if(({row_reg, col_reg}==12'b010111010000)) color_data = 12'b000100100010;
		if(({row_reg, col_reg}>=12'b010111010001) && ({row_reg, col_reg}<12'b010111010111)) color_data = 12'b001000100010;
		if(({row_reg, col_reg}==12'b010111010111)) color_data = 12'b000100100010;
		if(({row_reg, col_reg}>=12'b010111011000) && ({row_reg, col_reg}<12'b010111011010)) color_data = 12'b000100010001;
		if(({row_reg, col_reg}==12'b010111011010)) color_data = 12'b000000010000;
		if(({row_reg, col_reg}==12'b010111011011)) color_data = 12'b001000000010;
		if(({row_reg, col_reg}==12'b010111011100)) color_data = 12'b100100001001;
		if(({row_reg, col_reg}==12'b010111011101)) color_data = 12'b111000001110;
		if(({row_reg, col_reg}==12'b010111011110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b010111011111)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b010111100000) && ({row_reg, col_reg}<12'b011000001001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011000001001)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}>=12'b011000001010) && ({row_reg, col_reg}<12'b011000001100)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011000001100)) color_data = 12'b111000001110;
		if(({row_reg, col_reg}==12'b011000001101)) color_data = 12'b001000000010;
		if(({row_reg, col_reg}==12'b011000001110)) color_data = 12'b000100100001;
		if(({row_reg, col_reg}==12'b011000001111)) color_data = 12'b000100010001;
		if(({row_reg, col_reg}==12'b011000010000)) color_data = 12'b000000000000;
		if(({row_reg, col_reg}==12'b011000010001)) color_data = 12'b000100010001;
		if(({row_reg, col_reg}>=12'b011000010010) && ({row_reg, col_reg}<12'b011000010110)) color_data = 12'b001000100010;
		if(({row_reg, col_reg}==12'b011000010110)) color_data = 12'b000100010001;
		if(({row_reg, col_reg}==12'b011000010111)) color_data = 12'b000000000000;
		if(({row_reg, col_reg}==12'b011000011000)) color_data = 12'b000000010000;
		if(({row_reg, col_reg}==12'b011000011001)) color_data = 12'b000100100001;
		if(({row_reg, col_reg}==12'b011000011010)) color_data = 12'b000000000000;
		if(({row_reg, col_reg}==12'b011000011011)) color_data = 12'b110100001101;
		if(({row_reg, col_reg}>=12'b011000011100) && ({row_reg, col_reg}<12'b011000011110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011000011110)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b011000011111) && ({row_reg, col_reg}<12'b011001001011)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011001001011)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}==12'b011001001100)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011001001101)) color_data = 12'b010100010101;
		if(({row_reg, col_reg}==12'b011001001110)) color_data = 12'b011011000100;
		if(({row_reg, col_reg}==12'b011001001111)) color_data = 12'b001001110001;
		if(({row_reg, col_reg}==12'b011001010000)) color_data = 12'b100100001001;
		if(({row_reg, col_reg}==12'b011001010001)) color_data = 12'b010100000101;
		if(({row_reg, col_reg}==12'b011001010010)) color_data = 12'b000000010000;
		if(({row_reg, col_reg}>=12'b011001010011) && ({row_reg, col_reg}<12'b011001010101)) color_data = 12'b010001100100;
		if(({row_reg, col_reg}==12'b011001010101)) color_data = 12'b000000010000;
		if(({row_reg, col_reg}==12'b011001010110)) color_data = 12'b010000000100;
		if(({row_reg, col_reg}==12'b011001010111)) color_data = 12'b100100001001;
		if(({row_reg, col_reg}==12'b011001011000)) color_data = 12'b010001100100;
		if(({row_reg, col_reg}==12'b011001011001)) color_data = 12'b011011000100;
		if(({row_reg, col_reg}==12'b011001011010)) color_data = 12'b010000000100;
		if(({row_reg, col_reg}==12'b011001011011)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}>=12'b011001011100) && ({row_reg, col_reg}<12'b011001011110)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b011001011110) && ({row_reg, col_reg}<12'b011010001101)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011010001101)) color_data = 12'b111000001110;
		if(({row_reg, col_reg}==12'b011010001110)) color_data = 12'b010000000100;
		if(({row_reg, col_reg}==12'b011010001111)) color_data = 12'b100000001000;
		if(({row_reg, col_reg}==12'b011010010000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011010010001)) color_data = 12'b111000001110;
		if(({row_reg, col_reg}==12'b011010010010)) color_data = 12'b010100010101;
		if(({row_reg, col_reg}>=12'b011010010011) && ({row_reg, col_reg}<12'b011010010101)) color_data = 12'b010010100011;
		if(({row_reg, col_reg}==12'b011010010101)) color_data = 12'b001000100010;
		if(({row_reg, col_reg}==12'b011010010110)) color_data = 12'b111000001110;
		if(({row_reg, col_reg}==12'b011010010111)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011010011000)) color_data = 12'b100100001001;
		if(({row_reg, col_reg}==12'b011010011001)) color_data = 12'b010000000100;
		if(({row_reg, col_reg}==12'b011010011010)) color_data = 12'b111000001110;

		if(({row_reg, col_reg}>=12'b011010011011) && ({row_reg, col_reg}<12'b011011010000)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011011010000)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}==12'b011011010001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011011010010)) color_data = 12'b111000001110;
		if(({row_reg, col_reg}>=12'b011011010011) && ({row_reg, col_reg}<12'b011011010101)) color_data = 12'b011000000110;
		if(({row_reg, col_reg}==12'b011011010101)) color_data = 12'b111000001110;
		if(({row_reg, col_reg}==12'b011011010110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011011010111)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b011011011000) && ({row_reg, col_reg}<12'b011100001110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011100001110)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}>=12'b011100001111) && ({row_reg, col_reg}<12'b011100010110)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011100010110)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}>=12'b011100010111) && ({row_reg, col_reg}<12'b011100011001)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011100011001)) color_data = 12'b111000001111;

		if(({row_reg, col_reg}>=12'b011100011010) && ({row_reg, col_reg}<12'b011101001101)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}==12'b011101001101)) color_data = 12'b111000001111;
		if(({row_reg, col_reg}>=12'b011101001110) && ({row_reg, col_reg}<12'b011101010011)) color_data = 12'b111100001111;
		if(({row_reg, col_reg}>=12'b011101010011) && ({row_reg, col_reg}<12'b011101010101)) color_data = 12'b111000001111;











		if(({row_reg, col_reg}>=12'b011101010101) && ({row_reg, col_reg}<=12'b100111100111)) color_data = 12'b111100001111;
	end
endmodule