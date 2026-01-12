library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity grayscale is
    Port (
        R, G, B : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit inputs
        Y       : out STD_LOGIC_VECTOR(7 downto 0)    -- 8-bit output
    );
end grayscale;

architecture Behavioral of grayscale is
    signal temp : unsigned(15 downto 0);  -- Temporary 16-bit storage
begin
    -- Y = 0.299R + 0.587G + 0.114B (fixed-point math)
    temp <= (77 * unsigned(R) + 150 * unsigned(G) + 29 * unsigned(B)) / 256;
    Y <= std_logic_vector(temp(7 downto 0));  -- Take lower 8 bits
end Behavioral;