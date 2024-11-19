library ieee;
use ieee.numeric_bit.all;
use work.utils.all;

entity rom_tb is
end rom_tb;

architecture rom_testbench of rom_tb is
    component memoriaInstrucoes is
        generic (
            datFileName : string := "conteudo_memInstr_af11_p1e5_carga.dat"
        );

        port (
            addr: in bit_vector(7 downto 0);
            data: out bit_vector(31 downto 0)
        );
    end component;

    signal s_addr : bit_vector(7 downto 0);
    signal s_data : bit_vector(31 downto 0);
    signal stopc, clk : bit := '0'; 

    constant period : time := 10 ns;

begin
    clk <= stopc and (not clk) after period/2;

    DUT : memoriaInstrucoes generic map("conteudo_memInstr_af11_p1e5_carga.dat") port map(s_addr, s_data);

    stimulus: process
    begin
        stopc <= '1';
            
        for i in 0 to 255 loop
            s_addr <= bit_vector(to_unsigned(i, 8));
            wait for 1 ns;
            assert s_data = s_addr(3 downto 0)
                report "ROM mem("&to_bstring(s_addr)&")="&to_bstring(s_data);
        end loop;
        stopc <= '0';
        wait;
    end process;
end architecture;