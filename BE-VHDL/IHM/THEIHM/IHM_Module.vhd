library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IHM_Module is
    Port (
        clk_50M    : in STD_LOGIC;
        BP_Babord  : in STD_LOGIC;
        BP_Tribord : in STD_LOGIC;
        BP_STBY    : in STD_LOGIC;
        ledBabord  : out STD_LOGIC;
        ledTribord : out STD_LOGIC;
        ledSTBY    : out STD_LOGIC;
        out_bip    : out STD_LOGIC;
        codeFonction : out STD_LOGIC_VECTOR(3 downto 0)
    );
end IHM_Module;

architecture Behavioral of IHM_Module is
    type State_Type is (MODE_MANUEL, MODE_AUTO, TEMPO_BP_BABORD, TEMPO_BP_TRIBORD);
    signal state : State_Type := MODE_MANUEL;
    signal codeFonctionSignal : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal tempo_counter : integer range 0 to 150000000; -- Assuming a 50 MHz clock
    signal blink_counter : integer range 0 to 25000000; -- Half-second blink rate for LEDs

    -- Constants for temporization
    constant TEMPO_SHORT : integer := 1000000; -- 1 second
    constant TEMPO_LONG : integer := 3000000; -- 3 seconds

begin
    process (clk_50M, BP_Babord, BP_Tribord, BP_STBY)
    begin
        if rising_edge(clk_50M) then
            -- Update LED blinking counters
            if blink_counter = 0 then
                blink_counter <= 25000000; -- Reset the blink counter every half-second
            else
                blink_counter <= blink_counter - 1;
            end if;

            -- State transitions and logic
            case state is
                when MODE_MANUEL =>
                    if BP_STBY = '1' then
                        codeFonctionSignal <= "0000";
                        state <= MODE_MANUEL;
                        ledSTBY <= '1' when (blink_counter = 25000000) else '0';
                        ledBabord <= '0';
                        ledTribord <= '0';
                        out_bip <= '0';
                    elsif BP_Babord = '1' then
                        codeFonctionSignal <= "0001";
                        state <= MODE_MANUEL;
                        ledSTBY <= '0';
                        ledBabord <= '1' when (blink_counter = 25000000) else '0';
                        ledTribord <= '0';
                        out_bip <= '1' when (blink_counter = 25000000) else '0';
                    elsif BP_Tribord = '1' then
                        codeFonctionSignal <= "0010";
                        state <= MODE_MANUEL;
                        ledSTBY <= '0';
                        ledBabord <= '0';
                        ledTribord <= '1' when (blink_counter = 25000000) else '0';
                        out_bip <= '0';
                    else
                        state <= MODE_MANUEL;
                    end if;

                when MODE_AUTO =>
                    if BP_STBY = '1' then
                        codeFonctionSignal <= "0011";
                        state <= MODE_MANUEL;
                        ledSTBY <= '1' when (blink_counter = 25000000) else '0';
                        ledBabord <= '0';
                        ledTribord <= '0';
                        out_bip <= '1' when (blink_counter = 25000000) else '0';
                    else
                        state <= MODE_AUTO;
                        ledSTBY <= '1' when (blink_counter = 25000000) else '0';
                        ledBabord <= '0';
                        ledTribord <= '0';
                        out_bip <= '1' when (blink_counter = 25000000) else '0';
                    end if;

                when TEMPO_BP_BABORD =>
                    if BP_Babord = '0' then
                        state <= MODE_AUTO;
                        ledSTBY <= '1' when (blink_counter = 25000000) else '0';
                        ledBabord <= '0';
                        ledTribord <= '0';
                        out_bip <= '1' when (blink_counter = 25000000) else '0';
                    elsif BP_Tribord = '1' then
                        codeFonctionSignal <= "0111";
                        state <= MODE_AUTO;
                        ledSTBY <= '0';
                        ledBabord <= '0';
                        ledTribord <= '1' when (blink_counter = 25000000) else '0';
                        out_bip <= '1' when (blink_counter = 25000000) else '0';
                    elsif tempo_counter = 0 then
                        codeFonctionSignal <= "0101";
                        state <= MODE_AUTO;
                        ledSTBY <= '0';
                        ledBabord <= '1' when (blink_counter = 25000000) else '0';
                        ledTribord <= '0';
                        out_bip <= '1' when (blink_counter = 25000000) else '0';
                    else
                        state <= TEMPO_BP_BABORD;
                        ledSTBY <= '0';
                        ledBabord <= '0';
                        ledTribord <= '0';
                        out_bip <= '0';
                    end if;

                when TEMPO_BP_TRIBORD =>
                    if BP_Tribord = '0' then
                        state <= MODE_AUTO;
                        ledSTBY <= '1' when (blink_counter = 25000000) else '0';
                        ledBabord <= '0';
                        ledTribord <= '0';
                        out_bip <= '1' when (blink_counter = 25000000) else '0';
                    elsif BP_Babord = '1' then
                        codeFonctionSignal <= "0100";
                        state <= MODE_AUTO;
                        ledSTBY <= '0';
                        ledBabord <= '1' when (blink_counter = 25000000) else '0';
                        ledTribord <= '0';
                        out_bip <= '1' when (blink_counter = 25000000) else '0';
                    elsif tempo_counter = 0 then
                        codeFonctionSignal <= "0110";
                        state <= MODE_AUTO;
                        ledSTBY <= '0';
                        ledBabord <= '0';
                        ledTribord <= '1' when (blink_counter = 25000000) else '0';
                        out_bip <= '1' when (blink_counter = 25000000) else '0';
                    else
                        state <= TEMPO_BP_TRIBORD;
                        ledSTBY <= '0';
                        ledBabord <= '0';
                        ledTribord <= '0';
                        out_bip <= '0';
                    end if;
            end case;

            -- Update temporization counter
            if tempo_counter > 0 then
                tempo_counter <= tempo_counter - 1;
            end if;

        end if;
    end process;

    codeFonction <= codeFonctionSignal;

end Behavioral;
