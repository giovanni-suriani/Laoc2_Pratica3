module register_status(
    Clock,
    Reset,
    Rs_Qi,
    Rs_Qi_data,
    Qi_CDB,
    Qi_CDB_data
  );
  // Modulo de tabela de status dos registradores: qual estacao de reserva encaminha o dado para o registrador
  parameter  FREE_REGISTER = 3'd0,    // Registrador livre, sem estacao de reserva
             RES_STATION_ADD1 = 3'd1, // Estacao de reserva R2
             RES_STATION_ADD2 = 3'd2; // Estacao de reserva R2

  // Parametros sobre Vj/Vk, Qi/Qk sem valor
  parameter Vj_Vk_sem_valor = 16'b1111_1111_1111_0000, // Valor padrao para algo sem valor (como xxx nao existe na fpga)
            Qj_Qk_sem_valor = 3'b000; // Valor padrao para estacao de reserva sem valor


  input             Clock, Reset;
  input [3:0]       Qi_CDB;                 // Sinal de CDB (Common Data Bus) indicando que o dado foi enviado
  input [15:0]      Qi_CDB_data;           // Dados dos registradores R0, R1 e R2
  output reg [1:0]  Rs_Qi [2:0];       // Qi dos registradores R0, R1 e R2
  output reg [15:0] Rs_Qi_data [2:0]; // Dados dos registradores R0, R1 e R2


  always @(posedge Clock or posedge Reset) // Provavelmente atribuicao no negedge
    begin
      if (Reset)
        begin
          Rs_Qi[0] <= FREE_REGISTER;  // Inicializa o registrador R0
          Rs_Qi[1] <= FREE_REGISTER;  // Inicializa o registrador R1
          Rs_Qi[2] <= FREE_REGISTER;  // Inicializa o registrador R2
          Rs_Qi_data[0] <= 16'b0;     // Inicializa o valor do registrador R0
          Rs_Qi_data[1] <= 16'b0;     // Inicializa o valor do registrador R1
          Rs_Qi_data[2] <= 16'b0;     // Inicializa o valor do registrador R2
        end
      else
        begin
          // implementar a logica para atualizar os valores de Qi dos registradores de acordo
          // com a instrucao, ou alguma coisa na estacao de reserva, ou algum modulo intermediario, modulo de despacho
          // dependendo das operacoes que estao sendo executadas nas estacoes de reserva.
        end
    end

endmodule
