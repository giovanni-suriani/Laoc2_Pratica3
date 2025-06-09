library verilog;
use verilog.vl_types.all;
entity filaInstrucoes is
    port(
        clock           : in     vl_logic;
        SR_R_cheia      : in     vl_logic;
        SR_I_cheia      : in     vl_logic;
        instrucao_out   : out    vl_logic_vector(15 downto 0);
        nv_inst         : out    vl_logic;
        endr_Vj         : out    vl_logic_vector(2 downto 0);
        endr_Vk         : out    vl_logic_vector(2 downto 0)
    );
end filaInstrucoes;
