library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PWM_Generator is
   Port (
      clk : in std_logic;           
      reset_n : in std_logic;       
      --freq: in std_logic_vector(7 downto 0);  
      --duty : in std_logic_vector(7 downto 0); 
      pwm_out : out std_logic       -- PWM output
   );
end PWM_Generator;

architecture Behavioral of PWM_Generator is
   signal counter : std_logic_vector(7 downto 0) := (others => '0');
   signal duty_match : std_logic := '0';
   -- Constants for freq and duty
   constant freq_constant : std_logic_vector(7 downto 0) := "11001000"; -- 200 in binary
   constant duty_constant : std_logic_vector(7 downto 0) := "01100100"; -- 100 in binary


begin
   process (clk,reset_n)
   begin
      if reset_n = '0' then
        counter <= (others => '0'); 
      elsif rising_edge(clk) then
         if counter = freq_constant then
            counter <= (others => '0');  
         else
            counter <= counter + 1;  
         end if;
      end if;
   end process;

   process (counter)
   begin
      if counter < duty_constant then
         duty_match <= '1';  
      else
         duty_match <= '0';
      end if;
   end process;

   pwm_out <= duty_match;
end Behavioral;
