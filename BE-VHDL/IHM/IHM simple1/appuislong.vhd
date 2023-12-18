-- Déclaration de la bibliothèque et de l'entité
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Appui_Long_LED is
    Port ( clk : in STD_LOGIC;         -- Signal d'horloge
           btn_babord : in STD_LOGIC;  -- Bouton-poussoir Babord
           led : out STD_LOGIC);       -- Signal de commande de la LED
end Appui_Long_LED;

architecture Behavioral of Appui_Long_LED is
    signal compteur : integer := 0;      -- Compteur pour diviser la fréquence
    signal appui_long : STD_LOGIC := '0'; -- Signal d'appui long

begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Diviser la fréquence par un certain nombre pour obtenir une temporisation
            if compteur = 50000000 then
                compteur <= 0;
                
                -- Mesurer la durée d'appui long
                if btn_babord = '0' then
                    appui_long <= '1';
                else
                    appui_long <= '0';
                end if;
                
            else
                compteur <= compteur + 1;
            end if;

            -- Activer la LED après un appui long de 3 secondes
            if appui_long = '1' and compteur = 150000000 then
                led <= '1';  -- LED allumée
            else
                led <= '0';  -- LED éteinte
            end if;
        end if;
    end process;

end Behavioral;
