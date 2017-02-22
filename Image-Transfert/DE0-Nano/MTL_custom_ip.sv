


`timescale 1 ps / 1 ps
module MTL_custom_ip (
		input  wire [7:0]  avs_s0_address,     // avs_s0.address
		input  wire        avs_s0_read,        //       .read
		output wire [31:0] avs_s0_readdata,    //       .readdata
		input  wire        avs_s0_write,       //       .write
		input  wire [31:0] avs_s0_writedata,   //       .writedata
		output wire        avs_s0_waitrequest, //       .waitrequest
		input  wire        clock_clk,          //  clock.clk
		input  wire        reset_reset,        //  reset.reset
		output wire 	   MTL_DCLK,
		output wire        MTL_HSD,
		output wire	   MTL_VSD,
		output wire	   MTL_TOUCH_I2C_SCL,
		inout  wire	   MTL_TOUCH_I2C_SDA,
		input  wire	   MTL_TOUCH_INT_n,
		output wire [7:0]  MTL_R,
		output wire [7:0]  MTL_G,
		output wire [7:0]  MTL_B,

		output wire [12:0] DRAM_ADDR,
		output wire [1:0]  DRAM_BA,
		output wire        DRAM_CAS_N,
		output wire        DRAM_CKE,
		output wire	   DRAM_CLK,
		output wire	   DRAM_CS_N,
		inout  wire [15:0] DRAM_DQ,
		output wire [1:0]  DRAM_DQM,
		output wire        DRAM_RAS_N,
		output wire        DRAM_WE_N,

		input  wire        iSPI_CLK,		// SPI clock
		input  wire	   iSPI_CS,			// SPI chip select
	    	input  wire 	   iSPI_MOSI,		// SPI MOSI (from Rasp-Pi)
	 	output wire 	   oSPI_MISO		// SPI MISO (to Rasp-Pi)
);

















endmodule
