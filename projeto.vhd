LIBRARY IEEE;

USE IEEE.std_logic_1164.ALL;

ENTITY batalha_naval IS
  PORT (clk: IN std_ulogic;
        rst: IN std_ulogic; -- reset assincrono
        A: IN std_ulogic;
        B: IN std_ulogic;
        BTN: IN std_ulogic;
        COMP1: IN std_ulogic;
        COMP2: IN std_ulogic;
        COMP3: IN std_ulogic; -- entrada da FSM
        O: OUT std_ulogic); -- saida da FSM
END batalha_naval;

ARCHITECTURE behave OF batalha_naval IS

TYPE state_type IS (navio1, navio2, ataque1, ataque2, acerto1, acerto2, vitoria1, vitoria2);
SIGNAL next_state, current_state : state_type;
signal C, D : std_logic;

BEGIN
  state_register: PROCESS (rst, clk)
  BEGIN
    IF rst='1' THEN
      current_state <= navio1;
    ELSIF rising_edge(clk) THEN
      current_state <= next_state;
    END IF;
  END PROCESS;

  next_state_and_output_logic: PROCESS (current_state, I)
  BEGIN
    O <= '0';
    next_state <= current_state;
    CASE current_state IS
      WHEN navio1 =>
        IF A = '1' THEN
          next_state <= navio2;
        ELSIF A = '0' THEN
          next_state <= navio1;
        END IF;
      WHEN navio2 =>
        IF B = '1' THEN
          next_state <= ataque1;
        ELSIF B = '0' THEN
          next_state <= navio2;
        END IF;
      WHEN ataque1 =>
        IF COMP1 = '1' THEN
          next_state <= acerto1;
        ELSIF COMP1 = '0' THEN
          next_state <= ataque2;
        END IF;
      WHEN ataque2 =>
        IF COMP2 = '1' THEN
          next_state <= acerto2;
        ELSIF COMP2 = '0' THEN
          next_state <= ataque1;
        END IF;
      WHEN acerto1 =>
        IF magnitude1 = '1' THEN
          next_state <= vitoria1;
        ELSIF magnitude1 = '0' THEN
          C <= C + 1;
          next_state <= ataque1;
        END IF;
      WHEN acerto2 =>
        IF magnitude2 = '1' THEN
          next_state <= vitoria2;
        ELSIF magnitude2 = '0' THEN
          D <= D + 1 ;
          next_state <= ataque2;
        END IF;
      WHEN vitoria1 =>
        next_state <= navio1;
      WHEN vitoria2 =>
        next_state <= navio1;
      WHEN OTHERS =>
        O <= '0';
        next_state <= navio1;
    END CASE;
  END PROCESS;

END behave;
