library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex_decoder is
    Port ( sw  : in  STD_LOGIC_VECTOR (3 downto 0); -- 4 Switches (Binary Input)
           seg : out STD_LOGIC_VECTOR (6 downto 0); -- 7 Segments (gfedcba)
           an  : out STD_LOGIC_VECTOR (3 downto 0); -- 4 Anodes (Digit Select)
           dp  : out STD_LOGIC);                    -- Decimal Point
end hex_decoder;

architecture Behavioral of hex_decoder is
begin

    -- 1. ANODE CONTROL (Active Low)
    -- We only want the Rightmost Digit (Digit 0) to be ON.
    -- Pattern: 1110 (Digit3=OFF, Digit2=OFF, Digit1=OFF, Digit0=ON)
    an <= "1110"; 
    
    -- 2. DECIMAL POINT
    -- Turn it OFF (High Voltage = OFF for Common Anode)
    dp <= '1';

    -- 3. DECODER LOGIC (The Lookup Table)
    -- Sensitivity List: process(sw) means "Wake up whenever 'sw' changes"
    process(sw)
    begin
        case sw is
            -- Input (Switch)      Output (gfedcba) - Active Low
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0011001"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8 (Check: All Zeros)
            when "1001" => seg <= "0010000"; -- 9
            when "1010" => seg <= "0001000"; -- A
            when "1011" => seg <= "0000011"; -- b
            when "1100" => seg <= "1000110"; -- C
            when "1101" => seg <= "0100001"; -- d
            when "1110" => seg <= "0000110"; -- E
            when "1111" => seg <= "0001110"; -- F
            when others => seg <= "1111111"; -- OFF (Safety)
        end case;
    end process;

end Behavioral;