module unidade_despacho (
        Clock,
        Reset,
        Instrucao_Despachada, // Instrucao que sera despachada
        R0_Qi,
        R1_Qi,
        R2_Qi,
        R0_Qi_data,
        R1_Qi_data,
        R2_Qi_data,
        Ready_R1,
        Ready_R2,
        Vj,
        Vk,
        Qj,
        Qk
    );
    parameter  FREE_REGISTER = 3'd0,    // Registrador livre, sem estacao de reserva
               RES_STATION_ADD1 = 3'd1, // Estacao de reserva R2
               RES_STATION_ADD2 = 3'd2; // Estacao de reserva R2

    parameter Vj_Vk_sem_valor = 16'b1111_1111_1111_0000, // Valor padrao para algo sem valor (como xxx nao existe na fpga)
              Qj_Qk_sem_valor = 3'b000; // Valor padrao para estacao de reserva sem valor


    input Clock;
    input Reset;
    input Ready_R1, Ready_R2; // Sinal de prontidao da estacao de reserva R1
    input [2:0] R0_Qi, R1_Qi, R2_Qi; // Qi dos registradores R1, R2 e R3
    input [15:0] R0_Qi_data, R1_Qi_data, R2_Qi_data; // Dados dos registradores R1, R2 e R3
    input [15:0] Instrucao_Despachada;  // Instrucao que sera despachada

    output reg [15:0] Vj, Vk; // Valores dos operandos da instrucao despachada
    output reg [2:0] Qj, Qk; // Estacao de reserva que encaminha o dado para o registrador

    // if instrucao opcode in alguma do tipo R
    wire [2:0] Ri = Instrucao_Despachada [12:10];  // Extrai o primeiro operando da instrucao despachada
    wire [2:0] Rj = Instrucao_Despachada [9:6];    // Extrai o segundo operando da instrucao despachada
    wire [2:0] Rk = Instrucao_Despachada [5:3];    // Extrai o terceiro operando da instrucao despachada

    // Sinais das estacoes de reserva
    reg [2:0] Qi [3:0];
    reg [15:0] Qi_data [3:0];
    wire Qi_Ready [3:0];

    // case (Rj)
    //   3'b000:
    //   begin
    //     if (R0_Qi == FREE_REGISTER) // Se o registrador R0 estiver livre
    //     begin
    //       Vj <= R0_Qi_data; // Atribui o valor do registrador R0
    //       Qi <= FREE_REGISTER; // Estacao de reserva livre
    //     end
    //   end
    //   default: 
    // endcase

    if (Rj == 3'd0) // Se o registrador de destino for 0, nao faz nada
    begin
      if (R0_Qi == FREE_REGISTER) // Se o registrador R0 estiver livre
        begin
          Vj <= R0_Qi_data; // Atribui o valor do registrador R0
        end
      else if (R0_Qi != FREE_REGISTER) // Se o registrador R0 estiver ocupado
        begin
          Vj <= Vj_Vk_sem_valor; // Atribui 0, pois o registrador R0 esta ocupado
          Qj <= R0_Qi; // Atribui a estacao de reserva que esta ocupando o registrador R0
        end
    end
    else if (Rj == 3'd1) // Se o registrador de destino for 1, atribui o valor do registrador R1
    begin
      if (R1_Qi == FREE_REGISTER) // Se o registrador R1 estiver livre
        begin
          Vj <= R1_Qi_data; // Atribui o valor do registrador R1
        end
      else if (R1_Qi != FREE_REGISTER) // Se o registrador R1 estiver ocupado
        begin
          Vj <= Vj_Vk_sem_valor; // Atribui 0, pois o registrador R1 esta ocupado
          Qj <= R1_Qi; // Atribui a estacao de reserva que esta ocupando o registrador R1
        end
    end
    else if (Rj == 3'd2) // Se o registrador de destino for 2, atribui o valor do registrador R2
    begin
      if (R2_Qi == FREE_REGISTER) // Se o registrador R2 estiver livre
        begin
          Vj <= R2_Qi_data; // Atribui o valor do registrador R2
        end
      else if (R2_Qi != FREE_REGISTER) // Se o registrador R2 estiver ocupado
        begin
          Vj <= Vj_Vk_sem_valor; // Atribui 0, pois o registrador R2 esta ocupado
          Qj <= R2_Qi; // Atribui a estacao de reserva que esta ocupando o registrador R2
        end
    end

    // O acesso aos registradores sera feito pela tabela de registradores




    // assign Ri = Instrucao_Despachada[15:12]; // Registrador de destino da instrucao despachada
    // Sinais das estacoes de reserva
    output reg Estacao_Reserva_Destino; // Estacao de reserva destino para a instrucao despachada

endmodule
