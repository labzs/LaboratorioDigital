LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY jogo_tempo_reacao_uc IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        estimulo : IN STD_LOGIC;
        pronto_medidor : IN STD_LOGIC;
        erro_interface : IN STD_LOGIC;
        jogar : IN STD_LOGIC;
        pronto : OUT STD_LOGIC;
        iniciar : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY jogo_tempo_reacao_uc;

ARCHITECTURE arch OF jogo_tempo_reacao_uc IS
    TYPE tipo_estado IS (inicial, liga, modo, contador, fim, erro);
    SIGNAL estado, posterior : tipo_estado;
    SIGNAL liga_state : STD_LOGIC := '0';

BEGIN
    inicio : PROCESS (clock, reset)
    BEGIN
        IF reset = '1' THEN
            estado <= inicial;
        ELSIF clock'event AND clock = '1' THEN
            estado <= posterior;
        END IF;

    END PROCESS inicio;

    assinc : PROCESS (clock, estado, reset, jogar)
    BEGIN

        IF jogar = '1' AND estado = inicial THEN
            liga_state <= '1';
        ELSIF jogar = '0' AND rising_edge(clock) THEN
            liga_state <= '0';
        END IF;

    END PROCESS assinc;
    maquina : PROCESS (estado, liga_state, estimulo, pronto_medidor, erro_interface)
    BEGIN
        CASE estado IS
            WHEN inicial =>
                db_estado <= "0001"; --1
                pronto <= '0';
                iniciar <= '0';
                IF jogar = '1' OR liga_state = '1' THEN
                    posterior <= liga;
                ELSE
                    posterior <= inicial;
                END IF;

            WHEN liga =>
                db_estado <= "0010"; --2
                iniciar <= '1';
                IF erro_interface = '1' THEN
                    posterior <= erro;
                ELSIF selecao_modulo = '1' THEN
                    posterior <= modo;
                ELSE
                    posterior <= liga;
                END IF;

            WHEN modo =>
                db_estado <= "0011"; --3
                iniciar <= '1';
                IF modo1 = '1' XNOR modo2 ='1' THEN
                    posterior <= erro;
                ELSIF modo1 = '1' XOR modo2 ='1' THEN 
                    posterior <= contador;
                ELSE
                    posterior <= modo;
                END IF;

            WHEN contador =>
                db_estado <= "0100"; --4
                IF pronto_medidor = '1' THEN
                    posterior <= fim;
                ELSE
                    posterior <= contador;
                END IF;

            WHEN fim =>
                db_estado <= "0101"; --5
                pronto <= '1';
                iniciar <= '0';
                posterior <= inicial;

            WHEN erro =>
                iniciar <= '0';
                db_estado <= "0100";
                posterior <= erro;

        END CASE;
    END PROCESS maquina;
END ARCHITECTURE arch;