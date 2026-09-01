LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Modulo de Debouncing: filtra sinais de botoes mecanicos
-- Metodo: contador de estabilidade
-- Quando entrada estavel por N ciclos de clock, saida muda
-- Para clock 50MHz e N=250000 -> ~5ms debounce time (tipico para chaves mecanicas)

ENTITY debounce IS
    GENERIC (
        CLK_FREQ  : POSITIVE := 50000000;  -- Frequencia do clock em Hz
        DEBOUNCE_MS : POSITIVE := 20       -- Tempo de debounce em ms
    );
    PORT (
        clock   : IN  STD_LOGIC;
        reset   : IN  STD_LOGIC;
        entrada : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        saida   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END ENTITY debounce;

ARCHITECTURE behavioral OF debounce IS
    -- Calcula numero de ciclos de clock necessarios para DEBOUNCE_MS ms
    CONSTANT CONTADOR_MAX : POSITIVE := (CLK_FREQ / 1000) * DEBOUNCE_MS;
    
    TYPE contador_array IS ARRAY (7 DOWNTO 0) OF UNSIGNED(31 DOWNTO 0);
    SIGNAL contadores : contador_array;
    SIGNAL saida_int  : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
BEGIN
    
    PROCESS (clock, reset)
    BEGIN
        IF reset = '1' THEN
            saida_int <= (OTHERS => '0');
            FOR i IN 7 DOWNTO 0 LOOP
                contadores(i) <= (OTHERS => '0');
            END LOOP;
        ELSIF rising_edge(clock) THEN
            -- Para cada bit do vetor de entrada
            FOR i IN 7 DOWNTO 0 LOOP
                -- Se entrada diferente da saida, incrementa contador
                IF entrada(i) /= saida_int(i) THEN
                    IF contadores(i) = CONTADOR_MAX THEN
                        -- Contador atingiu máximo -> estável
                        saida_int(i) <= entrada(i);
                        contadores(i) <= (OTHERS => '0');
                    ELSE
                        contadores(i) <= contadores(i) + 1;
                    END IF;
                ELSE
                    -- Entrada = saida, reseta contador
                    contadores(i) <= (OTHERS => '0');
                END IF;
            END LOOP;
        END IF;
    END PROCESS;
    
    saida <= saida_int;
    
END ARCHITECTURE behavioral;
