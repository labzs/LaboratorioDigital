LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- =============================================================
-- Bancada de Testes: Piano Digital -- Experiencia 9
-- DUT: piano_top (UC + Datapath integrados)
-- Clock de simulacao: 10 ns (equivalente a 100 MHz; divisores
--   usados pelo tone_gen foram calculados para 50 MHz, portanto
--   as frequencias geradas serao o dobro das reais -- irrelevante
--   para validar a logica de controle e geracao de audio)
--
-- Casos de teste:
--   CT0 : reset inicial -> audio=0, LEDs=0, display apagado
--   CT1 : Do C4 (SW[0]) -> LED vermelho, audio oscila, HEX0='0'
--   CT2 : soltar tecla   -> audio=0, LEDs=0, display apagado
--   CT3 : Re D4 (SW[1]) -> LED amarelo, audio oscila
--   CT4 : Mi E4 (SW[2]) -> LED verde,   audio oscila
--   CT5 : Fa F4 (SW[3]) -> LED ciano,   audio oscila
--   CT6 : prioridade SW[0]+SW[5] -> Do vence (LED vermelho)
--   CT7 : reset durante reproducao -> audio=0
-- =============================================================

ENTITY piano_tb IS
END ENTITY piano_tb;

ARCHITECTURE tb OF piano_tb IS

    COMPONENT piano_top IS
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
    END COMPONENT;

    CONSTANT T : TIME := 10 ns;

    -- Codigos hex7seg (anodo comum): 0=segmento ON, 1=segmento OFF
    CONSTANT SEG_0   : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1000000"; -- digito 0
    CONSTANT SEG_1   : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111001"; -- digito 1
    CONSTANT SEG_2   : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0100100"; -- digito 2
    CONSTANT SEG_3   : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0110000"; -- digito 3
    CONSTANT SEG_OFF : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111111"; -- apagado

    SIGNAL clock_s   : STD_LOGIC := '0';
    SIGNAL reset_n_s : STD_LOGIC := '1';
    SIGNAL botoes_s  : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL audio_s   : STD_LOGIC;
    SIGNAL led_r_s   : STD_LOGIC;
    SIGNAL led_g_s   : STD_LOGIC;
    SIGNAL led_b_s   : STD_LOGIC;
    SIGNAL hex0_s    : STD_LOGIC_VECTOR(6 DOWNTO 0);

    SIGNAL caso    : INTEGER   := 0;
    SIGNAL keep_clk: STD_LOGIC := '1';

