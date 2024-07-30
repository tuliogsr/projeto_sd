library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registrador is
    Port ( clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           d : in STD_LOGIC_VECTOR(9 downto 0);
           q : out STD_LOGIC_VECTOR(9 downto 0))
end registrador;

architecture behave of registrador is
begin
    process(clock, reset)
    begin
        if reset = '1' then
            q <= (others => '0');
        elsif rising_edge(clock) then
            q <= d;
        end if;
    end process;
end behave;
