// Nios_sopc.v

// Generated using ACDS version 16.1 196

`timescale 1 ps / 1 ps
module Nios_sopc (
		input  wire        clk_clk,                         //                      clk.clk
		output wire [6:0]  data_addr_export,                //                data_addr.export
		input  wire [31:0] data_read_export,                //                data_read.export
		output wire        data_we_export,                  //                  data_we.export
		output wire [31:0] data_write_export,               //               data_write.export
		input  wire [6:0]  mem_nios_pi_s2_address,          //           mem_nios_pi_s2.address
		input  wire        mem_nios_pi_s2_chipselect,       //                         .chipselect
		input  wire        mem_nios_pi_s2_clken,            //                         .clken
		input  wire        mem_nios_pi_s2_write,            //                         .write
		output wire [31:0] mem_nios_pi_s2_readdata,         //                         .readdata
		input  wire [31:0] mem_nios_pi_s2_writedata,        //                         .writedata
		input  wire [3:0]  mem_nios_pi_s2_byteenable,       //                         .byteenable
		output wire [7:0]  mtl_ip_mtl_b_export,             //             mtl_ip_mtl_b.export
		output wire        mtl_ip_mtl_dclk_export,          //          mtl_ip_mtl_dclk.export
		output wire [7:0]  mtl_ip_mtl_g_export,             //             mtl_ip_mtl_g.export
		output wire        mtl_ip_mtl_hsd_export,           //           mtl_ip_mtl_hsd.export
		output wire [7:0]  mtl_ip_mtl_r_export,             //             mtl_ip_mtl_r.export
		output wire        mtl_ip_mtl_touch_i2c_scl_export, // mtl_ip_mtl_touch_i2c_scl.export
		inout  wire        mtl_ip_mtl_touch_i2c_sda_export, // mtl_ip_mtl_touch_i2c_sda.export
		input  wire        mtl_ip_mtl_touch_int_n_export,   //   mtl_ip_mtl_touch_int_n.export
		output wire        mtl_ip_mtl_vsd_export,           //           mtl_ip_mtl_vsd.export
		input  wire        mtl_ip_rst_dly_export,           //           mtl_ip_rst_dly.export
		input  wire        reset_reset_n,                   //                    reset.reset_n
		output wire [12:0] sdram_controller_addr,           //         sdram_controller.addr
		output wire [1:0]  sdram_controller_ba,             //                         .ba
		output wire        sdram_controller_cas_n,          //                         .cas_n
		output wire        sdram_controller_cke,            //                         .cke
		output wire        sdram_controller_cs_n,           //                         .cs_n
		inout  wire [15:0] sdram_controller_dq,             //                         .dq
		output wire [1:0]  sdram_controller_dqm,            //                         .dqm
		output wire        sdram_controller_ras_n,          //                         .ras_n
		output wire        sdram_controller_we_n,           //                         .we_n
		input  wire        spi_clk_export,                  //                  spi_clk.export
		input  wire        spi_cs_export,                   //                   spi_cs.export
		output wire        spi_miso_export,                 //                 spi_miso.export
		input  wire        spi_mosi_export                  //                 spi_mosi.export
	);

	wire  [31:0] cpu_data_master_readdata;                                  // mm_interconnect_0:cpu_data_master_readdata -> cpu:d_readdata
	wire         cpu_data_master_waitrequest;                               // mm_interconnect_0:cpu_data_master_waitrequest -> cpu:d_waitrequest
	wire         cpu_data_master_debugaccess;                               // cpu:debug_mem_slave_debugaccess_to_roms -> mm_interconnect_0:cpu_data_master_debugaccess
	wire  [25:0] cpu_data_master_address;                                   // cpu:d_address -> mm_interconnect_0:cpu_data_master_address
	wire   [3:0] cpu_data_master_byteenable;                                // cpu:d_byteenable -> mm_interconnect_0:cpu_data_master_byteenable
	wire         cpu_data_master_read;                                      // cpu:d_read -> mm_interconnect_0:cpu_data_master_read
	wire         cpu_data_master_write;                                     // cpu:d_write -> mm_interconnect_0:cpu_data_master_write
	wire  [31:0] cpu_data_master_writedata;                                 // cpu:d_writedata -> mm_interconnect_0:cpu_data_master_writedata
	wire  [31:0] cpu_instruction_master_readdata;                           // mm_interconnect_0:cpu_instruction_master_readdata -> cpu:i_readdata
	wire         cpu_instruction_master_waitrequest;                        // mm_interconnect_0:cpu_instruction_master_waitrequest -> cpu:i_waitrequest
	wire  [25:0] cpu_instruction_master_address;                            // cpu:i_address -> mm_interconnect_0:cpu_instruction_master_address
	wire         cpu_instruction_master_read;                               // cpu:i_read -> mm_interconnect_0:cpu_instruction_master_read
	wire         mm_interconnect_0_jtag_uart_avalon_jtag_slave_chipselect;  // mm_interconnect_0:jtag_uart_avalon_jtag_slave_chipselect -> jtag_uart:av_chipselect
	wire  [31:0] mm_interconnect_0_jtag_uart_avalon_jtag_slave_readdata;    // jtag_uart:av_readdata -> mm_interconnect_0:jtag_uart_avalon_jtag_slave_readdata
	wire         mm_interconnect_0_jtag_uart_avalon_jtag_slave_waitrequest; // jtag_uart:av_waitrequest -> mm_interconnect_0:jtag_uart_avalon_jtag_slave_waitrequest
	wire   [0:0] mm_interconnect_0_jtag_uart_avalon_jtag_slave_address;     // mm_interconnect_0:jtag_uart_avalon_jtag_slave_address -> jtag_uart:av_address
	wire         mm_interconnect_0_jtag_uart_avalon_jtag_slave_read;        // mm_interconnect_0:jtag_uart_avalon_jtag_slave_read -> jtag_uart:av_read_n
	wire         mm_interconnect_0_jtag_uart_avalon_jtag_slave_write;       // mm_interconnect_0:jtag_uart_avalon_jtag_slave_write -> jtag_uart:av_write_n
	wire  [31:0] mm_interconnect_0_jtag_uart_avalon_jtag_slave_writedata;   // mm_interconnect_0:jtag_uart_avalon_jtag_slave_writedata -> jtag_uart:av_writedata
	wire  [31:0] mm_interconnect_0_sysid_qsys_control_slave_readdata;       // sysid_qsys:readdata -> mm_interconnect_0:sysid_qsys_control_slave_readdata
	wire   [0:0] mm_interconnect_0_sysid_qsys_control_slave_address;        // mm_interconnect_0:sysid_qsys_control_slave_address -> sysid_qsys:address
	wire  [31:0] mm_interconnect_0_cpu_debug_mem_slave_readdata;            // cpu:debug_mem_slave_readdata -> mm_interconnect_0:cpu_debug_mem_slave_readdata
	wire         mm_interconnect_0_cpu_debug_mem_slave_waitrequest;         // cpu:debug_mem_slave_waitrequest -> mm_interconnect_0:cpu_debug_mem_slave_waitrequest
	wire         mm_interconnect_0_cpu_debug_mem_slave_debugaccess;         // mm_interconnect_0:cpu_debug_mem_slave_debugaccess -> cpu:debug_mem_slave_debugaccess
	wire   [8:0] mm_interconnect_0_cpu_debug_mem_slave_address;             // mm_interconnect_0:cpu_debug_mem_slave_address -> cpu:debug_mem_slave_address
	wire         mm_interconnect_0_cpu_debug_mem_slave_read;                // mm_interconnect_0:cpu_debug_mem_slave_read -> cpu:debug_mem_slave_read
	wire   [3:0] mm_interconnect_0_cpu_debug_mem_slave_byteenable;          // mm_interconnect_0:cpu_debug_mem_slave_byteenable -> cpu:debug_mem_slave_byteenable
	wire         mm_interconnect_0_cpu_debug_mem_slave_write;               // mm_interconnect_0:cpu_debug_mem_slave_write -> cpu:debug_mem_slave_write
	wire  [31:0] mm_interconnect_0_cpu_debug_mem_slave_writedata;           // mm_interconnect_0:cpu_debug_mem_slave_writedata -> cpu:debug_mem_slave_writedata
	wire  [31:0] mm_interconnect_0_mtl_ip_s0_readdata;                      // MTL_ip:avs_s0_readdata -> mm_interconnect_0:MTL_ip_s0_readdata
	wire         mm_interconnect_0_mtl_ip_s0_waitrequest;                   // MTL_ip:avs_s0_waitrequest -> mm_interconnect_0:MTL_ip_s0_waitrequest
	wire   [7:0] mm_interconnect_0_mtl_ip_s0_address;                       // mm_interconnect_0:MTL_ip_s0_address -> MTL_ip:avs_s0_address
	wire         mm_interconnect_0_mtl_ip_s0_read;                          // mm_interconnect_0:MTL_ip_s0_read -> MTL_ip:avs_s0_read
	wire         mm_interconnect_0_mtl_ip_s0_write;                         // mm_interconnect_0:MTL_ip_s0_write -> MTL_ip:avs_s0_write
	wire  [31:0] mm_interconnect_0_mtl_ip_s0_writedata;                     // mm_interconnect_0:MTL_ip_s0_writedata -> MTL_ip:avs_s0_writedata
	wire         mm_interconnect_0_timer_timestamp_s1_chipselect;           // mm_interconnect_0:timer_timestamp_s1_chipselect -> timer_timestamp:chipselect
	wire  [15:0] mm_interconnect_0_timer_timestamp_s1_readdata;             // timer_timestamp:readdata -> mm_interconnect_0:timer_timestamp_s1_readdata
	wire   [2:0] mm_interconnect_0_timer_timestamp_s1_address;              // mm_interconnect_0:timer_timestamp_s1_address -> timer_timestamp:address
	wire         mm_interconnect_0_timer_timestamp_s1_write;                // mm_interconnect_0:timer_timestamp_s1_write -> timer_timestamp:write_n
	wire  [15:0] mm_interconnect_0_timer_timestamp_s1_writedata;            // mm_interconnect_0:timer_timestamp_s1_writedata -> timer_timestamp:writedata
	wire         mm_interconnect_0_timer_system_s1_chipselect;              // mm_interconnect_0:timer_system_s1_chipselect -> timer_system:chipselect
	wire  [15:0] mm_interconnect_0_timer_system_s1_readdata;                // timer_system:readdata -> mm_interconnect_0:timer_system_s1_readdata
	wire   [2:0] mm_interconnect_0_timer_system_s1_address;                 // mm_interconnect_0:timer_system_s1_address -> timer_system:address
	wire         mm_interconnect_0_timer_system_s1_write;                   // mm_interconnect_0:timer_system_s1_write -> timer_system:write_n
	wire  [15:0] mm_interconnect_0_timer_system_s1_writedata;               // mm_interconnect_0:timer_system_s1_writedata -> timer_system:writedata
	wire         mm_interconnect_0_sdram_controller_s1_chipselect;          // mm_interconnect_0:sdram_controller_s1_chipselect -> sdram_controller:az_cs
	wire  [15:0] mm_interconnect_0_sdram_controller_s1_readdata;            // sdram_controller:za_data -> mm_interconnect_0:sdram_controller_s1_readdata
	wire         mm_interconnect_0_sdram_controller_s1_waitrequest;         // sdram_controller:za_waitrequest -> mm_interconnect_0:sdram_controller_s1_waitrequest
	wire  [23:0] mm_interconnect_0_sdram_controller_s1_address;             // mm_interconnect_0:sdram_controller_s1_address -> sdram_controller:az_addr
	wire         mm_interconnect_0_sdram_controller_s1_read;                // mm_interconnect_0:sdram_controller_s1_read -> sdram_controller:az_rd_n
	wire   [1:0] mm_interconnect_0_sdram_controller_s1_byteenable;          // mm_interconnect_0:sdram_controller_s1_byteenable -> sdram_controller:az_be_n
	wire         mm_interconnect_0_sdram_controller_s1_readdatavalid;       // sdram_controller:za_valid -> mm_interconnect_0:sdram_controller_s1_readdatavalid
	wire         mm_interconnect_0_sdram_controller_s1_write;               // mm_interconnect_0:sdram_controller_s1_write -> sdram_controller:az_wr_n
	wire  [15:0] mm_interconnect_0_sdram_controller_s1_writedata;           // mm_interconnect_0:sdram_controller_s1_writedata -> sdram_controller:az_data
	wire         mm_interconnect_0_mem_nios_pi_s1_chipselect;               // mm_interconnect_0:mem_Nios_PI_s1_chipselect -> mem_Nios_PI:chipselect
	wire  [31:0] mm_interconnect_0_mem_nios_pi_s1_readdata;                 // mem_Nios_PI:readdata -> mm_interconnect_0:mem_Nios_PI_s1_readdata
	wire   [6:0] mm_interconnect_0_mem_nios_pi_s1_address;                  // mm_interconnect_0:mem_Nios_PI_s1_address -> mem_Nios_PI:address
	wire   [3:0] mm_interconnect_0_mem_nios_pi_s1_byteenable;               // mm_interconnect_0:mem_Nios_PI_s1_byteenable -> mem_Nios_PI:byteenable
	wire         mm_interconnect_0_mem_nios_pi_s1_write;                    // mm_interconnect_0:mem_Nios_PI_s1_write -> mem_Nios_PI:write
	wire  [31:0] mm_interconnect_0_mem_nios_pi_s1_writedata;                // mm_interconnect_0:mem_Nios_PI_s1_writedata -> mem_Nios_PI:writedata
	wire         mm_interconnect_0_mem_nios_pi_s1_clken;                    // mm_interconnect_0:mem_Nios_PI_s1_clken -> mem_Nios_PI:clken
	wire         irq_mapper_receiver0_irq;                                  // jtag_uart:av_irq -> irq_mapper:receiver0_irq
	wire         irq_mapper_receiver1_irq;                                  // timer_timestamp:irq -> irq_mapper:receiver1_irq
	wire         irq_mapper_receiver2_irq;                                  // timer_system:irq -> irq_mapper:receiver2_irq
	wire  [31:0] cpu_irq_irq;                                               // irq_mapper:sender_irq -> cpu:irq
	wire         rst_controller_reset_out_reset;                            // rst_controller:reset_out -> [MTL_ip:reset_reset, cpu:reset_n, irq_mapper:reset, jtag_uart:rst_n, mem_Nios_PI:reset, mem_Nios_PI:reset2, mm_interconnect_0:cpu_reset_reset_bridge_in_reset_reset, rst_translator:in_reset, sdram_controller:reset_n, sysid_qsys:reset_n, timer_system:reset_n, timer_timestamp:reset_n]
	wire         rst_controller_reset_out_reset_req;                        // rst_controller:reset_req -> [cpu:reset_req, mem_Nios_PI:reset_req, mem_Nios_PI:reset_req2, rst_translator:reset_req_in]

	MTL_ip mtl_ip (
		.avs_s0_address     (mm_interconnect_0_mtl_ip_s0_address),     //                s0.address
		.avs_s0_read        (mm_interconnect_0_mtl_ip_s0_read),        //                  .read
		.avs_s0_readdata    (mm_interconnect_0_mtl_ip_s0_readdata),    //                  .readdata
		.avs_s0_write       (mm_interconnect_0_mtl_ip_s0_write),       //                  .write
		.avs_s0_writedata   (mm_interconnect_0_mtl_ip_s0_writedata),   //                  .writedata
		.avs_s0_waitrequest (mm_interconnect_0_mtl_ip_s0_waitrequest), //                  .waitrequest
		.reset_reset        (~rst_controller_reset_out_reset),         //        reset_sink.reset_n
		.clock_clk          (clk_clk),                                 //        clock_sink.clk
		.MTL_DCLK           (mtl_ip_mtl_dclk_export),                  //          MTL_DCLK.export
		.MTL_HSD            (mtl_ip_mtl_hsd_export),                   //           MTL_HSD.export
		.MTL_VSD            (mtl_ip_mtl_vsd_export),                   //           MTL_VSD.export
		.MTL_TOUCH_I2C_SCL  (mtl_ip_mtl_touch_i2c_scl_export),         // MTL_TOUCH_I2C_SCL.export
		.MTL_TOUCH_I2C_SDA  (mtl_ip_mtl_touch_i2c_sda_export),         // MTL_TOUCH_I2C_SDA.export
		.MTL_TOUCH_INT_n    (mtl_ip_mtl_touch_int_n_export),           //   MTL_TOUCH_INT_n.export
		.MTL_R              (mtl_ip_mtl_r_export),                     //             MTL_R.export
		.MTL_G              (mtl_ip_mtl_g_export),                     //             MTL_G.export
		.MTL_B              (mtl_ip_mtl_b_export),                     //             MTL_B.export
		.RST_DLY            (mtl_ip_rst_dly_export)                    //           RST_DLY.export
	);

	Nios_sopc_cpu cpu (
		.clk                                 (clk_clk),                                           //                       clk.clk
		.reset_n                             (~rst_controller_reset_out_reset),                   //                     reset.reset_n
		.reset_req                           (rst_controller_reset_out_reset_req),                //                          .reset_req
		.d_address                           (cpu_data_master_address),                           //               data_master.address
		.d_byteenable                        (cpu_data_master_byteenable),                        //                          .byteenable
		.d_read                              (cpu_data_master_read),                              //                          .read
		.d_readdata                          (cpu_data_master_readdata),                          //                          .readdata
		.d_waitrequest                       (cpu_data_master_waitrequest),                       //                          .waitrequest
		.d_write                             (cpu_data_master_write),                             //                          .write
		.d_writedata                         (cpu_data_master_writedata),                         //                          .writedata
		.debug_mem_slave_debugaccess_to_roms (cpu_data_master_debugaccess),                       //                          .debugaccess
		.i_address                           (cpu_instruction_master_address),                    //        instruction_master.address
		.i_read                              (cpu_instruction_master_read),                       //                          .read
		.i_readdata                          (cpu_instruction_master_readdata),                   //                          .readdata
		.i_waitrequest                       (cpu_instruction_master_waitrequest),                //                          .waitrequest
		.irq                                 (cpu_irq_irq),                                       //                       irq.irq
		.debug_reset_request                 (),                                                  //       debug_reset_request.reset
		.debug_mem_slave_address             (mm_interconnect_0_cpu_debug_mem_slave_address),     //           debug_mem_slave.address
		.debug_mem_slave_byteenable          (mm_interconnect_0_cpu_debug_mem_slave_byteenable),  //                          .byteenable
		.debug_mem_slave_debugaccess         (mm_interconnect_0_cpu_debug_mem_slave_debugaccess), //                          .debugaccess
		.debug_mem_slave_read                (mm_interconnect_0_cpu_debug_mem_slave_read),        //                          .read
		.debug_mem_slave_readdata            (mm_interconnect_0_cpu_debug_mem_slave_readdata),    //                          .readdata
		.debug_mem_slave_waitrequest         (mm_interconnect_0_cpu_debug_mem_slave_waitrequest), //                          .waitrequest
		.debug_mem_slave_write               (mm_interconnect_0_cpu_debug_mem_slave_write),       //                          .write
		.debug_mem_slave_writedata           (mm_interconnect_0_cpu_debug_mem_slave_writedata),   //                          .writedata
		.dummy_ci_port                       ()                                                   // custom_instruction_master.readra
	);

	Nios_sopc_jtag_uart jtag_uart (
		.clk            (clk_clk),                                                   //               clk.clk
		.rst_n          (~rst_controller_reset_out_reset),                           //             reset.reset_n
		.av_chipselect  (mm_interconnect_0_jtag_uart_avalon_jtag_slave_chipselect),  // avalon_jtag_slave.chipselect
		.av_address     (mm_interconnect_0_jtag_uart_avalon_jtag_slave_address),     //                  .address
		.av_read_n      (~mm_interconnect_0_jtag_uart_avalon_jtag_slave_read),       //                  .read_n
		.av_readdata    (mm_interconnect_0_jtag_uart_avalon_jtag_slave_readdata),    //                  .readdata
		.av_write_n     (~mm_interconnect_0_jtag_uart_avalon_jtag_slave_write),      //                  .write_n
		.av_writedata   (mm_interconnect_0_jtag_uart_avalon_jtag_slave_writedata),   //                  .writedata
		.av_waitrequest (mm_interconnect_0_jtag_uart_avalon_jtag_slave_waitrequest), //                  .waitrequest
		.av_irq         (irq_mapper_receiver0_irq)                                   //               irq.irq
	);

	Nios_sopc_mem_Nios_PI mem_nios_pi (
		.clk         (clk_clk),                                     //   clk1.clk
		.address     (mm_interconnect_0_mem_nios_pi_s1_address),    //     s1.address
		.clken       (mm_interconnect_0_mem_nios_pi_s1_clken),      //       .clken
		.chipselect  (mm_interconnect_0_mem_nios_pi_s1_chipselect), //       .chipselect
		.write       (mm_interconnect_0_mem_nios_pi_s1_write),      //       .write
		.readdata    (mm_interconnect_0_mem_nios_pi_s1_readdata),   //       .readdata
		.writedata   (mm_interconnect_0_mem_nios_pi_s1_writedata),  //       .writedata
		.byteenable  (mm_interconnect_0_mem_nios_pi_s1_byteenable), //       .byteenable
		.reset       (rst_controller_reset_out_reset),              // reset1.reset
		.reset_req   (rst_controller_reset_out_reset_req),          //       .reset_req
		.address2    (mem_nios_pi_s2_address),                      //     s2.address
		.chipselect2 (mem_nios_pi_s2_chipselect),                   //       .chipselect
		.clken2      (mem_nios_pi_s2_clken),                        //       .clken
		.write2      (mem_nios_pi_s2_write),                        //       .write
		.readdata2   (mem_nios_pi_s2_readdata),                     //       .readdata
		.writedata2  (mem_nios_pi_s2_writedata),                    //       .writedata
		.byteenable2 (mem_nios_pi_s2_byteenable),                   //       .byteenable
		.clk2        (clk_clk),                                     //   clk2.clk
		.reset2      (rst_controller_reset_out_reset),              // reset2.reset
		.reset_req2  (rst_controller_reset_out_reset_req),          //       .reset_req
		.freeze      (1'b0)                                         // (terminated)
	);

	new_component my_spi (
		.clock_clk  (clk_clk),           //      clock.clk
		.SPI_CLK    (spi_clk_export),    //    SPI_CLK.export
		.SPI_CS     (spi_cs_export),     //     SPI_CS.export
		.SPI_MOSI   (spi_mosi_export),   //   SPI_MOSI.export
		.SPI_MISO   (spi_miso_export),   //   SPI_MISO.export
		.Data_WE    (data_we_export),    //    Data_WE.export
		.Data_Addr  (data_addr_export),  //  Data_Addr.export
		.Data_Write (data_write_export), // Data_Write.export
		.Data_Read  (data_read_export)   //  Data_Read.export
	);

	Nios_sopc_sdram_controller sdram_controller (
		.clk            (clk_clk),                                             //   clk.clk
		.reset_n        (~rst_controller_reset_out_reset),                     // reset.reset_n
		.az_addr        (mm_interconnect_0_sdram_controller_s1_address),       //    s1.address
		.az_be_n        (~mm_interconnect_0_sdram_controller_s1_byteenable),   //      .byteenable_n
		.az_cs          (mm_interconnect_0_sdram_controller_s1_chipselect),    //      .chipselect
		.az_data        (mm_interconnect_0_sdram_controller_s1_writedata),     //      .writedata
		.az_rd_n        (~mm_interconnect_0_sdram_controller_s1_read),         //      .read_n
		.az_wr_n        (~mm_interconnect_0_sdram_controller_s1_write),        //      .write_n
		.za_data        (mm_interconnect_0_sdram_controller_s1_readdata),      //      .readdata
		.za_valid       (mm_interconnect_0_sdram_controller_s1_readdatavalid), //      .readdatavalid
		.za_waitrequest (mm_interconnect_0_sdram_controller_s1_waitrequest),   //      .waitrequest
		.zs_addr        (sdram_controller_addr),                               //  wire.export
		.zs_ba          (sdram_controller_ba),                                 //      .export
		.zs_cas_n       (sdram_controller_cas_n),                              //      .export
		.zs_cke         (sdram_controller_cke),                                //      .export
		.zs_cs_n        (sdram_controller_cs_n),                               //      .export
		.zs_dq          (sdram_controller_dq),                                 //      .export
		.zs_dqm         (sdram_controller_dqm),                                //      .export
		.zs_ras_n       (sdram_controller_ras_n),                              //      .export
		.zs_we_n        (sdram_controller_we_n)                                //      .export
	);

	Nios_sopc_sysid_qsys sysid_qsys (
		.clock    (clk_clk),                                             //           clk.clk
		.reset_n  (~rst_controller_reset_out_reset),                     //         reset.reset_n
		.readdata (mm_interconnect_0_sysid_qsys_control_slave_readdata), // control_slave.readdata
		.address  (mm_interconnect_0_sysid_qsys_control_slave_address)   //              .address
	);

	Nios_sopc_timer_system timer_system (
		.clk        (clk_clk),                                      //   clk.clk
		.reset_n    (~rst_controller_reset_out_reset),              // reset.reset_n
		.address    (mm_interconnect_0_timer_system_s1_address),    //    s1.address
		.writedata  (mm_interconnect_0_timer_system_s1_writedata),  //      .writedata
		.readdata   (mm_interconnect_0_timer_system_s1_readdata),   //      .readdata
		.chipselect (mm_interconnect_0_timer_system_s1_chipselect), //      .chipselect
		.write_n    (~mm_interconnect_0_timer_system_s1_write),     //      .write_n
		.irq        (irq_mapper_receiver2_irq)                      //   irq.irq
	);

	Nios_sopc_timer_system timer_timestamp (
		.clk        (clk_clk),                                         //   clk.clk
		.reset_n    (~rst_controller_reset_out_reset),                 // reset.reset_n
		.address    (mm_interconnect_0_timer_timestamp_s1_address),    //    s1.address
		.writedata  (mm_interconnect_0_timer_timestamp_s1_writedata),  //      .writedata
		.readdata   (mm_interconnect_0_timer_timestamp_s1_readdata),   //      .readdata
		.chipselect (mm_interconnect_0_timer_timestamp_s1_chipselect), //      .chipselect
		.write_n    (~mm_interconnect_0_timer_timestamp_s1_write),     //      .write_n
		.irq        (irq_mapper_receiver1_irq)                         //   irq.irq
	);

	Nios_sopc_mm_interconnect_0 mm_interconnect_0 (
		.clk_0_clk_clk                           (clk_clk),                                                   //                       clk_0_clk.clk
		.cpu_reset_reset_bridge_in_reset_reset   (rst_controller_reset_out_reset),                            // cpu_reset_reset_bridge_in_reset.reset
		.cpu_data_master_address                 (cpu_data_master_address),                                   //                 cpu_data_master.address
		.cpu_data_master_waitrequest             (cpu_data_master_waitrequest),                               //                                .waitrequest
		.cpu_data_master_byteenable              (cpu_data_master_byteenable),                                //                                .byteenable
		.cpu_data_master_read                    (cpu_data_master_read),                                      //                                .read
		.cpu_data_master_readdata                (cpu_data_master_readdata),                                  //                                .readdata
		.cpu_data_master_write                   (cpu_data_master_write),                                     //                                .write
		.cpu_data_master_writedata               (cpu_data_master_writedata),                                 //                                .writedata
		.cpu_data_master_debugaccess             (cpu_data_master_debugaccess),                               //                                .debugaccess
		.cpu_instruction_master_address          (cpu_instruction_master_address),                            //          cpu_instruction_master.address
		.cpu_instruction_master_waitrequest      (cpu_instruction_master_waitrequest),                        //                                .waitrequest
		.cpu_instruction_master_read             (cpu_instruction_master_read),                               //                                .read
		.cpu_instruction_master_readdata         (cpu_instruction_master_readdata),                           //                                .readdata
		.cpu_debug_mem_slave_address             (mm_interconnect_0_cpu_debug_mem_slave_address),             //             cpu_debug_mem_slave.address
		.cpu_debug_mem_slave_write               (mm_interconnect_0_cpu_debug_mem_slave_write),               //                                .write
		.cpu_debug_mem_slave_read                (mm_interconnect_0_cpu_debug_mem_slave_read),                //                                .read
		.cpu_debug_mem_slave_readdata            (mm_interconnect_0_cpu_debug_mem_slave_readdata),            //                                .readdata
		.cpu_debug_mem_slave_writedata           (mm_interconnect_0_cpu_debug_mem_slave_writedata),           //                                .writedata
		.cpu_debug_mem_slave_byteenable          (mm_interconnect_0_cpu_debug_mem_slave_byteenable),          //                                .byteenable
		.cpu_debug_mem_slave_waitrequest         (mm_interconnect_0_cpu_debug_mem_slave_waitrequest),         //                                .waitrequest
		.cpu_debug_mem_slave_debugaccess         (mm_interconnect_0_cpu_debug_mem_slave_debugaccess),         //                                .debugaccess
		.jtag_uart_avalon_jtag_slave_address     (mm_interconnect_0_jtag_uart_avalon_jtag_slave_address),     //     jtag_uart_avalon_jtag_slave.address
		.jtag_uart_avalon_jtag_slave_write       (mm_interconnect_0_jtag_uart_avalon_jtag_slave_write),       //                                .write
		.jtag_uart_avalon_jtag_slave_read        (mm_interconnect_0_jtag_uart_avalon_jtag_slave_read),        //                                .read
		.jtag_uart_avalon_jtag_slave_readdata    (mm_interconnect_0_jtag_uart_avalon_jtag_slave_readdata),    //                                .readdata
		.jtag_uart_avalon_jtag_slave_writedata   (mm_interconnect_0_jtag_uart_avalon_jtag_slave_writedata),   //                                .writedata
		.jtag_uart_avalon_jtag_slave_waitrequest (mm_interconnect_0_jtag_uart_avalon_jtag_slave_waitrequest), //                                .waitrequest
		.jtag_uart_avalon_jtag_slave_chipselect  (mm_interconnect_0_jtag_uart_avalon_jtag_slave_chipselect),  //                                .chipselect
		.mem_Nios_PI_s1_address                  (mm_interconnect_0_mem_nios_pi_s1_address),                  //                  mem_Nios_PI_s1.address
		.mem_Nios_PI_s1_write                    (mm_interconnect_0_mem_nios_pi_s1_write),                    //                                .write
		.mem_Nios_PI_s1_readdata                 (mm_interconnect_0_mem_nios_pi_s1_readdata),                 //                                .readdata
		.mem_Nios_PI_s1_writedata                (mm_interconnect_0_mem_nios_pi_s1_writedata),                //                                .writedata
		.mem_Nios_PI_s1_byteenable               (mm_interconnect_0_mem_nios_pi_s1_byteenable),               //                                .byteenable
		.mem_Nios_PI_s1_chipselect               (mm_interconnect_0_mem_nios_pi_s1_chipselect),               //                                .chipselect
		.mem_Nios_PI_s1_clken                    (mm_interconnect_0_mem_nios_pi_s1_clken),                    //                                .clken
		.MTL_ip_s0_address                       (mm_interconnect_0_mtl_ip_s0_address),                       //                       MTL_ip_s0.address
		.MTL_ip_s0_write                         (mm_interconnect_0_mtl_ip_s0_write),                         //                                .write
		.MTL_ip_s0_read                          (mm_interconnect_0_mtl_ip_s0_read),                          //                                .read
		.MTL_ip_s0_readdata                      (mm_interconnect_0_mtl_ip_s0_readdata),                      //                                .readdata
		.MTL_ip_s0_writedata                     (mm_interconnect_0_mtl_ip_s0_writedata),                     //                                .writedata
		.MTL_ip_s0_waitrequest                   (mm_interconnect_0_mtl_ip_s0_waitrequest),                   //                                .waitrequest
		.sdram_controller_s1_address             (mm_interconnect_0_sdram_controller_s1_address),             //             sdram_controller_s1.address
		.sdram_controller_s1_write               (mm_interconnect_0_sdram_controller_s1_write),               //                                .write
		.sdram_controller_s1_read                (mm_interconnect_0_sdram_controller_s1_read),                //                                .read
		.sdram_controller_s1_readdata            (mm_interconnect_0_sdram_controller_s1_readdata),            //                                .readdata
		.sdram_controller_s1_writedata           (mm_interconnect_0_sdram_controller_s1_writedata),           //                                .writedata
		.sdram_controller_s1_byteenable          (mm_interconnect_0_sdram_controller_s1_byteenable),          //                                .byteenable
		.sdram_controller_s1_readdatavalid       (mm_interconnect_0_sdram_controller_s1_readdatavalid),       //                                .readdatavalid
		.sdram_controller_s1_waitrequest         (mm_interconnect_0_sdram_controller_s1_waitrequest),         //                                .waitrequest
		.sdram_controller_s1_chipselect          (mm_interconnect_0_sdram_controller_s1_chipselect),          //                                .chipselect
		.sysid_qsys_control_slave_address        (mm_interconnect_0_sysid_qsys_control_slave_address),        //        sysid_qsys_control_slave.address
		.sysid_qsys_control_slave_readdata       (mm_interconnect_0_sysid_qsys_control_slave_readdata),       //                                .readdata
		.timer_system_s1_address                 (mm_interconnect_0_timer_system_s1_address),                 //                 timer_system_s1.address
		.timer_system_s1_write                   (mm_interconnect_0_timer_system_s1_write),                   //                                .write
		.timer_system_s1_readdata                (mm_interconnect_0_timer_system_s1_readdata),                //                                .readdata
		.timer_system_s1_writedata               (mm_interconnect_0_timer_system_s1_writedata),               //                                .writedata
		.timer_system_s1_chipselect              (mm_interconnect_0_timer_system_s1_chipselect),              //                                .chipselect
		.timer_timestamp_s1_address              (mm_interconnect_0_timer_timestamp_s1_address),              //              timer_timestamp_s1.address
		.timer_timestamp_s1_write                (mm_interconnect_0_timer_timestamp_s1_write),                //                                .write
		.timer_timestamp_s1_readdata             (mm_interconnect_0_timer_timestamp_s1_readdata),             //                                .readdata
		.timer_timestamp_s1_writedata            (mm_interconnect_0_timer_timestamp_s1_writedata),            //                                .writedata
		.timer_timestamp_s1_chipselect           (mm_interconnect_0_timer_timestamp_s1_chipselect)            //                                .chipselect
	);

	Nios_sopc_irq_mapper irq_mapper (
		.clk           (clk_clk),                        //       clk.clk
		.reset         (rst_controller_reset_out_reset), // clk_reset.reset
		.receiver0_irq (irq_mapper_receiver0_irq),       // receiver0.irq
		.receiver1_irq (irq_mapper_receiver1_irq),       // receiver1.irq
		.receiver2_irq (irq_mapper_receiver2_irq),       // receiver2.irq
		.sender_irq    (cpu_irq_irq)                     //    sender.irq
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (1),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller (
		.reset_in0      (~reset_reset_n),                     // reset_in0.reset
		.clk            (clk_clk),                            //       clk.clk
		.reset_out      (rst_controller_reset_out_reset),     // reset_out.reset
		.reset_req      (rst_controller_reset_out_reset_req), //          .reset_req
		.reset_req_in0  (1'b0),                               // (terminated)
		.reset_in1      (1'b0),                               // (terminated)
		.reset_req_in1  (1'b0),                               // (terminated)
		.reset_in2      (1'b0),                               // (terminated)
		.reset_req_in2  (1'b0),                               // (terminated)
		.reset_in3      (1'b0),                               // (terminated)
		.reset_req_in3  (1'b0),                               // (terminated)
		.reset_in4      (1'b0),                               // (terminated)
		.reset_req_in4  (1'b0),                               // (terminated)
		.reset_in5      (1'b0),                               // (terminated)
		.reset_req_in5  (1'b0),                               // (terminated)
		.reset_in6      (1'b0),                               // (terminated)
		.reset_req_in6  (1'b0),                               // (terminated)
		.reset_in7      (1'b0),                               // (terminated)
		.reset_req_in7  (1'b0),                               // (terminated)
		.reset_in8      (1'b0),                               // (terminated)
		.reset_req_in8  (1'b0),                               // (terminated)
		.reset_in9      (1'b0),                               // (terminated)
		.reset_req_in9  (1'b0),                               // (terminated)
		.reset_in10     (1'b0),                               // (terminated)
		.reset_req_in10 (1'b0),                               // (terminated)
		.reset_in11     (1'b0),                               // (terminated)
		.reset_req_in11 (1'b0),                               // (terminated)
		.reset_in12     (1'b0),                               // (terminated)
		.reset_req_in12 (1'b0),                               // (terminated)
		.reset_in13     (1'b0),                               // (terminated)
		.reset_req_in13 (1'b0),                               // (terminated)
		.reset_in14     (1'b0),                               // (terminated)
		.reset_req_in14 (1'b0),                               // (terminated)
		.reset_in15     (1'b0),                               // (terminated)
		.reset_req_in15 (1'b0)                                // (terminated)
	);

endmodule
