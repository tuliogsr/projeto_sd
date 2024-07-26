library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity setesegmentos is
    Port (
        valor : in STD_LOGIC_VECTOR(3 downto 0);
        segmentos : out STD_LOGIC_VECTOR(6 downto 0)
    );
end setesegmentos;

architecture behave of setesegmentos is
begin
    with valor select
        segmentos <= "1000000" when "0000", -- 0
                   "1111001" when "0001", -- 1
                   "0100100" when "0010", -- 2
                   "0110000" when "0011", -- 3
                   "0011001" when "0100", -- 4
                   "1111111" when others; -- all segments off
end behave;
