LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY pulso_assincrono IS
    PORT (
        resposta_reset1 : IN STD_LOGIC;
        resposta_reset2 : IN STD_LOGIC;
        estimulo : IN STD_LOGIC;
        pulso1 : OUT STD_LOGIC
        pulso2 : OUT STD_LOGIC
        menor_tempo : OUT STD_LOGIC
    );
END ENTITY pulso_assincrono;

ARCHITECTURE arch OF pulso_assincrono IS
    SIGNAL pulso_int1 : STD_LOGIC := '0';
    SIGNAL pulso_int2 : STD_LOGIC := '0';
    SIGNAL menor_tempo_intern : STD_LOGIC := '0';
BEGIN
    resposta : PROCESS (resposta_reset, estimulo)
    BEGIN
        IF modo1 = '1' THEN
            IF resposta_reset1 = '0' AND estimulo = '1' THEN
                pulso_int <= '1';
            ELSE
                pulso_int <= '0';
            END IF;
         ELSIF modo2 = '1' THEN
            IF resposta_reset1 = '0' AND IF resposta_reset2 = '0' AND estimulo = '1' THEN
                pulso_int1 <= '1';
                pulso_int2 <= '1';
            ELSE
                pulso_int1 <= '0';
                pulso_int2 <= '0';
            END IF;       
    END PROCESS;

    pulso1 <= pulso_int1;
    pulso2 <= pulso_int2;
    menor_tempo <= menor_tempo_intern;

END ARCHITECTURE arch;