library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TRAITEMENT is
  Port ( 
         raz_n : in STD_LOGIC;
         data_compas_in : in STD_LOGIC_VECTOR(8 downto 0);
         start_stop : in STD_LOGIC;
         clk1hz : in STD_LOGIC;
         continu : in STD_LOGIC; 
         data_valid : out STD_LOGIC;
         data_compas : out STD_LOGIC_VECTOR(8 downto 0)
         
  );
end TRAITEMENT;

architecture Behavioral of TRAITEMENT is
 
  signal data_valid_internal : STD_LOGIC := '0';
  signal fin_mesure : STD_LOGIC := '0';
  
  
begin
  
  process(clk1hz, raz_n)   --continu a 1 
  begin
    if raz_n = '0' then
     
      data_valid_internal <= '0';
     elsif rising_edge(clk1hz) then
	
    if continu = '1' then
    
    data_compas <= data_compas_in;
         data_valid_internal <= '1';
     elsif continu ='0' then 				--mode monocoup
         if start_stop ='1' then
		 if fin_mesure ='0' then
		 
		 data_compas  <= data_compas_in;
		 fin_mesure <='1' ;
		 end if;
         elsif start_stop ='0' then 
         data_valid_internal <= '0';
         fin_mesure <='0' ;
         
         end if;
         end if;
		 end if;
		 
        
  end process;
	
data_valid <= data_valid_internal;
	
end Behavioral;