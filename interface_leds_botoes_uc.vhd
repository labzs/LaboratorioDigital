LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY interface_leds_botoes_uc IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        iniciar : IN STD_LOGIC;
        resposta1 : IN STD_LOGIC;
        resposta2 : IN STD_LOGIC;
        rco : IN STD_LOGIC;
        ligado : OUT STD_LOGIC;
        estimulo : OUT STD_LOGIC;
        erro : OUT STD_LOGIC;
        pronto : OUT STD_LOGIC;
        contaCont : OUT STD_LOGIC;
        burlou_assinc : OUT STD_LOGIC;
        zeraCont : OUT STD_LOGIC;
        db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        atualiza_recorde : OUT STD_LOGIC;
    );
END ENTITY interface_leds_botoes_uc;

ARCHITECTURE arch OF interface_leds_botoes_uc IS
    TYPE tipo_estado IS (inicial, liga, modo, conta, fim, burlou, recorde, resposta2);
    SIGNAL estado, posterior : tipo_estado;
    SIGNAL burla_state, fim_state, liga_state : STD_LOGIC := '0';

BEGIN
    inicio : PROCESS (clock, reset)
    BEGIN
        IF reset = '1' THEN
            estado <= inicial;
        ELSIF clock'event AND clock = '1' THEN
            estado <= posterior;
        END IF;

    END PROCESS inicio;

    assinc : PROCESS (clock, estado, resposta, iniciar, reset)
    BEGIN
        IF resposta = '1' AND estado = liga THEN
            burlou_assinc <= '1';
            burla_state <= '1';
        ELSIF reset = '1' THEN
            burlou_assinc <= '0';
            burla_state <= '0';
        END IF;

        IF modo1 ='1' AND resposta1 = '1' AND estado = conta THEN
            fim_state <= '1';
        ELSIF modo2 ='1' AND resposta1 = '1' AND resposta2 = '1'  AND estado = conta THEN
            fim_state <= '1';    
        ELSIF rising_edge(clock) THEN
            fim_state <= '0';
        END IF;

        IF iniciar = '1' AND estado = inicial THEN
            liga_state <= '1';
        ELSIF iniciar = '0' AND rising_edge(clock) THEN
            liga_state <= '0';
        END IF;
    END PROCESS assinc;

    maquina : PROCESS (estado, resposta, rco, iniciar)
    BEGIN
        CASE estado IS
            WHEN inicial =>
                db_estado <= "0001"; --1
                contaCont <= '0';
                ligado <= '0';
                erro <= '0';
                estimulo <= '0';
                pronto <= '0';
                zeraCont <= '1';
                IF iniciar = '1' OR liga_state = '1' THEN
                    posterior <= liga;
                ELSE
                    posterior <= inicial;
                END IF;

            WHEN liga =>
                db_estado <= "0010"; --2
                zeraCont <= '0';
                contaCont <= '1';
                ligado <= '1';
                IF rco = '1' THEN
                    posterior <= modo;
                ELSIF resposta = '1' OR burla_state = '1' THEN
                    posterior <= burlou;
                ELSE
                    posterior <= liga;
                END IF;
            
             WHEN modo =>
                db_estado <= "0011"; --3
                zeraCont <= '1';
                contaCont <= '1';
                ligado <= '1';
                IF rco = '1' THEN
                    posterior <= conta;
                ELSIF (resposta1 = '1'OR resposta2 = '1' OR burla_state = '1') OR (modo1 XNOR modo2 = '1') THEN
                    posterior <= burlou;
                ELSE
                    posterior <= modo;
                END IF;

            WHEN conta =>
                db_estado <= "0100"; --4
                estimulo <= '1';
                contaCont <= '0';
                IF modo1 = '1'AND (resposta1 = '1' OR fim_state = '1') THEN
                    posterior <= fim;
                ELSIF modo2 = '1' THEN
                    IF (resposta1 = '1' AND resposta2 = '1') OR fim_state = '1' THEN
                        posterior <= fim;                     
                ELSE
                    posterior <= conta;
                END IF;

            WHEN fim =>
                db_estado <= "0101"; --5
                estimulo <= '0';
                pronto <= '1';
                ligado <= '0';
                zeraCont <= '1'; -- Contagem pra passar pro estado seguinte
                contaCont <= '1';
                atualiza_recorde <= '1'; -- Pulso para salvar se for menor
                IF modo1 = '1' AND (rco = '1') THEN
                    posterior <= recorde;
                ELSIF modo2 = '1' AND (rco = '1') THEN
                    posterior <= resposta2;
                ELSE
                    posterior <= fim;
                END IF;
            
             WHEN resposta2 =>
                 zeraCont <= '1';
                 contaCont <= '1';
                 db_estado <= "0110"; --6
                atualiza_recorde <= '1'; -- Pulso para salvar se for menor
                IF rco = '1' THEN
                    posterior <= recorde;
                ELSE
                    posterior <= resposta2;
                END IF;
                
            WHEN recorde =>
                db_estado <= "0111"; --7
                IF iniciar = '0' THEN
                    posterior <= inicial;
                ELSE
                    posterior <= recorde;
                END IF;

            WHEN burlou =>
                contaCont <= '0';
                erro <= '1';
                ligado <= '0';
                db_estado <= "1001"; --9
                IF (resposta1 = '0' AND resposta2 = '0') THEN
                    posterior <= inicial;
                ELSE
                    posterior <= burlou;
                END IF;
        END CASE;
    END PROCESS maquina;
END ARCHITECTURE arch;