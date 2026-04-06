library ieee;
use ieee.std_logic_1164.all;

entity medidor_largura_tb is
end entity;

architecture tb of medidor_largura_tb is
    signal clk_tb, res_tb, liga_tb, sinal_tb : std_logic := '0';
    signal pronto_tb, fim_tb : std_logic;

    signal d0, d1, d2, d3, d_st : std_logic_vector(6 downto 0);

    -- sinais de debug (necessários!)
    signal db_clock_tb     : std_logic;
    signal db_sinal_tb     : std_logic;
    signal db_zeraCont_tb  : std_logic;
    signal db_contaCont_tb : std_logic;

    constant period : time := 20 ns;

begin

    uut: entity work.medidor_largura 
        port map (
            clock        => clk_tb,
            reset        => res_tb,
            liga         => liga_tb,
            sinal        => sinal_tb,

            display0     => d0,
            display1     => d1,
            display2     => d2,
            display3     => d3,

            db_estado    => d_st,
            pronto       => pronto_tb,
            fim          => fim_tb,

            -- mapeamento explícito dos sinais de debug
            db_clock     => db_clock_tb,
            db_sinal     => db_sinal_tb,
            db_zeraCont  => db_zeraCont_tb,
            db_contaCont => db_contaCont_tb
        );

    -- Clock
    clk_tb <= not clk_tb after period/2;

    stim: process
    begin
        -- =========================
        -- Caso 01: Reset Global
        -- =========================
        res_tb <= '1';
        wait for 2 * period;
        res_tb <= '0';
        wait for period;

        -- =========================
        -- Caso 02: Início de Medida
        -- =========================
        liga_tb <= '1';
        wait for 2 * period;

        -- =========================
        -- Caso 03: Medida Curta (50 ciclos)
        -- =========================
        sinal_tb <= '1';
        wait for 10 * period;
        sinal_tb <= '0';

        wait until pronto_tb = '1';
        wait for 5 * period;

        -- =========================
        -- Caso 04: Overflow (>9999)
        -- =========================
        sinal_tb <= '1';
        wait for 10050 * period;
        sinal_tb <= '0';

        wait for 10 * period;

        -- =========================
        -- Caso 05: Persistência
        -- =========================
        liga_tb <= '0';
        wait for 20 * period;

        -- =========================
        -- Caso 06: Teste FSM
        -- =========================
        liga_tb <= '1';
        wait for 2 * period;

        sinal_tb <= '1';
        wait for 10 * period;
        sinal_tb <= '0';

        wait until pronto_tb = '1';
        wait for 5 * period;

        wait;
    end process;

end architecture;