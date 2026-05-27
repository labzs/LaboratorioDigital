LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Piano Digital - Top Level (Experiencia 9)
-- Instancia a Unidade de Controle e o Fluxo de Dados conforme
-- arquitetura hierarquica estrutural exigida pelo projeto.

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

    SIGNAL reset_int : STD_LOGIC;
    SIGNAL liga_s    : STD_LOGIC;

BEGIN

    reset_int <= NOT reset_n;

    U_UC : piano_uc
    PORT MAP (
        clock     => clock,
        reset     => reset_int,
        botoes    => botoes,
        liga      => liga_s,
        db_estado => OPEN
    );

    U_DP : piano_fd
    PORT MAP (
        clock  => clock,
        reset  => reset_int,
        liga   => liga_s,
        botoes => botoes,
        audio  => audio,
        led_r  => led_r,
        led_g  => led_g,
        led_b  => led_b,
        hex0   => hex0
    );

END ARCHITECTURE structural;
