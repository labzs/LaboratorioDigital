LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY registrador_recorde IS
    PORT (
        clock        : IN STD_LOGIC;
        reset        : IN STD_LOGIC;
        atualiza     : IN STD_LOGIC; -- Sinal vindo da UC quando o jogo acaba
        tempo_atual  : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- Supondo 4 dígitos BCD ou 16 bits
        recorde_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavioral OF registrador_recorde IS
    -- Iniciamos o recorde com o valor máximo (ex: 99.99) para que qualquer jogada seja menor
    SIGNAL s_recorde : unsigned(15 DOWNTO 0) := x"9999"; 
BEGIN
    PROCESS(clock, reset)
    BEGIN
        IF reset = '1' THEN
            s_recorde <= x"9999";
        ELSIF rising_edge(clock) THEN
            -- Se a UC mandar atualizar E o tempo atual for menor que o salvo
            IF atualiza = '1' THEN
                IF unsigned(tempo_atual) < s_recorde AND unsigned(tempo_atual) /= 0 THEN
                    s_recorde <= unsigned(tempo_atual);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    recorde_out <= std_logic_vector(s_recorde);
END ARCHITECTURE;