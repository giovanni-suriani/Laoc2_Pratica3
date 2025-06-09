library verilog;
use verilog.vl_types.all;
entity unidadeFuncional is
    port(
        clock           : in     vl_logic;
        nova            : in     vl_logic;
        opcode          : in     vl_logic_vector(1 downto 0);
        Vj              : in     vl_logic_vector(15 downto 0);
        Vk              : in     vl_logic_vector(15 downto 0);
        dest_in         : in     vl_logic_vector(2 downto 0);
        Qi_in           : in     vl_logic_vector(3 downto 0);
        Vi              : out    vl_logic_vector(15 downto 0);
        V_pronto        : out    vl_logic;
        UF_atoa         : out    vl_logic;
        dest_out        : out    vl_logic_vector(2 downto 0);
        Qi_out          : out    vl_logic_vector(3 downto 0)
    );
end unidadeFuncional;
