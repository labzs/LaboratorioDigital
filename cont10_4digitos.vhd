library ieee;
use ieee.std_logic_1164.all;

entity cont10_4digitos is
    port (
        CLK      : in  std_logic;
        zera     : in  std_logic; 
        conta    : in  std_logic; 
        display0 : out std_logic_vector(3 downto 0); -- Q0
        display1 : out std_logic_vector(3 downto 0); -- Q1
        display2 : out std_logic_vector(3 downto 0); -- Q2
        display3 : out std_logic_vector(3 downto 0); -- Q3
        RCO      : out std_logic
    );
end entity;

architecture structural of cont10_4digitos is

    component cont10 is
        port (
            clock   : in  std_logic;
            clear   : in  std_logic;
            enable  : in  std_logic;
            Q       : out std_logic_vector(3 downto 0);
            RCO     : out std_logic
        );
    end component;

    signal s_rco0, s_rco1, s_rco2, s_rco3 : std_logic;
    signal s_en1, s_en2, s_en3           : std_logic;

begin

    s_en1 <= conta and s_rco0;
    s_en2 <= s_en1 and s_rco1;
    s_en3 <= s_en2 and s_rco2;

    -- Instância do Dígito 0 (Unidade)
    c0: cont10 port map (
        clock  => CLK,
        clear  => zera,
        enable => conta, 
        Q      => display0,
        RCO    => s_rco0
    );

    -- Instância do Dígito 1 (Dezena)
    c1: cont10 port map (
        clock  => CLK,
        clear  => zera,
        enable => s_en1,
        Q      => display1,
        RCO    => s_rco1
    );

    -- Instância do Dígito 2 (Centena)
    c2: cont10 port map (
        clock  => CLK,
        clear  => zera,
        enable => s_en2,
        Q      => display2,
        RCO    => s_rco2
    );

    -- Instância do Dígito 3 (Milhar)
    c3: cont10 port map (
        clock  => CLK,
        clear  => zera,
        enable => s_en3,
        Q      => display3,
        RCO    => s_rco3
    );

    -- RCO global (fim de contagem 9999)
    RCO <= s_en3 and s_rco3;

end architecture;