library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce is
    Port (
        clk     : in  STD_LOGIC;
        btn_in  : in  STD_LOGIC;
        btn_out : out STD_LOGIC
    );
end debounce;

architecture Behavioral of debounce is
    signal count : INTEGER := 0;
    signal stable : STD_LOGIC := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_in /= stable then
                count <= 0;
                stable <= btn_in;
            elsif count < 100000 then  -- ~1ms debounce at 100 MHz
                count <= count + 1;
            else
                btn_out <= stable;
            end if;
        end if;
    end process;
end Behavioral;