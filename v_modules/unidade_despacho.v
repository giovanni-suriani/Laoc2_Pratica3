module unidade_despacho (
    Clock,
    Reset,
    Instrucao_Despachada, // Instrucao que sera despachada
    Rs_Qi,
    Rs_Qi_data,
    Busy_ADD1,
    Busy_ADD2,
    Vj,
    Vk,
    Qj,
    Qk,
    Opcode,
    Enable_VQ_ADD1,
    Enable_VQ_ADD2,
    R_target_ADD1, 
    R_target_ADD2
  );
  parameter  FREE_REGISTER = 3'd0,    // Registrador livre, sem estacao de reserva
             RES_STATION_ADD1 = 3'd1, // Estacao de reserva R2
             RES_STATION_ADD2 = 3'd2; // Estacao de reserva R2

  parameter Vj_Vk_sem_valor = 16'b1111_1111_1111_0000, // Valor padrao para algo sem valor (como xxx nao existe na fpga)
            Qj_Qk_sem_valor = 3'b000; // Valor padrao para estacao de reserva sem valor


  input        Clock;
  input        Reset;
  input [15:0] Instrucao_Despachada;  // Instrucao que sera despachada
  input [1:0]  Rs_Qi [2:0];
  input [15:0] Rs_Qi_data [2:0];
  input        Busy_ADD1, Busy_ADD2;            // Sinal de prontidao da estacao de reserva R1

  output reg  [15:0] Vj, Vk;                        // Valores dos operandos da instrucao despachada
  output reg  [2:0]  Qj, Qk;                        // Estacao de reserva que encaminha o dado para o registrador
  output wire [2:0]  Opcode;                        // Opcode da instrucao despachada
  output reg         Enable_VQ_ADD1;   // Estacao de reserva destino para a instrucao despachada
  output reg         Enable_VQ_ADD2;   // Estacao de reserva destino para a instrucao despachada
  output reg  [2:0]  R_target_ADD1, R_target_ADD2; // Registrador de destino da estacao de reserva ADD1 e ADD2

  assign Opcode = Instrucao_Despachada [15:13]; // Extrai o opcode da instrucao despachada

  // if instrucao opcode in alguma do tipo R
  wire [2:0] Ri = Instrucao_Despachada [12:10];  // Extrai o primeiro operando da instrucao despachada
  wire [2:0] Rj = Instrucao_Despachada [9:7];    // Extrai o segundo operando da instrucao despachada
  wire [2:0] Rk = Instrucao_Despachada [6:4];    // Extrai o terceiro operando da instrucao despachada

  // Sinais das estacoes de reserva
  // wire [2:0]  Qi      [3:0];
  // wire  [15:0] Qi_data [3:0];
  wire [3:0] Qi_Busy;


  // assign Qi[0] = Rs_Qi[0]; // R0
  // assign Qi[1] = Rs_Qi[1]; // R1
  // assign Qi[2] = Rs_Qi[2]; // R2
  // assign Qi_data[0] = Rs_Qi_data[0]; // R0
  // assign Qi_data[1] = Rs_Qi_data[1]; // R1
  // assign Qi_data[2] = Rs_Qi_data[2]; // R2
  assign Qi_Busy = {1'b0, 1'b0, Busy_ADD2, Busy_ADD1}; // Sinal de prontidao das estacoes de reserva

  always @(posedge Clock or posedge Reset)
    if (Reset)
      begin
        Vj <= Vj_Vk_sem_valor; // Valor padrao para vj
        Vk <= Vj_Vk_sem_valor; // Valor padrao para vk
        Qj <= Qj_Qk_sem_valor; // Estacao de reserva padrao para qj
        Qk <= Qj_Qk_sem_valor; // Estacao de reserva padrao para qk
        Enable_VQ_ADD1 <= 1'b0; // Desativa a estacao de reserva R1
        Enable_VQ_ADD2 <= 1'b0; // Desativa a estacao de reserva R2
        R_target_ADD1 <= 3'b000; // Registrador de destino da estacao de reserva ADD1
        R_target_ADD2 <= 3'b000; // Registrador de destino da estacao de reserva ADD2

      end
    else
      begin
        if (Opcode == 3'b000) // NOP
          begin
            // Faz nada
          end
        else
          begin
            Enable_VQ_ADD1 <= 1'b0; // Desativa a estacao de reserva R1
            Enable_VQ_ADD2 <= 1'b0; // Desativa a estacao de reserva R2
            // Resolvendo vj ou qj
            if (Rs_Qi[Rj] == FREE_REGISTER)
              begin
                Vj <= Rs_Qi_data[Rj];
                Qj <= 3'b000;
              end
            else
              begin
                Vj <= Vj_Vk_sem_valor;
                Qj <= Rs_Qi[Rj];
              end

            // Resolvendo vk ou qk
            if (Rs_Qi[Rk] == FREE_REGISTER)
              begin
                Vk <= Rs_Qi_data[Rk];
                Qk <= 3'b000;
              end
            else
              begin
                Vk <= Vj_Vk_sem_valor;
                Qk <= Rs_Qi[Rk];
              end

            // Devolve a estacao de reserva responsavel por realizar a instrucao despachada
            if (!Qi_Busy[0])
              begin
                Enable_VQ_ADD1 <= 1'b1; // Ativa a estacao de reserva R1
                Enable_VQ_ADD2 <= 1'b0; // Desativa a estacao de reserva R2
                R_target_ADD1  <= Ri;
                // Estacao_Reserva_Destino <= RES_STATION_ADD1; // Estacao de reserva R1
              end
            else if (!Qi_Busy[1])
              begin
                Enable_VQ_ADD1 <= 1'b0; // Desativa a estacao de reserva R1
                Enable_VQ_ADD2 <= 1'b1; // Ativa a est
                R_target_ADD2  <= Ri;
              end
          end
      end
  // O acesso aos registradores sera feito pela tabela de registradores

endmodule
