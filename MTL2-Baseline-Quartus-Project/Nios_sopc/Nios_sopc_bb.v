
module Nios_sopc (
	clk_clk,
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
	mtl_ip_mtl_dclk_export,
	mtl_ip_mtl_hsd_export,
	mtl_ip_mtl_vsd_export,
	mtl_ip_mtl_touch_i2c_scl_export,
	mtl_ip_mtl_touch_i2c_sda_export,
	mtl_ip_mtl_touch_int_n_export,
	mtl_ip_mtl_r_export,
	mtl_ip_mtl_g_export,
	mtl_ip_mtl_b_export,
	mtl_ip_rst_dly_export);	

	input		clk_clk;
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
	output		mtl_ip_mtl_dclk_export;
	output		mtl_ip_mtl_hsd_export;
	output		mtl_ip_mtl_vsd_export;
	output		mtl_ip_mtl_touch_i2c_scl_export;
	inout		mtl_ip_mtl_touch_i2c_sda_export;
	input		mtl_ip_mtl_touch_int_n_export;
	output	[7:0]	mtl_ip_mtl_r_export;
	output	[7:0]	mtl_ip_mtl_g_export;
	output	[7:0]	mtl_ip_mtl_b_export;
	input		mtl_ip_rst_dly_export;
endmodule
