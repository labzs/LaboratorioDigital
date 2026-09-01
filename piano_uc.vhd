LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- FSM de Moore com 2 estados:
--   idle    : nenhum botao pressionado; liga='0'
--   tocando : pelo menos um botao pressionado; liga='1'

ENTITY piano_uc IS
    PORT (
        clock     : IN  STD_LOGIC;
        reset     : IN  STD_LOGIC;
        botoes    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        liga      : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC
    );
END ENTITY piano_uc;

ARCHITECTURE arch OF piano_uc IS
    TYPE tipo_estado IS (idle, tocando);
    SIGNAL estado, posterior : tipo_estado;
BEGIN

    seq : PROCESS (clock, reset)
    BEGIN
        IF reset = '1' THEN
            estado <= idle;
        ELSIF rising_edge(clock) THEN
            estado <= posterior;
        END IF;
    END PROCESS seq;

    comb : PROCESS (estado, botoes)
    BEGIN
        liga      <= '0';
        db_estado <= '0';
        posterior <= estado;

        CASE estado IS

            WHEN idle =>
                liga      <= '0';
                db_estado <= '0';
                IF botoes /= "00000000" THEN
                    posterior <= tocando;
                END IF;

            WHEN tocando =>
                liga      <= '1';
                db_estado <= '1';
                IF botoes = "00000000" THEN
                    posterior <= idle;
                END IF;

        END CASE;
    END PROCESS comb;

END ARCHITECTURE arch;
