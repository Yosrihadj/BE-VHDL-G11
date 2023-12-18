-- Déclaration de la bibliothèque et de l'entité
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Clignotant_LED is
    Port ( clk : in STD_LOGIC;      -- Signal d'horloge
           led : out STD_LOGIC);   -- Signal de commande de la LED
end Clignotant_LED;

architecture Behavioral of Clignotant_LED is
    signal compteur : integer := 0;  -- Compteur pour diviser la fréquence
    signal freq_div : STD_LOGIC := '0';  -- Signal de division de la fréquence
    signal clignotements : integer := 0;  -- Compteur de clignotements

begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Diviser la fréquence par un certain nombre pour obtenir un clignotement visible
            if compteur = 50000000 then
                compteur <= 0;
                freq_div <= not freq_div;  -- Inverser le signal de division
            else
                compteur <= compteur + 1;
            end if;

            -- Allumer ou éteindre la LED en fonction du signal de division
            if freq_div = '1' then
                led <= '1';  -- LED allumée
            else
                led <= '0';  -- LED éteinte
            end if;

            -- Compteur de clignotements
            if freq_div = '1' then
                if clignotements < 2 then
                    clignotements <= clignotements + 1;
                else
                    clignotements <= 0;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
