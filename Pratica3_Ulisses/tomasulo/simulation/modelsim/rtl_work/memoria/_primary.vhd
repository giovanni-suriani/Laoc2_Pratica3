library verilog;
use verilog.vl_types.all;
entity memoria is
    port(
        clock           : in     vl_logic;
        A               : in     vl_logic_vector(7 downto 0);
        data            : in     vl_logic_vector(15 downto 0);
        W               : in     vl_logic;
        dest_in         : in     vl_logic_vector(2 downto 0);
        Qi_in           : in     vl_logic_vector(3 downto 0);
        nova            : in     vl_logic;
        opcode_in       : in     vl_logic_vector(1 downto 0);
        \out\           : out    vl_logic_vector(15 downto 0);
        dest_out        : out    vl_logic_vector(2 downto 0);
        Qi_out          : out    vl_logic_vector(3 downto 0);
        V_pronto        : out    vl_logic;
        opcode_out      : out    vl_logic_vector(1 downto 0)
    );
end memoria;
