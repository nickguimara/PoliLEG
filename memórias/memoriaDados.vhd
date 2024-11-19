library ieee;
use ieee.numeric_bit.ALL;
use std.textio.all;

entity memoriaDados is
    generic (
        datFileName : string := "conteudo_memDados_af11_p1e5_carga . dat"
    );
    port (
        clk: in bit;
        wr: in bit;
        addr: in bit_vector (7 downto 0);
        data_i : in bit_vector (63 downto 0);
        data_o : out bit_vector (63 downto 0)
    );
end entity;

architecture memoriaDados_arch of memoriaDados is
    constant depth : natural := 2**8;
    type mem_type is array (0 to depth-1) of bit_vector(63 downto 0);
    impure function init_mem(file_name : in string) return mem_type is
        file f : text open read_mode is file_name;
        variable l : line;
        variable tmp_bv : bit_vector(63 downto 0);
        variable tmp_mem : mem_type;

    begin 
        for i in mem_type'range loop
            readline(f, l);
            read(l, tmp_bv);
            tmp_mem(i) := tmp_bv;
        end loop;
        return tmp_mem;
    end;

    signal mem : mem_type := init_mem(datFileName);
begin
    -- Escrita síncrona
    process(clk)
    begin
        if rising_edge(clk) then
            if (wr = '1') then 
                mem(to_integer(unsigned(addr))) <= data_i;
            end if;
        end if;
    end process;

    -- Leitura assíncrona
    data_o <= mem(to_integer(unsigned(addr)));
end architecture;