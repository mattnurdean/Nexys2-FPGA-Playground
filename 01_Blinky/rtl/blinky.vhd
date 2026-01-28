library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity blinky is
    Port ( clk : in  STD_LOGIC;
           sw  : in  STD_LOGIC_VECTOR (0 downto 0); -- The Switch Input
           led : out STD_LOGIC_VECTOR (0 downto 0)  -- The LED Output
           );
end blinky;

architecture Behavioral of blinky is
    signal counter : unsigned(25 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;
            
            -- SWITCH LOGIC (Matches Python & UVM)
            if sw(0) = '1' then
                led(0) <= counter(25); -- Use Bit 25 for Real Board (0.6s blink)
            else
                led(0) <= '0';
            end if;
        end if;
    end process;
end Behavioral;