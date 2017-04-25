
module DE0_NANO(

	//////////// CLOCK //////////
	CLOCK_50,

	//////////// LED //////////
	LED,

	//////////// KEY //////////
	KEY,

	//////////// SW //////////
	SW,

	//////////// SDRAM //////////
	DRAM_ADDR,
	DRAM_BA,
	DRAM_CAS_N,
	DRAM_CKE,
	DRAM_CLK,
	DRAM_CS_N,
	DRAM_DQ,
	DRAM_DQM,
	DRAM_RAS_N,
	DRAM_WE_N,

	//////////// EPCS //////////
	EPCS_ASDO,
	EPCS_DATA0,
	EPCS_DCLK,
	EPCS_NCSO,

	//////////// Accelerometer and EEPROM //////////
	G_SENSOR_CS_N,
	G_SENSOR_INT,
	I2C_SCLK,
	I2C_SDAT,

	//////////// ADC //////////
	ADC_CS_N,
	ADC_SADDR,
	ADC_SCLK,
	ADC_SDAT,

	//////////// 2x13 GPIO Header //////////
	GPIO_2,
	GPIO_2_IN,

	//////////// GPIO_0, GPIO_0 connects to GPIO Default //////////
	GPIO_0,
	GPIO_0_IN,

	//////////// GPIO_1, GPIO_1 connects to the MTL Screen //////////
	MTL_DCLK,
	MTL_HSD,
	MTL_VSD,
	MTL_TOUCH_I2C_SCL,
	MTL_TOUCH_I2C_SDA,
	MTL_TOUCH_INT_n,
	MTL_R,
	MTL_G,
	MTL_B
);

//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input 		          		CLOCK_50;

//////////// LED //////////
output		     [7:0]		LED;

//////////// KEY //////////
input 		     [1:0]		KEY;

//////////// SW //////////
input 		     [3:0]		SW;

//////////// SDRAM //////////
output		    [12:0]		DRAM_ADDR;
output		     [1:0]		DRAM_BA;
output		          		DRAM_CAS_N;
output		          		DRAM_CKE;
output		          		DRAM_CLK;
output		          		DRAM_CS_N;
inout 		    [15:0]		DRAM_DQ;
output		     [1:0]		DRAM_DQM;
output		          		DRAM_RAS_N;
output		          		DRAM_WE_N;

//////////// EPCS //////////
output		          		EPCS_ASDO;
input 		          		EPCS_DATA0;
output		          		EPCS_DCLK;
output		          		EPCS_NCSO;

//////////// Accelerometer and EEPROM //////////
output		          		G_SENSOR_CS_N;
input 		          		G_SENSOR_INT;
output		          		I2C_SCLK;
inout 		          		I2C_SDAT;

//////////// ADC //////////
output		          		ADC_CS_N;
output		          		ADC_SADDR;
output		          		ADC_SCLK;
input 		          		ADC_SDAT;

//////////// 2x13 GPIO Header //////////
inout 		    [12:0]		GPIO_2;
input 		     [2:0]		GPIO_2_IN;

//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
inout 		    [33:0]		GPIO_0;
input 		     [1:0]		GPIO_0_IN;

//////////// GPIO_1, GPIO_1 connect to the MTL Screen //////////
output							MTL_DCLK;
output							MTL_HSD;
output							MTL_VSD;
output							MTL_TOUCH_I2C_SCL;
inout								MTL_TOUCH_I2C_SDA;
input								MTL_TOUCH_INT_n;
output			  [7:0]		MTL_R;
output			  [7:0]		MTL_G;
output			  [7:0]		MTL_B;


//=======================================================
//  Structural coding
//=======================================================


//--- System Reset --------------------------------------
 
logic RST, dly_rstn, rd_rst, dly_rst;

assign RST = ~KEY[0];

wire sdram_clk;

sdram_pll sdram_pll_inst(
	.inclk0(CLOCK_50),
	.c0(sdram_clk)
);

assign DRAM_CLK = sdram_clk;
logic mem_nios_pi_we;
	logic [6:0]	 mem_nios_pi_addr;
	logic [31:0] mem_nios_pi_readdata, mem_nios_pi_writedata;
// A good synchronization of all the resets of the different
// components must be carried out. Otherwise, some random bugs
// risk to appear after a reset of the system (see definition
// of the module at the end of this file).
reset_delay	reset_delay_inst (		
	.iRSTN(~RST),
   .iCLK(CLOCK_50),
	.oRSTN(dly_rstn),
	.oRD_RST(rd_rst),
	.oRST(dly_rst)
);


//--- MTL Controller ------------------------------------

/*mtl_controller (
	.iCLK(CLOCK_50),
	.iRST(dly_rst),
	// MTL
	.MTL_DCLK(MTL_DCLK),							// LCD Display clock (to MTL)
	.MTL_HSD(MTL_HSD),							// LCD horizontal sync (to MTL) 
	.MTL_VSD(MTL_VSD),							// LCD vertical sync (to MTL)
	.MTL_TOUCH_I2C_SCL(MTL_TOUCH_I2C_SCL), // I2C clock pin of Touch IC (from MTL)
	.MTL_TOUCH_I2C_SDA(MTL_TOUCH_I2C_SDA), // I2C data pin of Touch IC (from/to MTL)
	.MTL_TOUCH_INT_n(MTL_TOUCH_INT_n),     // Interrupt pin of Touch IC (from MTL)
	.MTL_R(MTL_R),									// LCD red color data  (to MTL)
	.MTL_G(MTL_G),									// LCD green color data (to MTL)
	.MTL_B(MTL_B) 									// LCD blue color data (to MTL)
);*/

