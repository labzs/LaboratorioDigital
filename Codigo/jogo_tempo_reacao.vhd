LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY jogo_tempo_reacao IS
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
        pronto : OUT STD_LOGIC--;
        -- db_pulso : OUT STD_LOGIC;
        -- db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        -- db_tempo_reacao0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        -- db_tempo_reacao1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        -- db_tempo_reacao2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        -- db_tempo_reacao3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY jogo_tempo_reacao;

ARCHITECTURE behavioral OF jogo_tempo_reacao IS

    COMPONENT jogo_tempo_reacao_uc IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            estimulo : IN STD_LOGIC;
            erro_interface : IN STD_LOGIC;
            pronto_medidor : IN STD_LOGIC;
            jogar : IN STD_LOGIC;
            pronto : OUT STD_LOGIC;
            iniciar : OUT STD_LOGIC;
            db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT interface_leds_botoes IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            iniciar : IN STD_LOGIC;
            resposta : IN STD_LOGIC;
            ligado : OUT STD_LOGIC;
            estimulo : OUT STD_LOGIC;
            pulso : OUT STD_LOGIC;
            pulso_scope : OUT STD_LOGIC;
            erro : OUT STD_LOGIC;
            pronto : OUT STD_LOGIC;
            burlou_assinc : OUT STD_LOGIC;
            db_estado_display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT interface_leds_botoes;

    COMPONENT medidor_largura IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            liga : IN STD_LOGIC;
            sinal : IN STD_LOGIC;
            erro : IN STD_LOGIC;
            display0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            display1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            display2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            display3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_estado : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            pronto : OUT STD_LOGIC;
            fim : OUT STD_LOGIC;
            db_clock : OUT STD_LOGIC;
            db_sinal : OUT STD_LOGIC;
            db_zeraCont : OUT STD_LOGIC;
            db_contaCont : OUT STD_LOGIC;
            db_valorCont0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            db_valorCont1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            db_valorCont2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            db_valorCont3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT medidor_largura;

    SIGNAL ligado_interno, pulso_interno, pronto_interno_interface, pronto_interno_medidor, erro_interno, estimulo_interno : STD_LOGIC;
    SIGNAL display0_interno, display1_interno, display2_interno, display3_interno : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN
    display0 <= display0_interno;
    display1 <= display1_interno;
    display2 <= display2_interno;
    display3 <= display3_interno;
    ligado <= ligado_interno;
    pulso <= pulso_interno;
    --db_pulso <= pulso_interno;
    erro <= erro_interno;
    estimulo <= estimulo_interno;

    U1 : interface_leds_botoes
    PORT MAP(
        clock => clock,
        reset => reset,
        iniciar => ligado_interno,
        resposta => resposta,
        ligado => OPEN,
        estimulo => estimulo_interno,
        pulso => pulso_interno,
        pulso_scope => OPEN,
        erro => erro_interno,
        pronto => pronto_interno_interface,
        burlou_assinc => OPEN,
        db_estado_display => OPEN
    );
    U2 : medidor_largura
    PORT MAP(
        clock => clock,
        reset => reset,
        liga => ligado_interno,
        sinal => pulso_interno,
        display0 => display0_interno,
        display1 => display1_interno,
        display2 => display2_interno,
        display3 => display3_interno,
        db_estado => OPEN,
        pronto => pronto_interno_medidor,
        fim => OPEN,
        db_clock => OPEN,
        db_sinal => OPEN,
        db_zeraCont => OPEN,
        db_contaCont => OPEN,
        db_valorCont0 => OPEN,--db_tempo_reacao0,
        db_valorCont1 => OPEN,--db_tempo_reacao1,
        db_valorCont2 => OPEN,--db_tempo_reacao2,
        db_valorCont3 => OPEN,--db_tempo_reacao3,
        erro => erro_interno
    );
    U3 : jogo_tempo_reacao_uc
    PORT MAP(
        clock => clock,
        reset => reset,
        jogar => jogar,
        estimulo => estimulo_interno,
        pronto_medidor => pronto_interno_medidor,
        erro_interface => erro_interno,
        pronto => pronto,
        iniciar => ligado_interno,
        db_estado => OPEN --db_estado
    );

END ARCHITECTURE behavioral;