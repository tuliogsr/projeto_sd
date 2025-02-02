LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY magnitude IS
  PORT (
    NUM : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    MAG : OUT STD_LOGIC
  );
END magnitude;

ARCHITECTURE behave OF magnitude IS
BEGIN
  PROCESS (A)
  BEGIN
    IF A < "0100" THEN
      MAG <= '1';
    ELSE
      MAG <= '0';
    END IF;
  END PROCESS;
END behave;
