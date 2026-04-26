LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY jogo_tempo_reacao_tb IS
END ENTITY;

ARCHITECTURE tb OF jogo_tempo_reacao_tb IS
    COMPONENT jogo_tempo_reacao IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            jogar : IN STD_LOGIC;
            resposta : IN STD_LOGIC;
            display0 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            display1 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            display2 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            display3 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            ligado : OUT STD_LOGIC;
            pulso : OUT STD_LOGIC;
            estimulo : OUT STD_LOGIC;
            erro : OUT STD_LOGIC;
            pronto : OUT STD_LOGIC --;        
            -- db_pulso : OUT STD_LOGIC;
            -- db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            -- db_tempo_reacao0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            -- db_tempo_reacao1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            -- db_tempo_reacao2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            -- db_tempo_reacao3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT jogo_tempo_reacao;

    -- Declaracao de sinais de entrada para conectar o componente
    SIGNAL clock_in : STD_LOGIC := '0';
    SIGNAL reset_in : STD_LOGIC := '0';
    SIGNAL enable_in : STD_LOGIC := '0';
    SIGNAL sinal_in : STD_LOGIC := '0';
    SIGNAL pronto : STD_LOGIC := '0';
    SIGNAL estimulo : STD_LOGIC := '0';
    SIGNAL ligado : STD_LOGIC := '0';
    SIGNAL pulso : STD_LOGIC := '0';
    SIGNAL erro : STD_LOGIC := '0';
    -- SIGNAL db_estado : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    -- SIGNAL db_tempo_reacao0 : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    -- SIGNAL db_tempo_reacao1 : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    -- SIGNAL db_tempo_reacao2 : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    -- SIGNAL db_tempo_reacao3 : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL caso : INTEGER := 0;

    SIGNAL keep_simulating : STD_LOGIC := '0'; -- delimita o tempo de gera��o do clock
    CONSTANT clockPeriod : TIME := 100 ps;

BEGIN
    -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o per�odo especificado. 
    -- Quando keep_simulating=0, clock � interrompido, bem como a simula��o de eventos
    clock_in <= (NOT clock_in) AND keep_simulating AFTER clockPeriod/2;

    ---- DUT para Caso de Teste 1
    dut : jogo_tempo_reacao
    PORT MAP
    (
        clock => clock_in,
        reset => reset_in,
        jogar => enable_in,
        resposta => sinal_in,
        ligado => ligado,
        estimulo => estimulo,
        pulso => pulso,
        erro => erro,
        pronto => pronto--,
        -- db_estado => db_estado,
        -- db_tempo_reacao0 => db_tempo_reacao0,
        -- db_tempo_reacao1 => db_tempo_reacao1,
        -- db_tempo_reacao2 => db_tempo_reacao2,
        -- db_tempo_reacao3 => db_tempo_reacao3
    );

    ---- Gera sinais de estimulo para a simulacao
    stimulus : PROCESS IS
    BEGIN

        -- inicio da simulacao
        ASSERT false REPORT "inicio da simulacao" SEVERITY note;
        keep_simulating <= '1'; -- inicia geracao do sinal de clock
        caso <= 0;
        sinal_in <= '0';
        --wait until falling_edge(clock_in);
        reset_in <= '1';
        WAIT FOR 2 * clockPeriod;
        reset_in <= '0';
        WAIT FOR 2 * clockPeriod;

        caso <= 1; -- teste do tempo de reação normal
        enable_in <= '1';

        WAIT FOR 2 * clockPeriod;

        enable_in <= '0';

        WAIT UNTIL estimulo = '1';

        WAIT FOR 5 * clockPeriod; --Deve contar um tempo de reação de 4 (pois o contador conta um a menos que o real)

        sinal_in <= '1';
        WAIT UNTIL pronto = '1';

        sinal_in <= '0';

        WAIT FOR 2 * clockPeriod;

        caso <= 2; -- teste de resposta adiantada

        enable_in <= '1';

        WAIT FOR 2 * clockPeriod;

        enable_in <= '0';

        WAIT FOR 1.3 * clockPeriod;

        sinal_in <= '1';

        WAIT UNTIL erro = '1';

        sinal_in <= '0';

        WAIT FOR 2 * clockPeriod;

        reset_in <= '1';

        WAIT FOR 2 * clockPeriod;

        reset_in <= '0';

        WAIT FOR 2 * clockPeriod;
        ---- final do testbench
        ASSERT false REPORT "fim da simulacao" SEVERITY note;
        keep_simulating <= '0';

        WAIT; -- fim da simula��o: processo aguarda indefinidamente
    END PROCESS;

END ARCHITECTURE;