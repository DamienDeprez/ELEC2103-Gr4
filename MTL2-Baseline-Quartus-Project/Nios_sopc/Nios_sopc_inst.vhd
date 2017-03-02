	component Nios_sopc is
		port (
			clk_clk                         : in    std_logic                     := 'X';             -- clk
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
			mtl_ip_mtl_dclk_export          : out   std_logic;                                        -- export
			mtl_ip_mtl_hsd_export           : out   std_logic;                                        -- export
			mtl_ip_mtl_vsd_export           : out   std_logic;                                        -- export
			mtl_ip_mtl_touch_i2c_scl_export : out   std_logic;                                        -- export
			mtl_ip_mtl_touch_i2c_sda_export : inout std_logic                     := 'X';             -- export
			mtl_ip_mtl_touch_int_n_export   : in    std_logic                     := 'X';             -- export
			mtl_ip_mtl_r_export             : out   std_logic_vector(7 downto 0);                     -- export
			mtl_ip_mtl_g_export             : out   std_logic_vector(7 downto 0);                     -- export
			mtl_ip_mtl_b_export             : out   std_logic_vector(7 downto 0);                     -- export
			mtl_ip_rst_dly_export           : in    std_logic                     := 'X'              -- export
		);
	end component Nios_sopc;

	u0 : component Nios_sopc
		port map (
			clk_clk                         => CONNECTED_TO_clk_clk,                         --                      clk.clk
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
			mtl_ip_mtl_dclk_export          => CONNECTED_TO_mtl_ip_mtl_dclk_export,          --          mtl_ip_mtl_dclk.export
			mtl_ip_mtl_hsd_export           => CONNECTED_TO_mtl_ip_mtl_hsd_export,           --           mtl_ip_mtl_hsd.export
			mtl_ip_mtl_vsd_export           => CONNECTED_TO_mtl_ip_mtl_vsd_export,           --           mtl_ip_mtl_vsd.export
			mtl_ip_mtl_touch_i2c_scl_export => CONNECTED_TO_mtl_ip_mtl_touch_i2c_scl_export, -- mtl_ip_mtl_touch_i2c_scl.export
			mtl_ip_mtl_touch_i2c_sda_export => CONNECTED_TO_mtl_ip_mtl_touch_i2c_sda_export, -- mtl_ip_mtl_touch_i2c_sda.export
			mtl_ip_mtl_touch_int_n_export   => CONNECTED_TO_mtl_ip_mtl_touch_int_n_export,   --   mtl_ip_mtl_touch_int_n.export
			mtl_ip_mtl_r_export             => CONNECTED_TO_mtl_ip_mtl_r_export,             --             mtl_ip_mtl_r.export
			mtl_ip_mtl_g_export             => CONNECTED_TO_mtl_ip_mtl_g_export,             --             mtl_ip_mtl_g.export
			mtl_ip_mtl_b_export             => CONNECTED_TO_mtl_ip_mtl_b_export,             --             mtl_ip_mtl_b.export
			mtl_ip_rst_dly_export           => CONNECTED_TO_mtl_ip_rst_dly_export            --           mtl_ip_rst_dly.export
		);

