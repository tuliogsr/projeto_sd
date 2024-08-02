LIBRARY IEEE;
library setesegmentos.vhd;
library leitorsequencia.vhd;
library registrador.vhd;
library magnitude.vhd;
USE IEEE.std_logic_1164.ALL;

ENTITY batalha_naval IS
  PORT (clk: IN std_ulogic;
        rst: IN std_ulogic; -- reset assincrono
        pos_navio1 : IN STD_LOGIC_VECTOR(9 downto 0);
        pos_navio2 : IN STD_LOGIC_VECTOR(9 downto 0);
        ataque_pos1 : IN STD_LOGIC_VECTOR(9 downto 0);
        ataque_pos2 : IN STD_LOGIC_VECTOR(9 downto 0);
        BTN: IN std_ulogic;
        segmentos1 : out STD_ULOGIC_VECTOR(6 downto 0); 
        segmentos2 : out STD_ULOGIC_VECTOR(6 downto 0);
        O: OUT std_ulogic); 
END batalha_naval;

ARCHITECTURE behave OF batalha_naval IS

TYPE state_type IS (navio1, navio2, ataque1, ataque2, acerto1, acerto2, vitoria1, vitoria2);
SIGNAL next_state, current_state : state_type;
signal C, D : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal AC1 : STD_LOGIC_VECTOR(9 downto 0) := "0000000000";
signal AC2 : STD_LOGIC_VECTOR(9 downto 0) := "0000000000";
signal N1 : STD_LOGIC_VECTOR(9 downto 0);
signal N2 : STD_LOGIC_VECTOR(9 downto 0);
signal COMP1 : std_logic;
signal COMP2 : std_logic;
signal A, B : STD_LOGIC;
signal magnitude1, magnitude2 : std_logic;


component setesegmentos
        Port (
            valor : in STD_LOGIC_VECTOR(3 downto 0);
            segmentos : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
component leitorsequencia
        Port (
            x : in STD_LOGIC_VECTOR(9 downto 0);
            y : out STD_LOGIC
        );
    end component;
component registrador
        Port (
           clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           d : in STD_LOGIC_VECTOR(9 downto 0);
           q : out STD_LOGIC_VECTOR(9 downto 0))
        );
    end component;
component magnitude
        Port (
           NUM : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
           MAG : OUT STD_LOGIC
        );
    end component;


BEGIN
U1: setesegmentos
Port map (
      valor => C,
      segmentos => segmentos1
    );
U2: setesegmentos
Port map (
      valor => D,
      segmentos => segmentos2
    );
    
R1: registrador
    PORT MAP (
      clock => clk,
      reset => rst,
      d => pos_navio1,
      q => N1
    );

R2: registrador
    PORT MAP (
      clock => clk,
      reset => rst,
      d => pos_navio2,
      q => N2
    );
    
L1: leitorsequencia
Port map (
      x => N1,
      y => A
    );
L2: leitorsequencia
Port map (
      x => N2,
      y => B
    );
    
M1: magnitude
Port map (
      NUM => C,
      MAG => magnitude1
    );
M2: magnitude
Port map (
      NUM => D,
      MAG => magnitude2
    );
    

  state_register: PROCESS (rst, clk)
  BEGIN
    IF rst='1' THEN
      current_state <= navio1;
    ELSIF rising_edge(clk) THEN
      current_state <= next_state;
    END IF;
  END PROCESS;

  next_state_and_output_logic: PROCESS (current_state, A, B, BTN, COMP1, COMP2, C, D, AC1, AC2, magnitude1, magnitude2, ataque_pos1, ataque_pos2)
  BEGIN
    O <= '0';
    next_state <= current_state;
    CASE current_state IS
      WHEN navio1 =>
        IF A = '1' and BTN = '1' THEN
          next_state <= navio2;
        ELSIF A = '0' or BTN = '0' THEN
          next_state <= navio1;
        END IF;

      WHEN navio2 =>
        IF B = '1' and BTN = '1' THEN
          next_state <= ataque1;
        ELSIF B = '0' or BTN = '0' THEN
          next_state <= navio2;
        END IF;

      WHEN ataque1 =>
        IF COMP1 = '1' and BTN = '1' THEN
          next_state <= acerto1;
        ELSIF COMP1 = '0' and BTN = '1' THEN
          next_state <= ataque2;
        END IF;

      WHEN ataque2 =>
        IF COMP2 = '1' and BTN = '1' THEN
          next_state <= acerto2;
        ELSIF COMP2 = '0' and BTN = '1' THEN
          next_state <= ataque1;
        END IF;

      WHEN acerto1 =>
          C <= C + "0001";
          AC1 <= ataque_pos1 + 1;
        IF magnitude1 = '1' THEN
          next_state <= vitoria1;
        ELSIF magnitude1 = '0' THEN
          next_state <= ataque1;
        END IF;

      WHEN acerto2 =>
          D <= D + "0001";
          AC2 <= ataque_pos2 + 1;
        IF magnitude2 = '1' THEN
          next_state <= vitoria2;
        ELSIF magnitude2 = '0' THEN
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
