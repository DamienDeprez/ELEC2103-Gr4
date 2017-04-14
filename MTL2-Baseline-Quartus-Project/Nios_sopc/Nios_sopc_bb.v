
module Nios_sopc (
	clk_clk,
	data_addr_export,
	data_read_export,
	data_we_export,
	data_write_export,
	mem_nios_pi_s2_address,
	mem_nios_pi_s2_chipselect,
	mem_nios_pi_s2_clken,
	mem_nios_pi_s2_write,
	mem_nios_pi_s2_readdata,
	mem_nios_pi_s2_writedata,
	mem_nios_pi_s2_byteenable,
	mtl_ip_mtl_b_export,
	mtl_ip_mtl_dclk_export,
	mtl_ip_mtl_g_export,
	mtl_ip_mtl_hsd_export,
	mtl_ip_mtl_r_export,
	mtl_ip_mtl_touch_i2c_scl_export,
	mtl_ip_mtl_touch_i2c_sda_export,
	mtl_ip_mtl_touch_int_n_export,
	mtl_ip_mtl_vsd_export,
	mtl_ip_rst_dly_export,
	reset_reset_n,
	sdram_controller_addr,
	sdram_controller_ba,
	sdram_controller_cas_n,
	sdram_controller_cke,
	sdram_controller_cs_n,
	sdram_controller_dq,
	sdram_controller_dqm,
	sdram_controller_ras_n,
	sdram_controller_we_n,
	spi_clk_export,
	spi_cs_export,
	spi_miso_export,
	spi_mosi_export);	

	input		clk_clk;
	output	[6:0]	data_addr_export;
	input	[31:0]	data_read_export;
	output		data_we_export;
	output	[31:0]	data_write_export;
	input	[6:0]	mem_nios_pi_s2_address;
	input		mem_nios_pi_s2_chipselect;
	input		mem_nios_pi_s2_clken;
	input		mem_nios_pi_s2_write;
	output	[31:0]	mem_nios_pi_s2_readdata;
	input	[31:0]	mem_nios_pi_s2_writedata;
	input	[3:0]	mem_nios_pi_s2_byteenable;
	output	[7:0]	mtl_ip_mtl_b_export;
	output		mtl_ip_mtl_dclk_export;
	output	[7:0]	mtl_ip_mtl_g_export;
	output		mtl_ip_mtl_hsd_export;
	output	[7:0]	mtl_ip_mtl_r_export;
	output		mtl_ip_mtl_touch_i2c_scl_export;
	inout		mtl_ip_mtl_touch_i2c_sda_export;
	input		mtl_ip_mtl_touch_int_n_export;
	output		mtl_ip_mtl_vsd_export;
	input		mtl_ip_rst_dly_export;
	input		reset_reset_n;
	output	[12:0]	sdram_controller_addr;
	output	[1:0]	sdram_controller_ba;
	output		sdram_controller_cas_n;
	output		sdram_controller_cke;
	output		sdram_controller_cs_n;
	inout	[15:0]	sdram_controller_dq;
	output	[1:0]	sdram_controller_dqm;
	output		sdram_controller_ras_n;
	output		sdram_controller_we_n;
	input		spi_clk_export;
	input		spi_cs_export;
	output		spi_miso_export;
	input		spi_mosi_export;
endmodule
