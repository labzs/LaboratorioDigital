LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Piano Digital - Top Level (Experiencia 9)
-- Instancia a Unidade de Controle e o Fluxo de Dados conforme
-- arquitetura hierarquica estrutural exigida pelo projeto.
-- CORRIGIDO: Adicionado debouncing dos botoes

ENTITY piano_top IS
    PORT (
        clock   : IN  STD_LOGIC;
        reset_n : IN  STD_LOGIC;
        botoes  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        audio   : OUT STD_LOGIC;
        led_r   : OUT STD_LOGIC;
        led_g   : OUT STD_LOGIC;
        led_b   : OUT STD_LOGIC;
        hex0    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY piano_top;

ARCHITECTURE structural OF piano_top IS

    COMPONENT piano_uc IS
        PORT (
            clock     : IN  STD_LOGIC;
            reset     : IN  STD_LOGIC;
            botoes    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            liga      : OUT STD_LOGIC;
            db_estado : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT piano_fd IS
        PORT (
            clock  : IN  STD_LOGIC;
            reset  : IN  STD_LOGIC;
            liga   : IN  STD_LOGIC;
            botoes : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            audio  : OUT STD_LOGIC;
            led_r  : OUT STD_LOGIC;
            led_g  : OUT STD_LOGIC;
            led_b  : OUT STD_LOGIC;
            hex0   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT debounce IS
        GENERIC (
            CLK_FREQ     : POSITIVE := 50000000;
            DEBOUNCE_MS  : POSITIVE := 20
        );
        PORT (
            clock   : IN  STD_LOGIC;
            reset   : IN  STD_LOGIC;
            entrada : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            saida   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL reset_int    : STD_LOGIC;
    SIGNAL liga_s       : STD_LOGIC;
    SIGNAL botoes_db_s  : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    reset_int <= NOT reset_n;

    -- Instancia modulo de debouncing dos botoes
    U_DEBOUNCE : debounce
    GENERIC MAP (
        CLK_FREQ     => 50000000,  -- 50 MHz
        DEBOUNCE_MS  => 20          -- 20 ms de debounce
    )
    PORT MAP (
        clock   => clock,
        reset   => reset_int,
        entrada => botoes,
        saida   => botoes_db_s
    );

    -- Unidade de Controle recebe botoes debounced
    U_UC : piano_uc
    PORT MAP (
        clock     => clock,
        reset     => reset_int,
        botoes    => botoes_db_s,
        liga      => liga_s,
        db_estado => OPEN
    );

    -- Fluxo de dados recebe botoes debounced
    U_DP : piano_fd
    PORT MAP (
        clock  => clock,
        reset  => reset_int,
        liga   => liga_s,
        botoes => botoes_db_s,
        audio  => audio,
        led_r  => led_r,
        led_g  => led_g,
        led_b  => led_b,
        hex0   => hex0
    );

END ARCHITECTURE structural;
