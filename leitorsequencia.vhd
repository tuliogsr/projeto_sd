library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity leitorsequencia is
    Port ( x : in STD_LOGIC_VECTOR(9 downto 0);
           y : out STD_LOGIC
          );
end leitorsequencia;

architecture behave of leitorsequencia is
    signal aux : STD_LOGIC_VECTOR(9 downto 0);
    signal a, b : STD_LOGIC;
begin
    process(x)
    begin
        a <= '0';
        b <= '0';
        aux <= x;
        
        for i in 0 to 9 loop
            if aux(i) = '1' then
                if (i = 0 or aux(i-1) = '0') and (i = 9 or aux(i+1) = '0') then
                    a <= '1';
                end if;
            end if;
        end loop;
        
        for i in 0 to 7 loop
            if aux(i) = '1' and aux(i+1) = '1' and aux(i+2) = '1' then
                b <= '1';
            end if;
        end loop;
        
        y <= a and b;
    end process;
end behave;
