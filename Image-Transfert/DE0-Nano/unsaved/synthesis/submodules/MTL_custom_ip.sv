


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



	// System clock & reset
	
	logic 			CLK_50, RST, CLK_33;
	logic 			dly_rstn, rd_rst, dly_rst;
	
	// MMU - MTL
	
	logic [31:0]	SDRAM_RData1, SDRAM_RData2;
	logic 			SDRAM_REn1, SDRAM_REn2;
	logic				New_Frame, End_Frame;
	
	logic 			Gest_W, Gest_E;
	logic 			Loading;
	
	// Pixel's RGB data
	
	logic				Trigger;
	logic [7:0] 	Img_Tot;
	logic [23:0] 	Pix_Data;		
	
	// SPI 
	
	logic 			spi_clk, spi_cs, spi_mosi, spi_miso;
	logic [31:0]	spi_data;
	
	logic [31:0]	spi_write_data, spi_write_address;
	logic				spi_write_enable;

	
	

	//==================================================================================
	// Avalon registers
	//==================================================================================
	
	reg [9:0] iX1, iX2, iX3, iX4, iX5;
	reg [8:0] iY1, iY2, iY3, iY4, iY5;
	
	reg [9:0] oX1, oX2, oX3;
	reg [8:0] oY1, oY2, oY3;
	
	
	
	always_ff @(posedge clock_clk) begin
	
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
			//default: ix1 <= x;		
			endcase
		if (avs_s0_read) begin
			case(avs_s0_address)
				8'h01: avs_s0_readdata <= {13'b0,oY1,oX1};
				8'h02: avs_s0_readdata <= {13'b0,oY2,oX2};
				8'h03: avs_s0_readdata <= {13'b0,oY3,oX3};
			endcase 
		end	
	end

	//==================================================================================
	// Structural coding
	//==================================================================================
	
	assign LED = {7'd0,Loading};

	/**************************/
	/*  System Clock & Reset  */
	/**************************/
	 
	assign CLK_50 = clock_clk;

	assign RST = reset_reset;		// Synchronous system reset from R-Pi
		
	// A good synchronization of all the resets of the different components must be 
	// carried out. Otherwise, some random bugs risk to appear after a reset of the 
	// system (see definition of the module at the end of this file).
	reset_delay	reset_delay_inst (		
		.iRSTN(RST),
		.iCLK(clock_clk),
		.oRSTN(dly_rstn),
		.oRD_RST(rd_rst),
		.oRST(dly_rst)
	);
	
	reset_finish reset_finish_inst(
		.iCLK(clock_clk),
		.iRSTN(dly_rstn),
		.iRD_RST(rd_rst),
		.iRST(dly_rst),
		.oData_WE(spi_write_enable),
		.oData_Addr(spi_write_address),
		.oData_Write(spi_write_data)
	);
	
	/****************************/
	/*  Memory Management Unit  */
	/****************************/
	
	mmu mmu_inst(
		.iCLK_50(CLK_50),									// System Clock (50MHz)
		.iCLK_33(CLK_33),									// MTL Clock (33 MHz, 0°)
		.iRST(dly_rst),									// System sync reset
		.iRd_RST(rd_rst),
		// SPI
		.iPix_Data(Pix_Data),							// Pixel's data from R-Pi (24-bit RGB)
		.iImg_Tot(Img_Tot),								// Total number of images transferred from Rasp-Pi
		.iTrigger(Trigger),								// Short pulse that is raised each time a whole pixel has been
																// received by the spi slave interface. Trigger enables writing 
																// the pixel to the SDRAM.
		// MTL
		.iGest_W(Gest_W),
		.iGest_E(Gest_E),
		.iNew_Frame(New_Frame),							// Control signal being a pulse when a new frame of the LCD begins
		.iEnd_Frame(End_Frame),							// Control signal being a pulse when a frame of the LCD ends
		.oLoading(Loading),								// Control signal telling in which loading state is the system
		.oRead_Data1(SDRAM_RData1),  					// Data 1 (RGB) from SDRAM to MTL controller
		.oRead_Data2(SDRAM_RData2),  					// Data 2 (RGB) from SDRAM to MTL controller
		.iRead_En1(SDRAM_REn1),							// SDRAM read control signal
		.iRead_En2(SDRAM_REn2),
		// SDRAM
		.oDRAM_ADDR(DRAM_ADDR),
		.oDRAM_BA(DRAM_BA),
		.oDRAM_CAS_N(DRAM_CAS_N),
		.oDRAM_CKE(DRAM_CKE),
		.oDRAM_CLK(DRAM_CLK),
		.oDRAM_CS_N(DRAM_CS_N),
		.ioDRAM_DQ(DRAM_DQ),
		.oDRAM_DQM(DRAM_DQM),
		.oDRAM_RAS_N(DRAM_RAS_N),
		.oDRAM_WE_N(DRAM_WE_N)
	);
	
	
	/********************/
	/*  LCD controller  */
	/********************/
	
	mtl_controller mtl_ctrl_inst( 	
		.iCLK_50(CLK_50),									// System clock (50MHz)
		.iRST(dly_rst),									// System sync reset
		.iX1(iX1),
		.iX2(iX2),
		.iX3(iX3),
		.iX4(iX4),
		.iX5(iX5),
		.iY1(iY1),
		.iY2(iY2),
		.iY3(iY3),
		.iY4(iY4),
		.iY5(iY5),
		.oCLK_33(CLK_33),									// MTL Clock (33 MHz, 0°)
		// MMU
		.iLoading(Loading),				 				// Input signal telling in which loading state is the system
		.iREAD_DATA1(SDRAM_RData1), 			 			// Input data 1 from SDRAM (RGB)
		.iREAD_DATA2(SDRAM_RData2), 			 			// Input data 2 from SDRAM (RGB)
		.oREAD_SDRAM_EN1(SDRAM_REn1),		 			// SDRAM read control signal
		.oREAD_SDRAM_EN2(SDRAM_REn2),		 			// SDRAM read control signal
		.oNew_Frame(New_Frame),			    			// Output signal being a pulse when a new frame of the LCD begins
		.oEnd_Frame(End_Frame),				 			// Output signal being a pulse when a frame of the LCD ends
		.oGest_W(Gest_W),									// Detected gesture pulse (sliding towards West)
		.oGest_E(Gest_E),									// Detected gesture pulse (sliding towards East)
		// MTL
		.oMTL_DCLK(MTL_DCLK),							// LCD Display clock (to MTL)
		.oMTL_HSD(MTL_HSD),							   // LCD horizontal sync (to MTL) 
		.oMTL_VSD(MTL_VSD),							   // LCD vertical sync (to MTL)
		.oMTL_TOUCH_I2C_SCL(MTL_TOUCH_I2C_SCL), 	// I2C clock pin of Touch IC (to MTL)
		.ioMTL_TOUCH_I2C_SDA(MTL_TOUCH_I2C_SDA), 	// I2C data pin of Touch IC (from/to MTL)
		.iMTL_TOUCH_INT_n(MTL_TOUCH_INT_n),     	// Interrupt pin of Touch IC (from MTL)
		.oMTL_R(MTL_R),									// LCD red color data  (to MTL)
		.oMTL_G(MTL_G),									// LCD green color data (to MTL)
		.oMTL_B(MTL_B) 									// LCD blue color data (to MTL)
	);


	/*************************/
	/*  SPI slave interface  */
	/*************************/

	spi_slave spi_slave_inst(
		.iCLK		    (CLK_50),							// System clock (50MHz)
		.iRST			 (dly_rst),							// System sync reset
		// SPI
		.iSPI_CLK    (spi_clk),							// SPI clock
		.iSPI_CS     (spi_cs),							// SPI chip select
		.iSPI_MOSI   (spi_mosi),						// SPI MOSI (from Rasp-Pi)
		.oSPI_MISO   (spi_miso),						// SPI MISO (to Rasp-Pi)
		// Internal registers R/W
		.iData_WE    (spi_write_enable),								// Write enable for SPI internal registers (not used here)
		.iData_Addr  (spi_write_address),							// Write address for SPI internal registers (not used here)
		.iData_Write (spi_write_data),							// Write data for SPI internal registers (not used here)
		.oData_Read  (spi_data),						// Read data from SPI internal registers (not used here)
		// MTL
		.oPix_Data(Pix_Data),							// Pixel's data from R-Pi (24-bit RGB)
		.oImg_Tot(Img_Tot),								// Total number of images transferred from Rasp-Pi
		.oTrigger(Trigger)								// Short pulse that is raised each time a whole pixel has been
																// received by the spi slave interface. Trigger enables writing 
																// the pixel to the SDRAM.
	);
	
	assign spi_clk  	= iSPI_CLK;					// SCLK = pin 16 = GPIO_11
	assign spi_cs   	=  iSPI_CS;					// CS   = pin 14 = GPIO_9
	assign spi_mosi   = iSPI_MOSI;					// MOSI = pin 20 = GPIO_15

	assign oSPI_MISO = spi_cs ? 1'bz : spi_miso; // MISO = pin 18 = GPIO_13


endmodule // DE0_NANO


////////////////////////////////////////////////////////////////////////////////////


/*
 * This small module contains everything needed to synchronize
 * all the components after a reset.
 * If you don't use it, you can meet some random bugs after a reset.
 */
module reset_delay (
	input  logic iRSTN,
	input  logic iCLK,
	output logic oRSTN,
	output logic oRD_RST,
	output logic oRST
	);
     
	reg  [26:0] cont;

	assign oRSTN = |cont[26:20]; 
	assign oRD_RST = cont[26:25] == 2'b01;      
	assign oRST = !cont[26];  	

	always_ff @(posedge iCLK or negedge iRSTN)
		if (!iRSTN) 
			cont     <= 27'b0;
		else if (!cont[26]) 
			cont     <= cont + 27'b1;
  
endmodule // reset_delay



module reset_finish(
	input logic iCLK,
	input logic iRSTN,
	input logic iRD_RST,
	input logic iRST,
	
	output logic oData_WE,
	output logic [31:0] oData_Addr,
	output logic [31:0] oData_Write
	);
	
	reg [9:0] count;
	
	always_ff @(posedge iCLK) begin
		if(iRSTN && !iRD_RST && !iRST) begin
			oData_WE <= 1'b1;
			oData_Addr <= 32'd4;
			oData_Write <= 32'b1;
			count <= 10'b0;
		end else if (count < 10'd5000) begin
			count <= count + 10'b1;
			oData_WE <= oData_WE;
			oData_Addr <= oData_Addr;
			oData_Write <= oData_Write;
		end else begin
			oData_WE <= 1'b0;
			oData_Addr <= 32'b0;
			oData_Write <= 32'b0;
			count <= 10'b0;
		end
	end
	
endmodule













