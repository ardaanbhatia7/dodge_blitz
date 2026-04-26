`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:18:00 12/14/2017 
// Design Name: 
// Module Name:    vga_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
// Date: 04/04/2020
// Author: Yue (Julien) Niu
// Description: Port from NEXYS3 to NEXYS4
//////////////////////////////////////////////////////////////////////////////////
module vga_top(
	input ClkPort,
	input BtnC,
	input BtnU,
	input ACL_MISO,
	output ACL_MOSI,
	output ACL_SCLK,
	output ACL_CSN,
	output [2:0] LED,

	//VGA signal
	output hSync, vSync,
	output [3:0] vgaR, vgaG, vgaB,
	
	//SSG signal 
	output An0, An1, An2, An3, An4, An5, An6, An7,
	output Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,
	
	//output MemOE, MemWR, RamCS, 
	output QuadSpiFlashCS
	);
	
	wire bright;
	wire[9:0] hc, vc;
	wire[15:0] score;
	wire [6:0] ssdOut;
	wire [3:0] anode;
	wire [11:0] rgb;
	wire signed [15:0] accel_y;
	wire tilt_left;
	wire tilt_right;
	wire tilt_neutral;

	accelerometer_reader accel(
		.clk(ClkPort),
		.reset(BtnC),
		.ACL_MISO(ACL_MISO),
		.ACL_MOSI(ACL_MOSI),
		.ACL_SCLK(ACL_SCLK),
		.ACL_CSN(ACL_CSN),
		.accel_y(accel_y),
		.tilt_left(tilt_left),
		.tilt_right(tilt_right),
		.tilt_neutral(tilt_neutral)
	);

	display_controller dc(
		.clk(ClkPort),
		.tilt_left(tilt_left),
		.tilt_right(tilt_right),
		.tilt_neutral(tilt_neutral),
		.reset(BtnC),
		.hSync(hSync),
		.vSync(vSync),
		.bright(bright),
		.hCount(hc),
		.vCount(vc),
		.rgb(rgb),
		.score(score)
	);
	counter cnt(.clk(ClkPort), .displayNumber(score), .anode(anode), .ssdOut(ssdOut));
	
	assign Dp = 1;
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg} = ssdOut[6 : 0];
    assign {An7, An6, An5, An4, An3, An2, An1, An0} = {4'b1111, anode};

	
	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];
	assign LED[0] = tilt_left;
	assign LED[1] = tilt_right;
	assign LED[2] = tilt_neutral;
	
	// disable mamory ports
	//assign {MemOE, MemWR, RamCS, QuadSpiFlashCS} = 4'b1111;
	assign QuadSpiFlashCS = 1'b1;

endmodule
