	component unsaved is
		port (
			clk_clk                        : in    std_logic                     := 'X';             -- clk
			mtl_ip_0_conduit_end_export    : out   std_logic;                                        -- export
			mtl_ip_0_conduit_end_1_export  : out   std_logic;                                        -- export
			mtl_ip_0_conduit_end_10_export : out   std_logic;                                        -- export
			mtl_ip_0_conduit_end_11_export : out   std_logic;                                        -- export
			mtl_ip_0_conduit_end_12_export : out   std_logic;                                        -- export
			mtl_ip_0_conduit_end_13_export : out   std_logic;                                        -- export
			mtl_ip_0_conduit_end_14_export : inout std_logic_vector(15 downto 0) := (others => 'X'); -- export
			mtl_ip_0_conduit_end_15_export : out   std_logic_vector(1 downto 0);                     -- export
			mtl_ip_0_conduit_end_16_export : out   std_logic;                                        -- export
			mtl_ip_0_conduit_end_17_export : out   std_logic;                                        -- export
			mtl_ip_0_conduit_end_18_export : in    std_logic                     := 'X';             -- export
			mtl_ip_0_conduit_end_19_export : in    std_logic                     := 'X';             -- export
			mtl_ip_0_conduit_end_2_export  : out   std_logic;                                        -- export
			mtl_ip_0_conduit_end_20_export : in    std_logic                     := 'X';             -- export
			mtl_ip_0_conduit_end_21_export : out   std_logic;                                        -- export
			mtl_ip_0_conduit_end_3_export  : inout std_logic                     := 'X';             -- export
			mtl_ip_0_conduit_end_4_export  : in    std_logic                     := 'X';             -- export
			mtl_ip_0_conduit_end_5_export  : out   std_logic_vector(7 downto 0);                     -- export
			mtl_ip_0_conduit_end_6_export  : out   std_logic_vector(7 downto 0);                     -- export
			mtl_ip_0_conduit_end_7_export  : out   std_logic_vector(7 downto 0);                     -- export
			mtl_ip_0_conduit_end_8_export  : out   std_logic_vector(12 downto 0);                    -- export
			mtl_ip_0_conduit_end_9_export  : out   std_logic_vector(1 downto 0);                     -- export
			mtl_ip_0_mtl_conduit_export    : out   std_logic;                                        -- export
			reset_reset_n                  : in    std_logic                     := 'X';             -- reset_n
			system_sdram_wire_addr         : out   std_logic_vector(11 downto 0);                    -- addr
			system_sdram_wire_ba           : out   std_logic_vector(1 downto 0);                     -- ba
			system_sdram_wire_cas_n        : out   std_logic;                                        -- cas_n
			system_sdram_wire_cke          : out   std_logic;                                        -- cke
			system_sdram_wire_cs_n         : out   std_logic;                                        -- cs_n
			system_sdram_wire_dq           : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
			system_sdram_wire_dqm          : out   std_logic_vector(3 downto 0);                     -- dqm
			system_sdram_wire_ras_n        : out   std_logic;                                        -- ras_n
			system_sdram_wire_we_n         : out   std_logic                                         -- we_n
		);
	end component unsaved;

	u0 : component unsaved
		port map (
			clk_clk                        => CONNECTED_TO_clk_clk,                        --                     clk.clk
			mtl_ip_0_conduit_end_export    => CONNECTED_TO_mtl_ip_0_conduit_end_export,    --    mtl_ip_0_conduit_end.export
			mtl_ip_0_conduit_end_1_export  => CONNECTED_TO_mtl_ip_0_conduit_end_1_export,  --  mtl_ip_0_conduit_end_1.export
			mtl_ip_0_conduit_end_10_export => CONNECTED_TO_mtl_ip_0_conduit_end_10_export, -- mtl_ip_0_conduit_end_10.export
			mtl_ip_0_conduit_end_11_export => CONNECTED_TO_mtl_ip_0_conduit_end_11_export, -- mtl_ip_0_conduit_end_11.export
			mtl_ip_0_conduit_end_12_export => CONNECTED_TO_mtl_ip_0_conduit_end_12_export, -- mtl_ip_0_conduit_end_12.export
			mtl_ip_0_conduit_end_13_export => CONNECTED_TO_mtl_ip_0_conduit_end_13_export, -- mtl_ip_0_conduit_end_13.export
			mtl_ip_0_conduit_end_14_export => CONNECTED_TO_mtl_ip_0_conduit_end_14_export, -- mtl_ip_0_conduit_end_14.export
			mtl_ip_0_conduit_end_15_export => CONNECTED_TO_mtl_ip_0_conduit_end_15_export, -- mtl_ip_0_conduit_end_15.export
			mtl_ip_0_conduit_end_16_export => CONNECTED_TO_mtl_ip_0_conduit_end_16_export, -- mtl_ip_0_conduit_end_16.export
			mtl_ip_0_conduit_end_17_export => CONNECTED_TO_mtl_ip_0_conduit_end_17_export, -- mtl_ip_0_conduit_end_17.export
			mtl_ip_0_conduit_end_18_export => CONNECTED_TO_mtl_ip_0_conduit_end_18_export, -- mtl_ip_0_conduit_end_18.export
			mtl_ip_0_conduit_end_19_export => CONNECTED_TO_mtl_ip_0_conduit_end_19_export, -- mtl_ip_0_conduit_end_19.export
			mtl_ip_0_conduit_end_2_export  => CONNECTED_TO_mtl_ip_0_conduit_end_2_export,  --  mtl_ip_0_conduit_end_2.export
			mtl_ip_0_conduit_end_20_export => CONNECTED_TO_mtl_ip_0_conduit_end_20_export, -- mtl_ip_0_conduit_end_20.export
			mtl_ip_0_conduit_end_21_export => CONNECTED_TO_mtl_ip_0_conduit_end_21_export, -- mtl_ip_0_conduit_end_21.export
			mtl_ip_0_conduit_end_3_export  => CONNECTED_TO_mtl_ip_0_conduit_end_3_export,  --  mtl_ip_0_conduit_end_3.export
			mtl_ip_0_conduit_end_4_export  => CONNECTED_TO_mtl_ip_0_conduit_end_4_export,  --  mtl_ip_0_conduit_end_4.export
			mtl_ip_0_conduit_end_5_export  => CONNECTED_TO_mtl_ip_0_conduit_end_5_export,  --  mtl_ip_0_conduit_end_5.export
			mtl_ip_0_conduit_end_6_export  => CONNECTED_TO_mtl_ip_0_conduit_end_6_export,  --  mtl_ip_0_conduit_end_6.export
			mtl_ip_0_conduit_end_7_export  => CONNECTED_TO_mtl_ip_0_conduit_end_7_export,  --  mtl_ip_0_conduit_end_7.export
			mtl_ip_0_conduit_end_8_export  => CONNECTED_TO_mtl_ip_0_conduit_end_8_export,  --  mtl_ip_0_conduit_end_8.export
			mtl_ip_0_conduit_end_9_export  => CONNECTED_TO_mtl_ip_0_conduit_end_9_export,  --  mtl_ip_0_conduit_end_9.export
			mtl_ip_0_mtl_conduit_export    => CONNECTED_TO_mtl_ip_0_mtl_conduit_export,    --    mtl_ip_0_mtl_conduit.export
			reset_reset_n                  => CONNECTED_TO_reset_reset_n,                  --                   reset.reset_n
			system_sdram_wire_addr         => CONNECTED_TO_system_sdram_wire_addr,         --       system_sdram_wire.addr
			system_sdram_wire_ba           => CONNECTED_TO_system_sdram_wire_ba,           --                        .ba
			system_sdram_wire_cas_n        => CONNECTED_TO_system_sdram_wire_cas_n,        --                        .cas_n
			system_sdram_wire_cke          => CONNECTED_TO_system_sdram_wire_cke,          --                        .cke
			system_sdram_wire_cs_n         => CONNECTED_TO_system_sdram_wire_cs_n,         --                        .cs_n
			system_sdram_wire_dq           => CONNECTED_TO_system_sdram_wire_dq,           --                        .dq
			system_sdram_wire_dqm          => CONNECTED_TO_system_sdram_wire_dqm,          --                        .dqm
			system_sdram_wire_ras_n        => CONNECTED_TO_system_sdram_wire_ras_n,        --                        .ras_n
			system_sdram_wire_we_n         => CONNECTED_TO_system_sdram_wire_we_n          --                        .we_n
		);

