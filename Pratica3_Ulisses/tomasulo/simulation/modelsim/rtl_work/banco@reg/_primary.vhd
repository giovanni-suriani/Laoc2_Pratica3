library verilog;
use verilog.vl_types.all;
entity bancoReg is
    port(
        regLido1        : in     vl_logic_vector(2 downto 0);
        regLido2        : in     vl_logic_vector(2 downto 0);
        regEscr         : in     vl_logic_vector(2 downto 0);
        dadoEscr        : in     vl_logic_vector(15 downto 0);
        dado1           : out    vl_logic_vector(15 downto 0);
        dado2           : out    vl_logic_vector(15 downto 0);
        habEscr         : in     vl_logic;
        clock           : in     vl_logic;
        reg0            : out    vl_logic_vector(15 downto 0);
        reg1            : out    vl_logic_vector(15 downto 0);
        reg2            : out    vl_logic_vector(15 downto 0);
        reg3            : out    vl_logic_vector(15 downto 0);
        reg4            : out    vl_logic_vector(15 downto 0);
        reg5            : out    vl_logic_vector(15 downto 0);
        reg6            : out    vl_logic_vector(15 downto 0);
        reg7            : out    vl_logic_vector(15 downto 0)
    );
end bancoReg;
