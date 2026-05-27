LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Decodificador de Teclas: mapeia 8 botoes para as notas da escala de Do maior
-- Clock de referencia: 50 MHz
-- Prioridade: botoes(0) > botoes(1) > ... > botoes(7)
--
-- Nota  | Freq (Hz) | divisor (meio-periodo em ciclos a 50 MHz)
-- -------|-----------|-------------------------------------------
-- Do  C4 |  261.63   |  95557
-- Re  D4 |  293.66   |  85124
-- Mi  E4 |  329.63   |  75839
-- Fa  F4 |  349.23   |  71584
-- Sol G4 |  392.00   |  63777
-- La  A4 |  440.00   |  56818  <- frequencia de referencia (Analog Discovery)
-- Si  B4 |  493.88   |  50624
-- Do' C5 |  523.25   |  47779
ENTITY key_decoder IS
    PORT (
        botoes  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        divisor : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
        ativo   : OUT STD_LOGIC;
        nota    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        led_r   : OUT STD_LOGIC;
        led_g   : OUT STD_LOGIC;
        led_b   : OUT STD_LOGIC
    );
END ENTITY key_decoder;

ARCHITECTURE behavioral OF key_decoder IS
BEGIN
    PROCESS (botoes)
    BEGIN
        divisor <= (OTHERS => '0');
        ativo   <= '0';
        nota    <= "000";
        led_r   <= '0';
        led_g   <= '0';
        led_b   <= '0';

        IF botoes(0) = '1' THEN
            -- Do (C4) 261.63 Hz  -> divisor = round(50e6 / (2*261.63))
            divisor <= STD_LOGIC_VECTOR(TO_UNSIGNED(95557, 17));
            ativo   <= '1';
            nota    <= "000";
            led_r   <= '1'; led_g <= '0'; led_b <= '0';   -- Vermelho

        ELSIF botoes(1) = '1' THEN
            -- Re (D4) 293.66 Hz
            divisor <= STD_LOGIC_VECTOR(TO_UNSIGNED(85124, 17));
            ativo   <= '1';
            nota    <= "001";
            led_r   <= '1'; led_g <= '1'; led_b <= '0';   -- Amarelo

        ELSIF botoes(2) = '1' THEN
            -- Mi (E4) 329.63 Hz
            divisor <= STD_LOGIC_VECTOR(TO_UNSIGNED(75839, 17));
            ativo   <= '1';
            nota    <= "010";
            led_r   <= '0'; led_g <= '1'; led_b <= '0';   -- Verde

        ELSIF botoes(3) = '1' THEN
            -- Fa (F4) 349.23 Hz
            divisor <= STD_LOGIC_VECTOR(TO_UNSIGNED(71584, 17));
            ativo   <= '1';
            nota    <= "011";
            led_r   <= '0'; led_g <= '1'; led_b <= '1';   -- Ciano

        ELSIF botoes(4) = '1' THEN
            -- Sol (G4) 392.00 Hz
            divisor <= STD_LOGIC_VECTOR(TO_UNSIGNED(63777, 17));
            ativo   <= '1';
            nota    <= "100";
            led_r   <= '0'; led_g <= '0'; led_b <= '1';   -- Azul

        ELSIF botoes(5) = '1' THEN
            -- La (A4) 440.00 Hz  <- nota de referencia exp 8
            divisor <= STD_LOGIC_VECTOR(TO_UNSIGNED(56818, 17));
            ativo   <= '1';
            nota    <= "101";
            led_r   <= '1'; led_g <= '0'; led_b <= '1';   -- Magenta

        ELSIF botoes(6) = '1' THEN
            -- Si (B4) 493.88 Hz
            divisor <= STD_LOGIC_VECTOR(TO_UNSIGNED(50624, 17));
            ativo   <= '1';
            nota    <= "110";
            led_r   <= '1'; led_g <= '1'; led_b <= '1';   -- Branco

        ELSIF botoes(7) = '1' THEN
            -- Do' (C5) 523.25 Hz
            divisor <= STD_LOGIC_VECTOR(TO_UNSIGNED(47779, 17));
            ativo   <= '1';
            nota    <= "111";
            led_r   <= '1'; led_g <= '0'; led_b <= '0';   -- Vermelho (oitava acima)
        END IF;
    END PROCESS;
END ARCHITECTURE behavioral;
