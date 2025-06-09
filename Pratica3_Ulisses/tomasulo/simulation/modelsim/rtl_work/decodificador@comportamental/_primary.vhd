library verilog;
use verilog.vl_types.all;
entity decodificadorComportamental is
    port(
        SW              : in     vl_logic_vector(3 downto 0);
        HEX0            : out    vl_logic_vector(0 to 6)
    );
end decodificadorComportamental;
