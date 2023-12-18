library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IHMsimpletest2 is
    Port ( clk_50MHz : in STD_LOGIC;
           BP_STBY, BP_Babord, BP_Tribord : in STD_LOGIC;
           code_function : out STD_LOGIC_VECTOR(3 downto 0);
           ledSTBY, ledBabord, ledTribord : out STD_LOGIC);
end IHMsimpletest2;


architecture Behavioral of IHMsimpletest2 is
    type StateType is (Idle, Manual, Auto, Babord, Tribord); -- Ajout des états Babord et Tribord
    signal current_state, next_state : StateType;
    signal code_function_internal : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal ledSTBY_internal : STD_LOGIC := '0';
    signal ledBabord_internal, ledTribord_internal : STD_LOGIC := '0'; -- Ajout des signaux pour les LEDs Babord et Tribord
 
 -- Signal pour détecter le front montant du bouton poussoir
    signal BP_STBY_last : STD_LOGIC := '0';

    -- Compteur pour diviser la fréquence
    signal counter : integer range 0 to 49999999 := 0;

    -- Signal d'horloge de 1 Hz
    signal clk_1Hz : STD_LOGIC := '0';

    -- Compteur pour le clignotement
    signal blink_counter : integer range 0 to 49999999 := 0;

    -- Constante pour la durée du clignotement (1 seconde)
    constant BLINK_DURATION : integer := 50000000;

    -- ... (autres signaux et constantes restent inchangés)

begin

    process (clk_50MHz, BP_STBY, BP_Babord, BP_Tribord) -- Ajout des signaux BP_Babord et BP_Tribord
    begin
        if rising_edge(clk_50MHz) then
            if counter = 49999999 then
                counter <= 0;
                clk_1Hz <= not clk_1Hz; -- Inversion du signal à chaque seconde
            else
                counter <= counter + 1;
            end if;

            -- Détecter le front montant du bouton poussoir BP_STBY
            if BP_STBY = '1' and BP_STBY_last = '0' then
                --case current_state is
					 if current_state = Manual then
                    --when Manual =>
                        -- Basculement entre Auto, Babord et Tribord
                        if BP_Babord = '1' then
                            next_state <= Babord;
                            code_function_internal <= "0001"; -- Si BP_Babord pressé, le code fonction est '0001'
                            ledBabord_internal <= '1'; -- Activer la LED Babord
                        elsif BP_Tribord = '1' then
                            next_state <= Tribord;
                            code_function_internal <= "0010"; -- Si BP_Tribord pressé, le code fonction est '0010'
                            ledTribord_internal <= '1'; -- Activer la LED Tribord
                        else
                            -- Reste du code pour le basculement entre Auto et Manual (comme avant)
                            if current_state = Manual then
                                next_state <= Auto;
                                code_function_internal <= "0011";
                            else
                                next_state <= Manual;
                                code_function_internal <= "0000";
                            end if;
                        end if;
					 end if;
                        -- Initialiser le compteur pour le clignotement
                        blink_counter <= 0;
                 --   when others => 
							--	next_state <= current_state;
                        -- Reste du code pour les autres états (Auto, Babord, Tribord) inchangé
                        -- ... 
                --end case;
            else
                next_state <= current_state;
            end if;

            -- Gérer le clignotement des LEDs Babord et Tribord
            if blink_counter < BLINK_DURATION / 2 then
                ledBabord_internal <= '0';  -- Activer la LED Babord pendant la moitié de la durée
                ledTribord_internal <= '0'; -- Activer la LED Tribord pendant la moitié de la durée
            else
                ledBabord_internal <= '0';
                ledTribord_internal <= '0';
            end if;

            -- Mettre à jour le compteur de clignotement
            if blink_counter < BLINK_DURATION then
                blink_counter <= blink_counter + 1;
            end if;

            -- Mettre à jour les LEDs Babord et Tribord
            ledBabord <= ledBabord_internal;
            ledTribord <= ledTribord_internal;

            current_state <= next_state;
            BP_STBY_last <= BP_STBY;
        end if;
    end process;

    code_function <= code_function_internal;
    ledSTBY <= ledSTBY_internal;

end Behavioral;
