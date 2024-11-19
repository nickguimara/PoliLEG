library ieee;
use ieee.numeric_bit.ALL;
use std.textio.all;

entity memoriaInstrucoes is
    generic (
        datFileName : string := "conteudo_memInstr_af11_p1e5_carga.dat"
    );
    port (
        addr: in bit_vector (7 downto 0);
        data: out bit_vector (31 downto 0)
    );
end entity memoriaInstrucoes;

architecture memoriaInstrucoes_arch of memoriaInstrucoes is
    constant depth : natural := 2**8; 
    type mem_type is array (0 to depth-1) of bit_vector(31 downto 0);
    impure function init_mem(file_name : in string) return mem_type is
        file f : text open read_mode is file_name;
        variable l : line;
        variable tmp_bv : bit_vector(31 downto 0);
        variable tmp_mem : mem_type;

    begin 
        for i in mem_type'range loop
            readline(f, l);
            read(l, tmp_bv);
            tmp_mem(i) := tmp_bv;
        end loop;
        return tmp_mem;
    end;

    constant mem : mem_type := init_mem(datFileName);
    begin 
        data <= mem(to_integer(unsigned(addr)));
end architecture memoriaInstrucoes_arch;