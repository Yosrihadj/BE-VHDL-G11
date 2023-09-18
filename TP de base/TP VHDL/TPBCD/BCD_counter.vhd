library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Counter_BCD is
   Port (
      C : in std_logic;
      Input : in std_logic;
      reset : in std_logic;
      Load : in std_logic;
      Data : in std_logic_vector(3 downto 0);
      Output : out std_logic_vector(3 downto 0)
   );
end Counter_BCD;

architecture Behavioral of Counter_BCD is
   signal temp : std_logic_vector(3 downto 0) := "0000";
begin
   process (Input, C, reset, Load, Data)
   begin
      if reset = '1' then
         temp <= "0000";
      elsif rising_edge(Input) then
         if Load = '0' then
            temp <= Data; 
         elsif C = '0' then 
            if temp = "0000" then
               temp <= "1001"; 
            else
               temp <= temp - "0001"; 
            end if;
         else
            if temp = "1001" then
               temp <= "0000";
            else
               temp <= temp + "0001";
            end if;
         end if;
      end if;
   end process;

   Output <= temp;
end Behavioral;