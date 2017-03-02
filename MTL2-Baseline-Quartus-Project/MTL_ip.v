// MTL_ip.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module MTL_ip (
		input  wire [7:0]  avs_s0_address,     //                s0.address
		input  wire        avs_s0_read,        //                  .read
		output wire [31:0] avs_s0_readdata,    //                  .readdata
		input  wire        avs_s0_write,       //                  .write
		input  wire [31:0] avs_s0_writedata,   //                  .writedata
		output wire        avs_s0_waitrequest, //                  .waitrequest
		input  wire        reset_reset,        //        reset_sink.reset_n
		input  wire        clock_clk,          //        clock_sink.clk
		output wire        MTL_DCLK,           //          MTL_DCLK.export
		output wire        MTL_HSD,            //           MTL_HSD.export
		output wire        MTL_VSD,            //           MTL_VSD.export
		output wire        MTL_TOUCH_I2C_SCL,  // MTL_TOUCH_I2C_SCL.export
		inout  wire        MTL_TOUCH_I2C_SDA,  // MTL_TOUCH_I2C_SDA.export
		input  wire        MTL_TOUCH_INT_n,    //   MTL_TOUCH_INT_n.export
		output wire [7:0]  MTL_R,              //             MTL_R.export
		output wire [7:0]  MTL_G,              //             MTL_G.export
		output wire [7:0]  MTL_B,              //             MTL_B.export
		input  wire        RST_DLY             //           RST_DLY.export
	);

	// TODO: Auto-generated HDL template

	assign avs_s0_readdata = 32'b00000000000000000000000000000000;

	assign avs_s0_waitrequest = 1'b0;

	assign MTL_DCLK = 1'b0;

	assign MTL_HSD = 1'b0;

	assign MTL_VSD = 1'b0;

	assign MTL_TOUCH_I2C_SCL = 1'b0;

	assign MTL_R = 8'b00000000;

	assign MTL_G = 8'b00000000;

	assign MTL_B = 8'b00000000;

endmodule
