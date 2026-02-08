library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Needed for adding +1

entity top is
    Port ( clk : in  STD_LOGIC;                    -- 50 MHz Clock
           btn : in  STD_LOGIC_VECTOR (0 downto 0); -- Reset Button (BTN0)
           seg : out STD_LOGIC_VECTOR (6 downto 0); -- Segments
           an  : out STD_LOGIC_VECTOR (3 downto 0); -- Anodes
           dp  : out STD_LOGIC);                    -- Decimal Point
end top;

architecture Behavioral of top is

    -- Internal Signals (The "Wires" inside the chip)
    signal enable_tick : STD_LOGIC;                       -- The 1 Hz Heartbeat
    signal count_reg   : unsigned(3 downto 0) := "0000";  -- The Current Number (0-15)

begin

    -- 1. INSTANTIATE PULSE GENERATOR (The Heart)
    u_pulse : entity work.pulse_gen
    port map (
        clk   => clk,
        rst   => btn(0),
        pulse => enable_tick
    );

    -- 2. THE COUNTER (The Brain)
    process(clk)
    begin
        if rising_edge(clk) then
            if btn(0) = '1' then
                count_reg <= (others => '0'); -- Reset to 0
            elsif enable_tick = '1' then      -- Only count when Pulse says "GO"
                count_reg <= count_reg + 1;
            end if;
        end if;
    end process;

    -- 3. INSTANTIATE HEX DECODER (The Face)
    -- We map the "count_reg" (Internal) to "sw" (Decoder Input)
    u_decoder : entity work.hex_decoder
    port map (
        sw  => std_logic_vector(count_reg), -- Typecast: Unsigned -> Std_Logic
        seg => seg,
        an  => an,
        dp  => dp
    );

end Behavioral;