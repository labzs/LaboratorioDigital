library ieee;
use ieee.std_logic_1164.all;

-- Entidade principal do projeto: medidor_largura
entity medidor_largura is
    port (
        clock        : in  std_logic;
        reset        : in  std_logic;
        liga         : in  std_logic;
        sinal        : in  std_logic;
        display0     : out std_logic_vector(6 downto 0); -- Saída de 7 segmentos para unidade
        display1     : out std_logic_vector(6 downto 0); -- Saída de 7 segmentos para dezena
        display2     : out std_logic_vector(6 downto 0); -- Saída de 7 segmentos para centena
        display3     : out std_logic_vector(6 downto 0); -- Saída de 7 segmentos para milhar
        db_estado    : out std_logic_vector(6 downto 0); -- Depuração: estado da FSM em 7 seg
        pronto       : out std_logic;                    -- Indica fim da medida
        fim          : out std_logic;                    -- Indica estouro do contador (9999)
        db_clock     : out std_logic;                    -- Depuração: cópia do clock
        db_sinal     : out std_logic;                    -- Depuração: cópia do sinal de entrada
        db_zeraCont  : out std_logic;                    -- Depuração: monitoramento do sinal zera
        db_contaCont : out std_logic                     -- Depuração: monitoramento do sinal conta
    );
end entity medidor_largura;

architecture arch of medidor_largura is

    -- 1. Declaração do componente Controlador (Máquina de Estados)
    component controlador is
        port (
            clock     : in  std_logic;
            reset     : in  std_logic;
            liga      : in  std_logic;
            sinal     : in  std_logic;
            zeraCont  : out std_logic;
            contaCont : out std_logic;
            pronto    : out std_logic;
            db_estado : out std_logic_vector(3 downto 0)
        );
    end component;

    -- 2. Declaração do componente Contador Decimal de 4 dígitos
    component cont10_4digitos is
        port (
            CLK      : in  std_logic;
            zera     : in  std_logic;
            conta    : in  std_logic;
            display0 : out std_logic_vector(3 downto 0); -- BCD de 4 bits
            display1 : out std_logic_vector(3 downto 0);
            display2 : out std_logic_vector(3 downto 0);
            display3 : out std_logic_vector(3 downto 0);
            RCO      : out std_logic
        );
    end component;

    -- 3. Declaração do componente Conversor Hexadecimal para 7 Segmentos
    component hex7seg is
        port (  
            hex     : in  std_logic_vector(3 downto 0);
            display : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Sinais internos para interconexão dos componentes (Item d)
    signal s_zera, s_conta : std_logic;
    signal s_q0, s_q1, s_q2, s_q3 : std_logic_vector(3 downto 0);
    signal s_estado_bin : std_logic_vector(3 downto 0);

begin

    -- Atribuição dos sinais de depuração (Item e)
    db_clock     <= clock;
    db_sinal     <= sinal;
    db_zeraCont  <= s_zera;
    db_contaCont <= s_conta;

    -- Instanciação do Controlador (Unidade de Controle)
    U_CONTROL: controlador port map (
        clock     => clock,
        reset     => reset,
        liga      => liga,
        sinal     => sinal,
        zeraCont  => s_zera,
        contaCont => s_conta,
        pronto    => pronto,
        db_estado => s_estado_bin
    );

    -- Instanciação do Contador (Fluxo de Dados)
    U_COUNTER: cont10_4digitos port map (
        CLK      => clock,
        zera     => s_zera,
        conta    => s_conta,
        display0 => s_q0,
        display1 => s_q1,
        display2 => s_q2,
        display3 => s_q3,
        RCO      => fim  -- Conectado ao sinal fim para indicar limite 9999
    );

    -- Instanciação dos decodificadores para os displays de 7 segmentos (Item e)
    -- Displays de medida (0-3)
    HEX0: hex7seg port map ( hex => s_q0, display => display0 );
    HEX1: hex7seg port map ( hex => s_q1, display => display1 );
    HEX2: hex7seg port map ( hex => s_q2, display => display2 );
    HEX3: hex7seg port map ( hex => s_q3, display => display3 );
    
    -- Display de depuração do estado 
    HEX_ST: hex7seg port map ( hex => s_estado_bin, display => db_estado );

end architecture arch;