module res_station_R (
        Clock,
        Reset,
        Op,
        Busy,
        Vj, Vk,              // valores dos operandos
        Qj, Qk,               // estacoes de reserva dependentes
        Ready, // pode executar?
        Result
    );
    
    input Clock, Reset;
    input [3:0] Op;
    input Busy;
    input [15:0] Vj, Vk;
    input [2:0] Qj, Qk;
    output Ready;
    output Result;


    // aqui voce decide se tem operandos prontos (Qj e Qk == 0)
    // e faz a operacao se puder
endmodule
