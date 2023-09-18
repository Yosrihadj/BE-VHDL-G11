library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PWM_Generator_TB is
end PWM_Generator_TB;



architecture Testbench of PWM_Generator_TB is
   component PWM_Generator
      Port (
         clk : in std_logic;
         reset_n : in std_logic;
         freq: in std_logic_vector(7 downto 0);
         duty : in std_logic_vector(7 downto 0);
         pwm_out : out std_logic
      );
   end component;

	
   signal s_clk : std_logic := '0';
   signal s_reset_n : std_logic := '0';
   signal s_freq : std_logic_vector(7 downto 0) := "00110010"; 
   signal s_duty : std_logic_vector(7 downto 0) := "11001100"; 
   signal s_pwm_out : std_logic;

	
	
begin
   dut: PWM_Generator
      port map (
         clk => s_clk,
         reset_n => s_reset_n,
         freq => s_freq,
         duty => s_duty,
         pwm_out => s_pwm_out
      );

   process
   begin
      loop
         s_clk <= not s_clk;
         wait for 10ns;
      end loop;
   end process;

	process
   begin
      loop
			s_reset_n <='1';
         wait for 100us;
         --s_reset_n <='0';
         --wait for 100us;

      end loop;
   end process;
	
	process
   begin
      loop
	s_freq <=  "11001000"; --200
   s_duty <=  "01100100"; --100
	wait for 100us;
	--s_freq <=  "01100100"; --100
   --s_duty <=  "00011110"; --30
	--wait for 50us;
	end loop;
   end process;
	
	
	
end Testbench;
