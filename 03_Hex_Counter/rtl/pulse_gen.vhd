library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pulse_gen is
    Port ( clk   : in  STD_LOGIC; -- 50 MHz Input
           rst   : in  STD_LOGIC; -- Reset Button
           pulse : out STD_LOGIC); -- 1 Hz "Tick"
end pulse_gen;

architecture Behavioral of pulse_gen is
    -- 50,000,000 cycles = 1 second
    constant MAX_COUNT : integer := 50000000 - 1;
    signal counter     : integer range 0 to MAX_COUNT := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                counter <= 0;
                pulse   <= '0';
            else
                if counter = MAX_COUNT then
                    counter <= 0;
                    pulse   <= '1'; -- Fire for 1 cycle!
                else
                    counter <= counter + 1;
                    pulse   <= '0';
                end if;
            end if;
        end if;
    end process;
end Behavioral;