Nios_sopc u0 (
		.clk_clk                         (CLOCK_50),                         //                      clk.clk
		.reset_reset_n                   (~RST),                   //                    reset.reset_n
		.sdram_controller_addr           (DRAM_ADDR),           //         sdram_controller.addr
		.sdram_controller_ba             (DRAM_BA),             //                         .ba
		.sdram_controller_cas_n          (DRAM_CAS_N),          //                         .cas_n
		.sdram_controller_cke            (DRAM_CKE),            //                         .cke
		.sdram_controller_cs_n           (DRAM_CS_N),           //                         .cs_n
		.sdram_controller_dq             (DRAM_DQ),             //                         .dq
		.sdram_controller_dqm            (DRAM_DQM),            //                         .dqm
		.sdram_controller_ras_n          (DRAM_RAS_N),          //                         .ras_n
		.sdram_controller_we_n           (DRAM_WE_N),           //                         .we_n
		.mtl_ip_mtl_dclk_export          (MTL_DCLK),          //          mtl_ip_mtl_dclk.export
		.mtl_ip_mtl_hsd_export           (MTL_HSD),           //           mtl_ip_mtl_hsd.export
		.mtl_ip_mtl_vsd_export           (MTL_VSD),           //           mtl_ip_mtl_vsd.export
		.mtl_ip_mtl_touch_i2c_scl_export (MTL_TOUCH_I2C_SCL), // mtl_ip_mtl_touch_i2c_scl.export
		.mtl_ip_mtl_touch_i2c_sda_export (MTL_TOUCH_I2C_SDA), // mtl_ip_mtl_touch_i2c_sda.export
		.mtl_ip_mtl_touch_int_n_export   (MTL_TOUCH_INT_n),   //   mtl_ip_mtl_touch_int_n.export
		.mtl_ip_mtl_r_export             (MTL_R),             //             mtl_ip_mtl_r.export
		.mtl_ip_mtl_g_export             (MTL_G),             //             mtl_ip_mtl_g.export
		.mtl_ip_mtl_b_export             (MTL_B),             //             mtl_ip_mtl_b.export
		.mtl_ip_rst_dly_export           (dly_rst),     		//           mtl_ip_rst_dly.export
		.mem_nios_pi_s2_address          (mem_nios_pi_addr),          //           mem_nios_pi_s2.address
		.mem_nios_pi_s2_chipselect       (1'b1),       //                         .chipselect
		.mem_nios_pi_s2_clken            (1'b1),            //                         .clken
		.mem_nios_pi_s2_write            (mem_nios_pi_we),            //                         .write
		.mem_nios_pi_s2_readdata         (mem_nios_pi_readdata),         //                         .readdata
		.mem_nios_pi_s2_writedata        (mem_nios_pi_writedata),        //                         .writedata
		.mem_nios_pi_s2_byteenable       (4'b1111),        //                         .byteenabel
		.spi_clk_export                  (spi_clk),                  //                  spi_clk.export
		.spi_cs_export                   (spi_cs),                   //                   spi_cs.export
		.spi_mosi_export                 (spi_mosi),                 //                 spi_mosi.export
		.spi_miso_export                 (spi_miso),                 //                 spi_miso.export
		.data_we_export                  (mem_nios_pi_we),                  //                  data_we.export
		.data_addr_export                (mem_nios_pi_addr),                //                data_addr.export
		.data_write_export               (mem_nios_pi_writedata),               //               data_write.export
		.data_read_export                (mem_nios_pi_readdata),                 //                data_read.export
		.accelerometer_I2C_SDAT          (I2C_SDAT),          //            accelerometer.I2C_SDAT
		.accelerometer_I2C_SCLK          (I2C_SCLK),          //                         .I2C_SCLK
		.accelerometer_G_SENSOR_CS_N     (G_SENSOR_CS_N),     //                         .G_SENSOR_CS_N
		.accelerometer_G_SENSOR_INT      (G_SENSOR_INT)       //                         .G_SENSOR_INT
	);
	
	assign LED[0] = 1'b1;

//=======================================================
//  SPI
//=======================================================

	logic spi_clk, spi_cs, spi_mosi, spi_miso;
	logic [31:0] DataToPI, DataFromPI;

	
	assign spi_clk  		= GPIO_0[11];	// SCLK = pin 16 = GPIO_11
	assign spi_cs   		= GPIO_0[9];	// CE0  = pin 14 = GPIO_9
	assign spi_mosi     	= GPIO_0[15];	// MOSI = pin 20 = GPIO_15
	
	assign GPIO_0[13] = spi_cs ? 1'bz : spi_miso;  // MISO = pin 18 = GPIO_13	

endmodule // DE0_NANO


///////////////////////////////////////////////////////////////////////////


/*
 * This small module contains everything needed to synchronize
 * all the components after a reset.
 * If you don't use it, you can meet some random bugs after a reset.
 */
module	reset_delay (
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

