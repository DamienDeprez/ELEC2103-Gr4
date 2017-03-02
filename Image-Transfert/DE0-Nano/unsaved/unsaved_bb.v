
module unsaved (
	clk_clk,
	mtl_ip_0_conduit_end_export,
	mtl_ip_0_conduit_end_1_export,
	mtl_ip_0_conduit_end_10_export,
	mtl_ip_0_conduit_end_11_export,
	mtl_ip_0_conduit_end_12_export,
	mtl_ip_0_conduit_end_13_export,
	mtl_ip_0_conduit_end_14_export,
	mtl_ip_0_conduit_end_15_export,
	mtl_ip_0_conduit_end_16_export,
	mtl_ip_0_conduit_end_17_export,
	mtl_ip_0_conduit_end_18_export,
	mtl_ip_0_conduit_end_19_export,
	mtl_ip_0_conduit_end_2_export,
	mtl_ip_0_conduit_end_20_export,
	mtl_ip_0_conduit_end_21_export,
	mtl_ip_0_conduit_end_3_export,
	mtl_ip_0_conduit_end_4_export,
	mtl_ip_0_conduit_end_5_export,
	mtl_ip_0_conduit_end_6_export,
	mtl_ip_0_conduit_end_7_export,
	mtl_ip_0_conduit_end_8_export,
	mtl_ip_0_conduit_end_9_export,
	mtl_ip_0_mtl_conduit_export,
	reset_reset_n,
	system_sdram_wire_addr,
	system_sdram_wire_ba,
	system_sdram_wire_cas_n,
	system_sdram_wire_cke,
	system_sdram_wire_cs_n,
	system_sdram_wire_dq,
	system_sdram_wire_dqm,
	system_sdram_wire_ras_n,
	system_sdram_wire_we_n);	

	input		clk_clk;
	output		mtl_ip_0_conduit_end_export;
	output		mtl_ip_0_conduit_end_1_export;
	output		mtl_ip_0_conduit_end_10_export;
	output		mtl_ip_0_conduit_end_11_export;
	output		mtl_ip_0_conduit_end_12_export;
	output		mtl_ip_0_conduit_end_13_export;
	inout	[15:0]	mtl_ip_0_conduit_end_14_export;
	output	[1:0]	mtl_ip_0_conduit_end_15_export;
	output		mtl_ip_0_conduit_end_16_export;
	output		mtl_ip_0_conduit_end_17_export;
	input		mtl_ip_0_conduit_end_18_export;
	input		mtl_ip_0_conduit_end_19_export;
	output		mtl_ip_0_conduit_end_2_export;
	input		mtl_ip_0_conduit_end_20_export;
	output		mtl_ip_0_conduit_end_21_export;
	inout		mtl_ip_0_conduit_end_3_export;
	input		mtl_ip_0_conduit_end_4_export;
	output	[7:0]	mtl_ip_0_conduit_end_5_export;
	output	[7:0]	mtl_ip_0_conduit_end_6_export;
	output	[7:0]	mtl_ip_0_conduit_end_7_export;
	output	[12:0]	mtl_ip_0_conduit_end_8_export;
	output	[1:0]	mtl_ip_0_conduit_end_9_export;
	output		mtl_ip_0_mtl_conduit_export;
	input		reset_reset_n;
	output	[11:0]	system_sdram_wire_addr;
	output	[1:0]	system_sdram_wire_ba;
	output		system_sdram_wire_cas_n;
	output		system_sdram_wire_cke;
	output		system_sdram_wire_cs_n;
	inout	[31:0]	system_sdram_wire_dq;
	output	[3:0]	system_sdram_wire_dqm;
	output		system_sdram_wire_ras_n;
	output		system_sdram_wire_we_n;
endmodule
