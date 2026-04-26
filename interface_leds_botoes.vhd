LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY interface_leds_botoes IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        iniciar : IN STD_LOGIC;
        resposta1 : IN STD_LOGIC;
        resposta2 : IN STD_LOGIC;
        ligado : OUT STD_LOGIC;
        estimulo : OUT STD_LOGIC;
        pulso1 : OUT STD_LOGIC;
        pulso2 : OUT STD_LOGIC;
        pulso_scope1 : OUT STD_LOGIC;
        pulso_scope2 : OUT STD_LOGIC;
        erro : OUT STD_LOGIC;
        pronto : OUT STD_LOGIC;
        burlou_assinc : OUT STD_LOGIC;
        db_estado_display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY interface_leds_botoes;

ARCHITECTURE Behavioral OF interface_leds_botoes IS
    COMPONENT interface_leds_botoes_uc IS
        PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        iniciar : IN STD_LOGIC;
        resposta1 : IN STD_LOGIC;
        resposta2 : IN STD_LOGIC;
        ligado : OUT STD_LOGIC;
        estimulo : OUT STD_LOGIC;
        pulso1 : OUT STD_LOGIC;
        pulso2 : OUT STD_LOGIC;
        pulso_scope1 : OUT STD_LOGIC;
        pulso_scope2 : OUT STD_LOGIC;
        erro : OUT STD_LOGIC;
        pronto : OUT STD_LOGIC;
        burlou_assinc : OUT STD_LOGIC;
        db_estado_display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT cont10_4digitos IS
        PORT (
        clock : IN STD_LOGIC;
        clear : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        Q0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        Q1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        Q2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        Q3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        RCO : OUT STD_LOGIC
        );
    END COMPONENT cont10_4digitos;

    COMPONENT pulso_assincrono IS
        PORT (
            resposta_reset1 : IN STD_LOGIC;
            resposta_reset2 : IN STD_LOGIC;
            estimulo : IN STD_LOGIC;
            pulso1 : OUT STD_LOGIC;
            pulso2 : OUT STD_LOGIC;
            menor_tempo : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT hex7seg IS
        PORT (
            hex : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL rco, contaCont, zeraCont, resposta_reset1, resposta_reset2, s_estimulo, pulso_interm1, pulso_interm2  : STD_LOGIC;
    SIGNAL db_estado : STD_LOGIC_VECTOR(3 DOWNTO 0);
    
BEGIN
    estimulo <= s_estimulo;
    pulso1 <= pulso_interm1;
    pulso1 <= pulso_interm2;
    pulso_scope1 <= pulso_interm1; --Pulso para Osciloscópio
    
    uc : interface_leds_botoes_uc
    PORT MAP(
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        iniciar : IN STD_LOGIC;
        resposta1 : IN STD_LOGIC;
        resposta2 : IN STD_LOGIC;
        ligado : OUT STD_LOGIC;
        estimulo : OUT STD_LOGIC;
        pulso1 : OUT STD_LOGIC;
        pulso2 : OUT STD_LOGIC;
        pulso_scope1 : OUT STD_LOGIC;
        pulso_scope2 : OUT STD_LOGIC;
        erro : OUT STD_LOGIC;
        pronto : OUT STD_LOGIC;
        burlou_assinc : OUT STD_LOGIC;
        db_estado_display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );

    cont : cont10_4digitos
     port map(
        clock => clock,
        clear => zeraCont,
        enable => contaCont,
        Q0 => open,
        Q1 => open,
        Q2 => open,
        Q3 => open,
        RCO => RCO
    );

    identificador_pulso : pulso_assincrono
    PORT MAP(
        resposta_reset1 => resposta_reset1,
        resposta_reset2 => resposta_reset2,
        estimulo => s_estimulo,
        pulso1 => pulso_interm1,
        pulso2 => pulso_interm2,
        menor_tempo : OUT STD_LOGIC
    );

    display : hex7seg
    PORT MAP(
        hex => db_estado,
        display => db_estado_display
    );

    resposta_reset1 <= resposta1 OR reset;
    resposta_reset2 <= resposta2 OR reset;

END ARCHITECTURE Behavioral;