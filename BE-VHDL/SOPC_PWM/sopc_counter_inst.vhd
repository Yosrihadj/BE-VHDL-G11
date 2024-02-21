	component sopc_counter is
		port (
			buttons_io_external_connection_export : in  std_logic_vector(1 downto 0) := (others => 'X'); -- export
			clk_clk                               : in  std_logic                    := 'X';             -- clk
			leds_io_external_connection_export    : out std_logic_vector(7 downto 0)                     -- export
		);
	end component sopc_counter;

	u0 : component sopc_counter
		port map (
			buttons_io_external_connection_export => CONNECTED_TO_buttons_io_external_connection_export, -- buttons_io_external_connection.export
			clk_clk                               => CONNECTED_TO_clk_clk,                               --                            clk.clk
			leds_io_external_connection_export    => CONNECTED_TO_leds_io_external_connection_export     --    leds_io_external_connection.export
		);

