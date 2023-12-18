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
    type StateType is (Idle, Manual, Auto, Babord, Tribord);
    signal current_state, next_state : StateType;
    signal code_function_internal : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal ledSTBY_internal : STD_LOGIC := '0';
    signal ledBabord_internal, ledTribord_internal : STD_LOGIC := '0';
    signal BP_STBY_last, BP_Babord_last, BP_Tribord_last : STD_LOGIC := '0';
    signal counter : integer range 0 to 49999999 := 0;
    signal clk_1Hz : STD_LOGIC := '0';
    signal blink_counter : integer range 0 to 49999999 := 0;
    constant BLINK_DURATION : integer := 50000000;

begin
    process (clk_50MHz, BP_STBY, BP_Babord, BP_Tribord)
    begin
        if rising_edge(clk_50MHz) then
            if counter = 49999999 then
                counter <= 0;
                clk_1Hz <= not clk_1Hz;
            else
                counter <= counter + 1;
            end if;

            if BP_STBY = '1' and BP_STBY_last = '0' then
                if current_state = Manual then
                    next_state <= Auto;
                    code_function_internal <= "0011";
                else
                    next_state <= Manual;
                    code_function_internal <= "0000";
                end if;
            elsif BP_Babord = '1' and BP_Babord_last = '0' then
                if current_state = Manual then
                    next_state <= Babord;
                    code_function_internal <= "0001";
                    ledBabord_internal <= '1';
                end if;
            elsif BP_Tribord = '1' and BP_Tribord_last = '0' then
                if current_state = Manual then
                    next_state <= Tribord;
                    code_function_internal <= "0010";
                    ledTribord_internal <= '1';
                end if;
            else
                next_state <= Manual;
                code_function_internal <= "0000";
            end if;

            if current_state = Auto then
                ledSTBY_internal <= '1';
            else
                if blink_counter < BLINK_DURATION / 2 then
                    ledSTBY_internal <= '1';
                else
                    ledSTBY_internal <= '0';
                end if;

                if blink_counter < BLINK_DURATION / 2 then
                    ledBabord_internal <= '1';
                    ledTribord_internal <= '1';
                else
                    ledBabord_internal <= '0';
                    ledTribord_internal <= '0';
                end if;

                if blink_counter < BLINK_DURATION then
                    blink_counter <= blink_counter + 1;
                end if;

                
            end if;
        end if;
    end process;
					ledBabord <= ledBabord_internal;
                ledTribord <= ledTribord_internal;
                current_state <= next_state;
                BP_STBY_last <= BP_STBY;
                BP_Babord_last <= BP_Babord;
                BP_Tribord_last <= BP_Tribord;
    code_function <= code_function_internal;
    ledSTBY <= ledSTBY_internal;

end Behavioral;
