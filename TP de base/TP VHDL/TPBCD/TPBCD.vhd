LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY segment IS
	PORT(D 	:IN std_logic_vector(3 downto 0);
		 reset : In std_logic;
		 S 	:OUT std_logic_vector(6 downto 0));
	END segment;
	
	ARCHITECTURE behaviour OF segment IS
BEGIN
    PROCESS(D, reset)
    BEGIN
        IF reset = '1' THEN
            S <= "1000000";
        ELSE
            CASE D IS
                WHEN "0000" =>
                    S <= "1000000";
                WHEN "0001" =>
                    S <= "1111001";
                WHEN "0010" =>
                    S <= "0100100";
                WHEN "0011" =>
                    S <= "0110000";
                WHEN "0100" =>
                    S <= "0011001";
                WHEN "0101" =>
                    S <= "0010010";
                WHEN "0110" =>
                    S <= "0000010";
                WHEN "0111" =>
                    S <= "1111000";
                WHEN "1000" =>
                    S <= "0000000";
                WHEN "1001" =>
                    S <= "0010000";
                WHEN OTHERS =>
                    S <= "1111111";
            END CASE;
        END IF;
    END PROCESS;
END behaviour;