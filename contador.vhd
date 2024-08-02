library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity contador is 
	port(clock, reset, enable, option : in std_logic;
		q : out std_logic_vector(3 downto 0));
end contador;

architecture behavioral of contador is 
begin 
	process( clock, reset)
	variable sum : integer range 0 to 10;
	begin 
		if reset = '1' then 
			sum :=0;
		elsif (rising_edge(clock) and enable = '1' )then 
			if (option = '1') then 
				sum := sum + 1;
			elsif (option = '1' and (sum /= 0)) then 
				sum := sum - 1;
			end if;
		end if;
	q <= conv_std_logic_vector(sum, 4);
	end process;
end behavioral;
			