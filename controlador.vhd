library ieee;
use ieee.std_logic_1164.all;

entity controlador is
    port (
        clock     : in  std_logic;
        reset     : in  std_logic;
        liga      : in  std_logic;
        sinal     : in  std_logic;
        zeraCont  : out std_logic;
        contaCont : out std_logic;
        pronto    : out std_logic;
        db_estado : out std_logic_vector(3 downto 0) -- sinal de depuracao
    );
end entity controlador;

architecture behavior of controlador is

    -- Definicao dos estados da maquina
    type t_estado is (INICIAL, LIGADO, PREPARA, CONTA, FIM, ESPERA);
    signal estado_atual, proximo_estado: t_estado;

begin

    -- Processo 1: Memoria de Estado (Sincrono)
    process (clock, reset)
    begin
        if reset = '1' then
            estado_atual <= INICIAL;
        elsif rising_edge(clock) then
            estado_atual <= proximo_estado;
        end if;
    end process;

    -- Processo 2: Logica de Proximo Estado e Saidas (Combinatorio)
    process (estado_atual, liga, sinal)
    begin
        -- Valores default para evitar latches
        zeraCont  <= '0';
        contaCont <= '0';
        pronto    <= '0';
        
        case estado_atual is
            when INICIAL =>
                db_estado <= "0000"; -- 0
                if liga = '1' then
                    proximo_estado <= LIGADO;
                else
                    proximo_estado <= INICIAL;
                end if;

            when LIGADO =>
                db_estado <= "0001"; -- 1
                if sinal = '1' then
                    proximo_estado <= PREPARA;
                else
                    proximo_estado <= LIGADO;
                end if;

            when PREPARA =>
                db_estado <= "0010"; -- 2
                zeraCont  <= '1';    -- Saida de Moore
                proximo_estado <= CONTA;

            when CONTA =>
                db_estado <= "0011"; -- 3
                contaCont <= '1';    -- Saida de Moore
                if sinal = '1' then
                    proximo_estado <= CONTA;
                else
                    proximo_estado <= FIM;
                end if;

            when FIM =>
                db_estado <= "0100"; -- 4
                pronto    <= '1';    -- Saida de Moore
                proximo_estado <= ESPERA;

            when ESPERA =>
                db_estado <= "0101"; -- 5
                if liga = '0' then
                    proximo_estado <= INICIAL;
                elsif sinal = '1' then
                    proximo_estado <= PREPARA;
                else
                    proximo_estado <= ESPERA;
                end if;

            when others =>
                db_estado <= "1111";
                proximo_estado <= INICIAL;
        end case;
    end process;

end architecture behavior;