module register_status(
        Clock,
        Reset,
        R1_Qi,
        R2_Qi,
        R3_Qi
    );
    // Modulo de tabela de status dos registradores: qual estacao de reserva encaminha o dado para o registrador
    parameter  RES_STATION_ADD1 = 2'b00, // Estacao de reserva R1
               RES_STATION_ADD2 = 2'b01; // Estacao de reserva R2

    input Clock, Reset;
    output reg [1:0] R1_Qi, R2_Qi, R3_Qi;

    always @(posedge Clock or posedge Reset)
    begin
        if (Reset) begin
            R1_Qi <= RES_STATION_ADD1; // Inicializa o registrador R1 com a estacao de reserva 1
            R2_Qi <= RES_STATION_ADD1; // Inicializa o registrador R2 com a estacao de reserva 2
            R3_Qi <= RES_STATION_ADD1; // Inicializa o registrador R3 com a estacao de reserva 1
        end else begin
            // implementar a logica para atualizar os valores de Qi dos registradores de acordo 
            // com a instrucao, ou alguma coisa na estacao de reserva, ou algum modulo intermediario, modulo de despacho
            // dependendo das operacoes que estao sendo executadas nas estacoes de reserva.
        end
    end

endmodule
