-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
-- CREATED		"Mon Sep 18 11:33:03 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY sopc_counters IS 
	PORT
	(
		clk_clk :  IN  STD_LOGIC;
		buttons_export :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		leds_export :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END sopc_counters;

ARCHITECTURE bdf_type OF sopc_counters IS 

COMPONENT sopc_counter
	PORT(clk_clk : IN STD_LOGIC;
		 buttons_io_external_connection_export : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 leds_io_external_connection_export : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;



BEGIN 



b2v_inst : sopc_counter
PORT MAP(clk_clk => clk_clk,
		 buttons_io_external_connection_export => buttons_export,
		 leds_io_external_connection_export => leds_export);


END bdf_type;