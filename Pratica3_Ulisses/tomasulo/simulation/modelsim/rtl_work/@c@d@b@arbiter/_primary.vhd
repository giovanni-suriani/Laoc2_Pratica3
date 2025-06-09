library verilog;
use verilog.vl_types.all;
entity CDBArbiter is
    port(
        clock           : in     vl_logic;
        in_mem          : in     vl_logic_vector(15 downto 0);
        dest_mem        : in     vl_logic_vector(2 downto 0);
        Qi_mem          : in     vl_logic_vector(3 downto 0);
        V_mem_pronto    : in     vl_logic;
        in_R            : in     vl_logic_vector(15 downto 0);
        dest_R          : in     vl_logic_vector(2 downto 0);
        Qi_R            : in     vl_logic_vector(3 downto 0);
        V_R_pronto      : in     vl_logic;
        opcode          : in     vl_logic_vector(1 downto 0);
        \out\           : out    vl_logic_vector(15 downto 0);
        dest_out        : out    vl_logic_vector(2 downto 0);
        Qi_out          : out    vl_logic_vector(3 downto 0);
        habEscr         : out    vl_logic;
        nv_adt          : out    vl_logic
    );
end CDBArbiter;
