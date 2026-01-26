library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity blinky is
    Port ( 
        clk_50mhz : in  STD_LOGIC;  -- The 50MHz clock from the board
        led_out   : out STD_LOGIC   -- The signal going to the LED
    );
end blinky;

architecture Behavioral of blinky is
    -- We need a counter to slow down the clock.
    -- 50MHz = 50,000,000 ticks per second.
    -- Log2(50,000,000) is approx 25.5, so we need a 26-bit counter.
    signal counter : unsigned(25 downto 0) := (others => '0');
    
begin

    process(clk_50mhz)
    begin
        if rising_edge(clk_50mhz) then
            -- Increment counter every clock cycle
            counter <= counter + 1;
        end if;
    end process;

    -- Connect the most significant bit (MSB) to the LED.
    -- This bit flips roughly every 0.67 seconds (2^25 / 50MHz).
    led_out <= counter(25);

end Behavioral;