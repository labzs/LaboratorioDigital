LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Gerador de Tom: divide o clock para gerar onda quadrada em audio
-- Frequencia gerada = clock_freq / (2 * divisor)
-- Exemplo (clock 50 MHz): divisor = 56818 -> La (A4) = 440 Hz
ENTITY tone_gen IS
    PORT (
        clock   : IN  STD_LOGIC;
        reset   : IN  STD_LOGIC;
        ativo   : IN  STD_LOGIC;                      -- '1' habilita geracao de tom
        divisor : IN  STD_LOGIC_VECTOR(16 DOWNTO 0);  -- meio-periodo em ciclos de clock
        audio   : OUT STD_LOGIC
    );
END ENTITY tone_gen;

ARCHITECTURE behavioral OF tone_gen IS
    SIGNAL contador : UNSIGNED(16 DOWNTO 0);
    SIGNAL s_audio  : STD_LOGIC;
BEGIN
    PROCESS (clock, reset)
    BEGIN
        IF reset = '1' THEN
            contador <= (OTHERS => '0');
            s_audio  <= '0';
        ELSIF rising_edge(clock) THEN
            IF ativo = '0' THEN
                contador <= (OTHERS => '0');
                s_audio  <= '0';
            ELSIF contador = UNSIGNED(divisor) - 1 THEN
                contador <= (OTHERS => '0');
                s_audio  <= NOT s_audio;
            ELSE
                contador <= contador + 1;
            END IF;
        END IF;
    END PROCESS;

    audio <= s_audio;
END ARCHITECTURE behavioral;
