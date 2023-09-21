
module sopc_counter (
	buttons_io_external_connection_export,
	clk_clk,
	leds_io_external_connection_export);	

	input	[1:0]	buttons_io_external_connection_export;
	input		clk_clk;
	output	[7:0]	leds_io_external_connection_export;
endmodule
