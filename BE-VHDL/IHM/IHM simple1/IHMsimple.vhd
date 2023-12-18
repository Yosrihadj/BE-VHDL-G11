library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IHMsimple is
    Port ( clk_50MHz : in STD_LOGIC;
           BP_STBY : in STD_LOGIC;
           code_function : out STD_LOGIC_VECTOR(3 downto 0);
           ledSTBY : out STD_LOGIC);
end IHMsimple;

architecture Behavioral of IHMsimple is
    type StateType is (Idle, Manual, Auto);
    signal current_state, next_state : StateType;
    signal code_function_internal : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal ledSTBY_internal : STD_LOGIC := '0';

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

begin
    process (clk_50MHz, BP_STBY)
begin
    if rising_edge(clk_50MHz) then
        if counter = 49999999 then
            counter <= 0;
            clk_1Hz <= not clk_1Hz; -- Inversion du signal à chaque seconde
        else
            counter <= counter + 1;
        end if;

        -- Détecter le front montant du bouton poussoir
        if BP_STBY = '1' and BP_STBY_last = '0' then
            -- Basculement entre Auto et Manuel
            if current_state = Manual then
                next_state <= Auto;
                code_function_internal <= "0011"; -- Si mode manuel, le code fonction est '0011'
            else
                next_state <= Manual;
                code_function_internal <= "0000"; -- Si mode automatique, le code fonction est '0000'
            end if;

            -- Initialiser le compteur pour le clignotement
            blink_counter <= 0;
        else
            next_state <= current_state;
        end if;

        -- Gérer le clignotement de la LED
        if current_state = Auto then
            ledSTBY_internal <= '1';-- En mode AUto, la LED reste allumée en permanence
				
        else
            -- En mode manual, la LED clignote une fois lors du changement de mode
            if blink_counter < BLINK_DURATION / 2 then
                ledSTBY_internal <= '1';  -- Activer la LED pendant la moitié de la durée
            else
                ledSTBY_internal <= '0';
            end if;

            -- Mettre à jour le compteur de clignotement
            if blink_counter < BLINK_DURATION then
                blink_counter <= blink_counter + 1;
            end if;
        end if;

        current_state <= next_state;
        BP_STBY_last <= BP_STBY;
    end if;
end process;

    code_function <= code_function_internal;
    ledSTBY <= ledSTBY_internal;

end Behavioral;