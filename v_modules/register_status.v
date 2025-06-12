module register_status(
        Clock,
        Reset,
        R1_Qi,
        R2_Qi,
        R3_Qi
    );
    // Modulo de tabela de status dos registradores

    input Clock, Reset;
    output reg [1:0] R1_Qi, R2_Qi, R3_Qi;

endmodule
