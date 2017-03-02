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
	
	reg [31:0] readdata;

	reg [9:0] iX1, iX2, iX3, iX4, iX5, iX6, iX7, iX8, iX9, iX10;
	reg [8:0] iY1, iY2, iY3, iY4, iY5, iY6, iY7, iY8, iY9, iY10;
	
	reg [9:0] oX1, oX2, oX3, oX4, oX5;
	reg [8:0] oY1, oY2, oY3, oY4, oY5;
	
	reg [3:0] oCount;
	
	always @(posedge clock_clk) begin
	
		if (avs_s0_write)
			case(avs_s0_address)
			8'h01:begin 
						iX1 <= avs_s0_writedata[9:0];
						iY1 <= avs_s0_writedata[18:10];
					end
			8'h02:begin 
						iX2 <= avs_s0_writedata[9:0];
						iY2 <= avs_s0_writedata[18:10];
					end
			8'h03:begin 
						iX3 <= avs_s0_writedata[9:0];
						iY3 <= avs_s0_writedata[18:10];
					end
			8'h04:begin 
						iX4 <= avs_s0_writedata[9:0];
						iY4 <= avs_s0_writedata[18:10];
					end
			8'h05:begin 
						iX5 <= avs_s0_writedata[9:0];
						iY5 <= avs_s0_writedata[18:10];
					end
			8'h06:begin 
						iX6 <= avs_s0_writedata[9:0];
						iY6 <= avs_s0_writedata[18:10];
					end
			8'h07:begin 
						iX7 <= avs_s0_writedata[9:0];
						iY7 <= avs_s0_writedata[18:10];
					end
			8'h08:begin 
						iX8 <= avs_s0_writedata[9:0];
						iY8 <= avs_s0_writedata[18:10];
					end
			8'h09:begin 
						iX9 <= avs_s0_writedata[9:0];
						iY9 <= avs_s0_writedata[18:10];
					end
			8'h0A:begin 
						iX10 <= avs_s0_writedata[9:0];
						iY10 <= avs_s0_writedata[18:10];
					end
			endcase
		if (avs_s0_read) begin
			case(avs_s0_address)
				8'h00: readdata <= {28'b0,oCount};
				8'h01: readdata <= {13'b0,oY1,oX1};
				8'h02: readdata <= {13'b0,oY2,oX2};
				8'h03: readdata <= {13'b0,oY3,oX3};
				8'h04: readdata <= {13'b0,oY4,oX4};
				8'h05: readdata <= {13'b0,oY5,oX5};
			endcase 
		end	
	end
	
	assign avs_s0_readdata = readdata;
	assign avs_s0_waitrequest = 1'b0;
	
	
	mtl_controller (
	.iCLK(clock_clk),
	.iRST(RST_DLY),
	// MTL
	.MTL_DCLK(MTL_DCLK),							// LCD Display clock (to MTL)
	.MTL_HSD(MTL_HSD),							// LCD horizontal sync (to MTL) 
	.MTL_VSD(MTL_VSD),							// LCD vertical sync (to MTL)
	.MTL_TOUCH_I2C_SCL(MTL_TOUCH_I2C_SCL), // I2C clock pin of Touch IC (from MTL)
	.MTL_TOUCH_I2C_SDA(MTL_TOUCH_I2C_SDA), // I2C data pin of Touch IC (from/to MTL)
	.MTL_TOUCH_INT_n(MTL_TOUCH_INT_n),     // Interrupt pin of Touch IC (from MTL)
	.MTL_R(MTL_R),									// LCD red color data  (to MTL)
	.MTL_G(MTL_G),									// LCD green color data (to MTL)
	.MTL_B(MTL_B), 									// LCD blue color data (to MTL)
	.iX1(iX1),
	.iX2(iX2),
	.iX3(iX3),
	.iX4(iX4),
	.iX5(iX5),
	.iX6(iX6),
	.iX7(iX7),
	.iX8(iX8),
	.iX9(iX9),
	.iX10(iX10),
	.iY1(iY1),
	.iY2(iY2),
	.iY3(iY3),
	.iY4(iY4),
	.iY5(iY5),
	.iY6(iY6),
	.iY7(iY7),
	.iY8(iY8),
	.iY9(iY9),
	.iY10(iY10),
	.oX1(oX1),
	.oX2(oX2),
	.oX3(oX3),
	.oX4(oX4),
	.oX5(ox5),
	.oY1(oY1),
	.oY2(oY2),
	.oY3(oY3),
	.oY4(oY4),
	.oY5(oY5),
	.oCount(oCount)
);

endmodule

