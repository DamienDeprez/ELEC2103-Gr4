	Nios_sopc u0 (
		.clk_clk                         (<connected-to-clk_clk>),                         //                      clk.clk
		.data_addr_export                (<connected-to-data_addr_export>),                //                data_addr.export
		.data_read_export                (<connected-to-data_read_export>),                //                data_read.export
		.data_we_export                  (<connected-to-data_we_export>),                  //                  data_we.export
		.data_write_export               (<connected-to-data_write_export>),               //               data_write.export
		.mem_nios_pi_s2_address          (<connected-to-mem_nios_pi_s2_address>),          //           mem_nios_pi_s2.address
		.mem_nios_pi_s2_chipselect       (<connected-to-mem_nios_pi_s2_chipselect>),       //                         .chipselect
		.mem_nios_pi_s2_clken            (<connected-to-mem_nios_pi_s2_clken>),            //                         .clken
		.mem_nios_pi_s2_write            (<connected-to-mem_nios_pi_s2_write>),            //                         .write
		.mem_nios_pi_s2_readdata         (<connected-to-mem_nios_pi_s2_readdata>),         //                         .readdata
		.mem_nios_pi_s2_writedata        (<connected-to-mem_nios_pi_s2_writedata>),        //                         .writedata
		.mem_nios_pi_s2_byteenable       (<connected-to-mem_nios_pi_s2_byteenable>),       //                         .byteenable
		.mtl_ip_mtl_b_export             (<connected-to-mtl_ip_mtl_b_export>),             //             mtl_ip_mtl_b.export
		.mtl_ip_mtl_dclk_export          (<connected-to-mtl_ip_mtl_dclk_export>),          //          mtl_ip_mtl_dclk.export
		.mtl_ip_mtl_g_export             (<connected-to-mtl_ip_mtl_g_export>),             //             mtl_ip_mtl_g.export
		.mtl_ip_mtl_hsd_export           (<connected-to-mtl_ip_mtl_hsd_export>),           //           mtl_ip_mtl_hsd.export
		.mtl_ip_mtl_r_export             (<connected-to-mtl_ip_mtl_r_export>),             //             mtl_ip_mtl_r.export
		.mtl_ip_mtl_touch_i2c_scl_export (<connected-to-mtl_ip_mtl_touch_i2c_scl_export>), // mtl_ip_mtl_touch_i2c_scl.export
		.mtl_ip_mtl_touch_i2c_sda_export (<connected-to-mtl_ip_mtl_touch_i2c_sda_export>), // mtl_ip_mtl_touch_i2c_sda.export
		.mtl_ip_mtl_touch_int_n_export   (<connected-to-mtl_ip_mtl_touch_int_n_export>),   //   mtl_ip_mtl_touch_int_n.export
		.mtl_ip_mtl_vsd_export           (<connected-to-mtl_ip_mtl_vsd_export>),           //           mtl_ip_mtl_vsd.export
		.mtl_ip_rst_dly_export           (<connected-to-mtl_ip_rst_dly_export>),           //           mtl_ip_rst_dly.export
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
		.spi_clk_export                  (<connected-to-spi_clk_export>),                  //                  spi_clk.export
		.spi_cs_export                   (<connected-to-spi_cs_export>),                   //                   spi_cs.export
		.spi_miso_export                 (<connected-to-spi_miso_export>),                 //                 spi_miso.export
		.spi_mosi_export                 (<connected-to-spi_mosi_export>),                 //                 spi_mosi.export
		.accelerometer_I2C_SDAT          (<connected-to-accelerometer_I2C_SDAT>),          //            accelerometer.I2C_SDAT
		.accelerometer_I2C_SCLK          (<connected-to-accelerometer_I2C_SCLK>),          //                         .I2C_SCLK
		.accelerometer_G_SENSOR_CS_N     (<connected-to-accelerometer_G_SENSOR_CS_N>),     //                         .G_SENSOR_CS_N
		.accelerometer_G_SENSOR_INT      (<connected-to-accelerometer_G_SENSOR_INT>)       //                         .G_SENSOR_INT
	);

