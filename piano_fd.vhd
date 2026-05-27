LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Fluxo de Dados do Piano Digital
-- Contem: key_decoder, tone_gen, hex7seg
-- liga (da UC) habilita o gerador de tom e o display

ENTITY piano_fd IS
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
END ENTITY piano_fd;

ARCHITECTURE structural OF piano_fd IS

    COMPONENT key_decoder IS
        PORT (
            botoes  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            divisor : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
            ativo   : OUT STD_LOGIC;
            nota    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            led_r   : OUT STD_LOGIC;
            led_g   : OUT STD_LOGIC;
            led_b   : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT tone_gen IS
        PORT (
            clock   : IN  STD_LOGIC;
            reset   : IN  STD_LOGIC;
            ativo   : IN  STD_LOGIC;
            divisor : IN  STD_LOGIC_VECTOR(16 DOWNTO 0);
            audio   : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT hex7seg IS
        PORT (
            hex     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL divisor_s  : STD_LOGIC_VECTOR(16 DOWNTO 0);
    SIGNAL nota_s     : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL disp_nota  : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL led_r_kd   : STD_LOGIC;
    SIGNAL led_g_kd   : STD_LOGIC;
    SIGNAL led_b_kd   : STD_LOGIC;

BEGIN

    -- Display apagado quando nenhuma nota ativa; mostra indice 0-7 caso contrario
    hex0  <= "1111111" WHEN liga = '0' ELSE disp_nota;
    led_r <= led_r_kd AND liga;
    led_g <= led_g_kd AND liga;
    led_b <= led_b_kd AND liga;

    U_KD : key_decoder
    PORT MAP (
        botoes  => botoes,
        divisor => divisor_s,
        ativo   => OPEN,
        nota    => nota_s,
        led_r   => led_r_kd,
        led_g   => led_g_kd,
        led_b   => led_b_kd
    );

    U_TG : tone_gen
    PORT MAP (
        clock   => clock,
        reset   => reset,
        ativo   => liga,
        divisor => divisor_s,
        audio   => audio
    );

    U_HEX : hex7seg
    PORT MAP (
        hex     => '0' & nota_s,
        display => disp_nota
    );

END ARCHITECTURE structural;
