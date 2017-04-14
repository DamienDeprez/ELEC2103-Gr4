	component Nios_sopc is
		port (
			clk_clk                         : in    std_logic                     := 'X';             -- clk
			data_addr_export                : out   std_logic_vector(6 downto 0);                     -- export
			data_read_export                : in    std_logic_vector(31 downto 0) := (others => 'X'); -- export
			data_we_export                  : out   std_logic;                                        -- export
			data_write_export               : out   std_logic_vector(31 downto 0);                    -- export
			mem_nios_pi_s2_address          : in    std_logic_vector(6 downto 0)  := (others => 'X'); -- address
			mem_nios_pi_s2_chipselect       : in    std_logic                     := 'X';             -- chipselect
			mem_nios_pi_s2_clken            : in    std_logic                     := 'X';             -- clken
			mem_nios_pi_s2_write            : in    std_logic                     := 'X';             -- write
			mem_nios_pi_s2_readdata         : out   std_logic_vector(31 downto 0);                    -- readdata
			mem_nios_pi_s2_writedata        : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			mem_nios_pi_s2_byteenable       : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			mtl_ip_mtl_b_export             : out   std_logic_vector(7 downto 0);                     -- export
			mtl_ip_mtl_dclk_export          : out   std_logic;                                        -- export
			mtl_ip_mtl_g_export             : out   std_logic_vector(7 downto 0);                     -- export
			mtl_ip_mtl_hsd_export           : out   std_logic;                                        -- export
			mtl_ip_mtl_r_export             : out   std_logic_vector(7 downto 0);                     -- export
			mtl_ip_mtl_touch_i2c_scl_export : out   std_logic;                                        -- export
			mtl_ip_mtl_touch_i2c_sda_export : inout std_logic                     := 'X';             -- export
			mtl_ip_mtl_touch_int_n_export   : in    std_logic                     := 'X';             -- export
			mtl_ip_mtl_vsd_export           : out   std_logic;                                        -- export
			mtl_ip_rst_dly_export           : in    std_logic                     := 'X';             -- export
			reset_reset_n                   : in    std_logic                     := 'X';             -- reset_n
			sdram_controller_addr           : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_controller_ba             : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_controller_cas_n          : out   std_logic;                                        -- cas_n
			sdram_controller_cke            : out   std_logic;                                        -- cke
			sdram_controller_cs_n           : out   std_logic;                                        -- cs_n
			sdram_controller_dq             : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_controller_dqm            : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_controller_ras_n          : out   std_logic;                                        -- ras_n
			sdram_controller_we_n           : out   std_logic;                                        -- we_n
			spi_clk_export                  : in    std_logic                     := 'X';             -- export
			spi_cs_export                   : in    std_logic                     := 'X';             -- export
			spi_miso_export                 : out   std_logic;                                        -- export
			spi_mosi_export                 : in    std_logic                     := 'X'              -- export
		);
	end component Nios_sopc;

	u0 : component Nios_sopc
		port map (
			clk_clk                         => CONNECTED_TO_clk_clk,                         --                      clk.clk
			data_addr_export                => CONNECTED_TO_data_addr_export,                --                data_addr.export
			data_read_export                => CONNECTED_TO_data_read_export,                --                data_read.export
			data_we_export                  => CONNECTED_TO_data_we_export,                  --                  data_we.export
			data_write_export               => CONNECTED_TO_data_write_export,               --               data_write.export
			mem_nios_pi_s2_address          => CONNECTED_TO_mem_nios_pi_s2_address,          --           mem_nios_pi_s2.address
			mem_nios_pi_s2_chipselect       => CONNECTED_TO_mem_nios_pi_s2_chipselect,       --                         .chipselect
			mem_nios_pi_s2_clken            => CONNECTED_TO_mem_nios_pi_s2_clken,            --                         .clken
			mem_nios_pi_s2_write            => CONNECTED_TO_mem_nios_pi_s2_write,            --                         .write
			mem_nios_pi_s2_readdata         => CONNECTED_TO_mem_nios_pi_s2_readdata,         --                         .readdata
			mem_nios_pi_s2_writedata        => CONNECTED_TO_mem_nios_pi_s2_writedata,        --                         .writedata
			mem_nios_pi_s2_byteenable       => CONNECTED_TO_mem_nios_pi_s2_byteenable,       --                         .byteenable
			mtl_ip_mtl_b_export             => CONNECTED_TO_mtl_ip_mtl_b_export,             --             mtl_ip_mtl_b.export
			mtl_ip_mtl_dclk_export          => CONNECTED_TO_mtl_ip_mtl_dclk_export,          --          mtl_ip_mtl_dclk.export
			mtl_ip_mtl_g_export             => CONNECTED_TO_mtl_ip_mtl_g_export,             --             mtl_ip_mtl_g.export
			mtl_ip_mtl_hsd_export           => CONNECTED_TO_mtl_ip_mtl_hsd_export,           --           mtl_ip_mtl_hsd.export
			mtl_ip_mtl_r_export             => CONNECTED_TO_mtl_ip_mtl_r_export,             --             mtl_ip_mtl_r.export
			mtl_ip_mtl_touch_i2c_scl_export => CONNECTED_TO_mtl_ip_mtl_touch_i2c_scl_export, -- mtl_ip_mtl_touch_i2c_scl.export
			mtl_ip_mtl_touch_i2c_sda_export => CONNECTED_TO_mtl_ip_mtl_touch_i2c_sda_export, -- mtl_ip_mtl_touch_i2c_sda.export
			mtl_ip_mtl_touch_int_n_export   => CONNECTED_TO_mtl_ip_mtl_touch_int_n_export,   --   mtl_ip_mtl_touch_int_n.export
			mtl_ip_mtl_vsd_export           => CONNECTED_TO_mtl_ip_mtl_vsd_export,           --           mtl_ip_mtl_vsd.export
			mtl_ip_rst_dly_export           => CONNECTED_TO_mtl_ip_rst_dly_export,           --           mtl_ip_rst_dly.export
			reset_reset_n                   => CONNECTED_TO_reset_reset_n,                   --                    reset.reset_n
			sdram_controller_addr           => CONNECTED_TO_sdram_controller_addr,           --         sdram_controller.addr
			sdram_controller_ba             => CONNECTED_TO_sdram_controller_ba,             --                         .ba
			sdram_controller_cas_n          => CONNECTED_TO_sdram_controller_cas_n,          --                         .cas_n
			sdram_controller_cke            => CONNECTED_TO_sdram_controller_cke,            --                         .cke
			sdram_controller_cs_n           => CONNECTED_TO_sdram_controller_cs_n,           --                         .cs_n
			sdram_controller_dq             => CONNECTED_TO_sdram_controller_dq,             --                         .dq
			sdram_controller_dqm            => CONNECTED_TO_sdram_controller_dqm,            --                         .dqm
			sdram_controller_ras_n          => CONNECTED_TO_sdram_controller_ras_n,          --                         .ras_n
			sdram_controller_we_n           => CONNECTED_TO_sdram_controller_we_n,           --                         .we_n
			spi_clk_export                  => CONNECTED_TO_spi_clk_export,                  --                  spi_clk.export
			spi_cs_export                   => CONNECTED_TO_spi_cs_export,                   --                   spi_cs.export
			spi_miso_export                 => CONNECTED_TO_spi_miso_export,                 --                 spi_miso.export
			spi_mosi_export                 => CONNECTED_TO_spi_mosi_export                  --                 spi_mosi.export
		);

