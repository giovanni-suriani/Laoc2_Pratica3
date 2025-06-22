module res_station_R (
        Clock,
        Reset,
        Op,
        Busy,
        Vj, Vk,              // valores dos operandos
        Qj, Qk,               // estacoes de reserva dependentes
        Ready, // pode executar?
        Result,
        Enable_VQ // habilita a sobrescrita do Vj e Vk, Qj e Qk
    );
    
    input Clock, Reset;
    input [2:0] Op;
    input Busy;
    input [15:0] Vj, Vk;
    input [2:0] Qj, Qk;
    input Enable_VQ; // Habilita a sobrescrita do Vj e Vk, Qj e Qk
    output Ready;
    output [15:0] Result;


    // aqui voce decide se tem operandos prontos (Qj e Qk == 0)
    // e faz a operacao se puder
endmodule
