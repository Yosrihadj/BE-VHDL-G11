library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ButtonControl is
    Port ( BP_Babord : in STD_LOGIC;
           BP_Tribord : in STD_LOGIC;
           BP_STBY : in STD_LOGIC;
           clk_50M : in STD_LOGIC;
           code_fonction : out STD_LOGIC_VECTOR(3 downto 0));
end ButtonControl;

architecture Behavioral of ButtonControl is
    -- Définition des états
    type State_Type is (MODE_MANUEL, MODE_AUTO);
    signal current_state, next_state : State_Type;

    -- Définition des constantes pour le diviseur de fréquence
    constant FREQ_DIVIDER : INTEGER := 5000000; -- 50,000,000 / 10
    signal count : INTEGER range 0 to FREQ_DIVIDER - 1 := 0;
    signal clk_10Hz : STD_LOGIC := '0';

    -- Définition des constantes pour le timer
    constant LONG_PRESS_THRESHOLD : INTEGER := 30000000; -- 3 secondes avec un clk de 10 Hz
    signal timer : INTEGER := 0;

    signal BP_STBY_last : STD_LOGIC := '0';
    signal BP_Babord_last : STD_LOGIC := '0';
    signal BP_Tribord_last : STD_LOGIC := '0';

begin
    process(clk_50M)
    begin
        if rising_edge(clk_50M) then
            -- Diviseur de fréquence pour obtenir un signal à 10 Hz
            if count = FREQ_DIVIDER - 1 then
                count <= 0;
                clk_10Hz <= not clk_10Hz;
            else
                count <= count + 1;
            end if;

            -- Transition d'état
            current_state <= next_state;	
            BP_STBY_last <= BP_STBY;
            BP_Babord_last <= BP_Babord;
            BP_Tribord_last <= BP_Tribord;

            case current_state is
                when MODE_MANUEL =>
                    -- Si BP_STBY passe de '0' à '1', passer à MODE_AUTO
                    if BP_STBY = '1' and BP_STBY_last = '0' then
                        next_state <= MODE_AUTO;
                        code_fonction <= "0011";
                    elsif BP_Babord = '1' and BP_Babord_last = '0' then
                        code_fonction <= "0001";
                        next_state <= MODE_MANUEL;
                    elsif BP_Tribord = '1' and BP_Tribord_last = '0' then
                        code_fonction <= "0010";
                        next_state <= MODE_MANUEL;
                    else
                        code_fonction <= "0000";
                    end if;

                when MODE_AUTO =>
                    -- Si BP_STBY passe de '0' à '1', passer à MODE_MANUEL
                    if BP_STBY = '1' and BP_STBY_last = '0' then
                        next_state <= MODE_MANUEL;
                        code_fonction <= "0000";
                    else
                        -- Si BP_Babord ou BP_Tribord passe de '0' à '1', démarrer le timer
                        if BP_Babord = '1' and BP_Babord_last = '0' then
                            timer <= timer + 1;
                        elsif BP_Tribord = '1' and BP_Tribord_last = '0' then
                            timer <= timer + 1;
                        else
                            timer <= 0;
                        end if;

                        -- Vérifier le timer pour déterminer si l'appui est court ou long
                        if timer < LONG_PRESS_THRESHOLD then
                            -- Appui court
                            if BP_Babord = '1' and BP_Babord_last = '0' then
                                code_fonction <= "0100";
                                next_state <= MODE_AUTO;
                            elsif BP_Tribord = '1' and BP_Tribord_last = '0' then
                                code_fonction <= "0111";
                                next_state <= MODE_AUTO;
                            else
                                code_fonction <= "0011";
                            end if;
                        else
                            -- Appui long
                            if BP_Babord = '1' and BP_Babord_last = '0' then
                                code_fonction <= "0101";
                                next_state <= MODE_AUTO;
                            elsif BP_Tribord = '1' and BP_Tribord_last = '0' then
                                code_fonction <= "0110";
                                next_state <= MODE_AUTO;
                            else
                                code_fonction <= "0011";
                            end if;
                        end if;
                    end if;

                when others =>
                    -- État par défaut, ne devrait pas se produire
                    next_state <= MODE_MANUEL;
                    code_fonction <= "0000";
            end case;
        end if;
    end process;
end Behavioral;