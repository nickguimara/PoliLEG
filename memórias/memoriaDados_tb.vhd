library ieee;
use ieee.numeric_bit.all;
use work.utils.all;

entity ram_tb is
end entity;

architecture testbench of ram_tb is 
    component memoriaDados is
        generic (
            datFileName : string := "conteudo_memDados_af11_p1e5_carga.dat"
        );
        port (
            clk: in bit;
            wr: in bit;
            addr: in bit_vector (7 downto 0);
            data_i : in bit_vector (63 downto 0);
            data_o : out bit_vector (63 downto 0)
        );
    end component;
    
    signal clk, stopc, wr: bit := '0';
    signal s_addr : bit_vector(7 downto 0);
    signal s_data_i : bit_vector(63 downto 0);
    signal s_data_o : bit_vector(63 downto 0);

    constant period : time := 5 ns;
begin
    clk <= stopc and (not clk) after period/2;
    DUT : memoriaDados generic map("conteudo_memDados_af11_p1e5_carga.dat") port map(clk, wr, s_addr, s_data_i, s_data_o);

    process
        variable addr_tmp: bit_vector(7 downto 0);
    begin 
        --Teste de escrita inicial da RAM com arquivo de texto
        -- for i in 0 to 255 loop
        --     s_addr <= bit_vector(to_unsigned(i, 8));
        --     wait for 1 ns;
        --     assert s_data_o = s_addr(7 downto 0)
        --         report "RAM mem("&to_bstring(s_addr)&")="&to_bstring(s_data_o);
        -- end loop;

        --Teste reescrita do valor da memória
        wr <= '1';
        stopc <= '1';

        s_addr <= "00000000";
        s_data_i <= X"0000000000000001";
        wait for 5 ns;
        assert (s_data_o = X"0000000000000001") report "Erro escrita wr = '1' " severity error; 

        --Teste não escrita com wr = '0'
        wr <= '0';
        s_addr <= "00000001";
        s_data_i <= X"0000000000000010";
        wait for 5 ns;
        assert (s_data_o = X"0000000000000009") report "Erro não escrita wr = '0' " severity error;
                            
        -- Teste manutencão dos valores da memória inicial
        for i in 2 to 255 loop
            s_addr <= bit_vector(to_unsigned(i, 8));
            wait for 5 ns;
        end loop;

        wait;
    end process;
end architecture;