BEGIN

    clock_s <= (NOT clock_s) AND keep_clk AFTER T / 2;

    DUT : piano_top
    PORT MAP (
        clock   => clock_s,
        reset_n => reset_n_s,
        botoes  => botoes_s,
        audio   => audio_s,
        led_r   => led_r_s,
        led_g   => led_g_s,
        led_b   => led_b_s,
        hex0    => hex0_s
    );

    stimulus : PROCESS IS

        PROCEDURE aplica_reset IS
        BEGIN
            reset_n_s <= '0';
            WAIT FOR 4 * T;
            reset_n_s <= '1';
            WAIT FOR 2 * T;
        END PROCEDURE;

        PROCEDURE solta_tecla IS
        BEGIN
            botoes_s <= "00000000";
            WAIT FOR 3 * T;   -- aguarda UC transicionar para idle
        END PROCEDURE;

    BEGIN
        ASSERT false REPORT "=== INICIO DA SIMULACAO ===" SEVERITY note;

        -- CT0: reset inicial
        caso <= 0;
        aplica_reset;
        ASSERT audio_s  = '0'   REPORT "CT0 FALHOU: audio != 0"         SEVERITY error;
        ASSERT led_r_s  = '0'   REPORT "CT0 FALHOU: led_r != 0"         SEVERITY error;
        ASSERT led_g_s  = '0'   REPORT "CT0 FALHOU: led_g != 0"         SEVERITY error;
        ASSERT led_b_s  = '0'   REPORT "CT0 FALHOU: led_b != 0"         SEVERITY error;
        ASSERT hex0_s   = SEG_OFF REPORT "CT0 FALHOU: display nao apagado" SEVERITY error;
        ASSERT false REPORT "CT0 OK: estado inicial correto apos reset" SEVERITY note;

        -- CT1: Do C4 (SW[0]) -- LED vermelho, HEX0 exibe '0', audio oscila
        caso <= 1;
        ASSERT false REPORT "CT1: Do C4 SW[0] -- aguarda audio oscilar..." SEVERITY note;
        botoes_s <= "00000001";
        WAIT FOR 2 * T;   -- UC transiciona para tocando
        ASSERT led_r_s = '1' AND led_g_s = '0' AND led_b_s = '0'
            REPORT "CT1 FALHOU: LED deve ser vermelho (Do C4)" SEVERITY error;
        ASSERT hex0_s = SEG_0
            REPORT "CT1 FALHOU: HEX0 deve exibir '0' (Do C4)" SEVERITY error;
        WAIT UNTIL audio_s = '1';
        WAIT UNTIL audio_s = '0';
        ASSERT false REPORT "CT1 OK: Do C4 -- audio oscilando, LED vermelho, HEX0='0'" SEVERITY note;
        solta_tecla;

        -- CT2: soltar tecla -> silencio
        caso <= 2;
        ASSERT audio_s = '0' REPORT "CT2 FALHOU: audio != 0 apos soltar tecla" SEVERITY error;
        ASSERT led_r_s = '0' REPORT "CT2 FALHOU: led_r != 0 apos soltar tecla" SEVERITY error;
        ASSERT hex0_s = SEG_OFF REPORT "CT2 FALHOU: display nao apagado apos soltar" SEVERITY error;
        ASSERT false REPORT "CT2 OK: silencio e display apagado apos soltar" SEVERITY note;

        -- CT3: Re D4 (SW[1]) -- LED amarelo, audio oscila
        caso <= 3;
        ASSERT false REPORT "CT3: Re D4 SW[1] -- aguarda audio oscilar..." SEVERITY note;
        botoes_s <= "00000010";
        WAIT FOR 2 * T;
        ASSERT led_r_s = '1' AND led_g_s = '1' AND led_b_s = '0'
            REPORT "CT3 FALHOU: LED deve ser amarelo (Re D4)" SEVERITY error;
        ASSERT hex0_s = SEG_1
            REPORT "CT3 FALHOU: HEX0 deve exibir '1' (Re D4)" SEVERITY error;
        WAIT UNTIL audio_s = '1';
        ASSERT false REPORT "CT3 OK: Re D4 -- audio gerado, LED amarelo, HEX0='1'" SEVERITY note;
        solta_tecla;

        -- CT4: Mi E4 (SW[2]) -- LED verde, audio oscila
        caso <= 4;
        ASSERT false REPORT "CT4: Mi E4 SW[2] -- aguarda audio oscilar..." SEVERITY note;
        botoes_s <= "00000100";
        WAIT FOR 2 * T;
        ASSERT led_r_s = '0' AND led_g_s = '1' AND led_b_s = '0'
            REPORT "CT4 FALHOU: LED deve ser verde (Mi E4)" SEVERITY error;
        ASSERT hex0_s = SEG_2
            REPORT "CT4 FALHOU: HEX0 deve exibir '2' (Mi E4)" SEVERITY error;
        WAIT UNTIL audio_s = '1';
        ASSERT false REPORT "CT4 OK: Mi E4 -- audio gerado, LED verde, HEX0='2'" SEVERITY note;
        solta_tecla;

        -- CT5: Fa F4 (SW[3]) -- LED ciano, audio oscila
        caso <= 5;
        ASSERT false REPORT "CT5: Fa F4 SW[3] -- aguarda audio oscilar..." SEVERITY note;
        botoes_s <= "00001000";
        WAIT FOR 2 * T;
        ASSERT led_r_s = '0' AND led_g_s = '1' AND led_b_s = '1'
            REPORT "CT5 FALHOU: LED deve ser ciano (Fa F4)" SEVERITY error;
        ASSERT hex0_s = SEG_3
            REPORT "CT5 FALHOU: HEX0 deve exibir '3' (Fa F4)" SEVERITY error;
        WAIT UNTIL audio_s = '1';
        ASSERT false REPORT "CT5 OK: Fa F4 -- audio gerado, LED ciano, HEX0='3'" SEVERITY note;
        solta_tecla;

        -- CT6: prioridade SW[0]+SW[5] -> Do C4 vence (LED vermelho, nao magenta)
        caso <= 6;
        ASSERT false REPORT "CT6: prioridade Do > La (SW[0]+SW[5])" SEVERITY note;
        botoes_s <= "00100001";
        WAIT FOR 2 * T;
        ASSERT led_r_s = '1' AND led_g_s = '0' AND led_b_s = '0'
            REPORT "CT6 FALHOU: SW[0] deve ter prioridade sobre SW[5] (LED vermelho)" SEVERITY error;
        ASSERT hex0_s = SEG_0
            REPORT "CT6 FALHOU: HEX0 deve exibir '0' (Do C4 com prioridade)" SEVERITY error;
        ASSERT false REPORT "CT6 OK: prioridade SW[0] > SW[5] confirmada" SEVERITY note;
        solta_tecla;

        -- CT7: reset durante reproducao -> audio=0 imediatamente
        caso <= 7;
        ASSERT false REPORT "CT7: reset durante reproducao" SEVERITY note;
        botoes_s <= "00000001";
        WAIT FOR 2 * T;
        aplica_reset;
        ASSERT audio_s = '0' REPORT "CT7 FALHOU: audio != 0 apos reset" SEVERITY error;
        ASSERT led_r_s = '0' REPORT "CT7 FALHOU: led_r != 0 apos reset" SEVERITY error;
        ASSERT false REPORT "CT7 OK: reset zera audio e LEDs" SEVERITY note;
        botoes_s <= "00000000";

        ASSERT false REPORT "=== FIM DA SIMULACAO ===" SEVERITY note;
        keep_clk <= '0';
        WAIT;
    END PROCESS stimulus;

END ARCHITECTURE tb;
