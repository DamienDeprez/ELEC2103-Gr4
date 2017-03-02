	Nios_sopc u0 (
		.clk_clk                         (<connected-to-clk_clk>),                         //                      clk.clk
		.reset_reset_n                   (<connected-to-reset_reset_n>),                   //                    reset.reset_n
		.sdram_controller_addr           (<connected-to-sdram_controller_addr>),           //         sdram_controller.addr
		.sdram_controller_ba             (<connected-to-sdram_controller_ba>),             //                         .ba
		.sdram_controller_cas_n          (<connected-to-sdram_controller_cas_n>),          //                         .cas_n
		.sdram_controller_cke            (<connected-to-sdram_controller_cke>),            //                         .cke
		.sdram_controller_cs_n           (<connected-to-sdram_controller_cs_n>),           //                         .cs_n
		.sdram_controller_dq             (<connected-to-sdram_controller_dq>),             //                         .dq
		.sdram_controller_dqm            (<connected-to-sdram_controller_dqm>),            //                         .dqm
		.sdram_controller_ras_n          (<connected-to-sdram_controller_ras_n>),          //                         .ras_n
		.sdram_controller_we_n           (<connected-to-sdram_controller_we_n>),           //                         .we_n
		.mtl_ip_mtl_dclk_export          (<connected-to-mtl_ip_mtl_dclk_export>),          //          mtl_ip_mtl_dclk.export
		.mtl_ip_mtl_hsd_export           (<connected-to-mtl_ip_mtl_hsd_export>),           //           mtl_ip_mtl_hsd.export
		.mtl_ip_mtl_vsd_export           (<connected-to-mtl_ip_mtl_vsd_export>),           //           mtl_ip_mtl_vsd.export
		.mtl_ip_mtl_touch_i2c_scl_export (<connected-to-mtl_ip_mtl_touch_i2c_scl_export>), // mtl_ip_mtl_touch_i2c_scl.export
		.mtl_ip_mtl_touch_i2c_sda_export (<connected-to-mtl_ip_mtl_touch_i2c_sda_export>), // mtl_ip_mtl_touch_i2c_sda.export
		.mtl_ip_mtl_touch_int_n_export   (<connected-to-mtl_ip_mtl_touch_int_n_export>),   //   mtl_ip_mtl_touch_int_n.export
		.mtl_ip_mtl_r_export             (<connected-to-mtl_ip_mtl_r_export>),             //             mtl_ip_mtl_r.export
		.mtl_ip_mtl_g_export             (<connected-to-mtl_ip_mtl_g_export>),             //             mtl_ip_mtl_g.export
		.mtl_ip_mtl_b_export             (<connected-to-mtl_ip_mtl_b_export>),             //             mtl_ip_mtl_b.export
		.mtl_ip_rst_dly_export           (<connected-to-mtl_ip_rst_dly_export>)            //           mtl_ip_rst_dly.export
	);

