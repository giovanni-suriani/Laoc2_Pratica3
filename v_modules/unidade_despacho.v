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
    Ufop_ADD1,
    Ufop_ADD2,
    Enable_VQ_ADD1,
    Enable_VQ_ADD2,
    R_target_ADD1,
    R_target_ADD2,
    R_enable_despacho,
    R_target_despacho,
    R_res_station_despacho,
    Pop
  );
  parameter  FREE_REGISTER = 3'd0,    // Registrador livre, sem estacao de reserva
             RES_STATION_ADD1 = 3'd1, // Estacao de reserva R2
             RES_STATION_ADD2 = 3'd2; // Estacao de reserva R2

  parameter Vj_Vk_sem_valor = 16'b1111_1111_1111_0000, // Valor padrao para algo sem valor (como xxx nao existe na fpga)
            Qj_Qk_sem_valor = 3'b000; // Valor padrao para estacao de reserva sem valor


  input        Clock;
  input        Reset;
  input [15:0] Instrucao_Despachada;  // Instrucao que sera despachada
  input [1:0]  Rs_Qi [3:0];
  input [15:0] Rs_Qi_data [3:0];
  input        Busy_ADD1, Busy_ADD2;            // Sinal de prontidao da estacao de reserva R1

  output reg  [15:0] Vj, Vk;                        // Valores dos operandos da instrucao despachada
  output reg  [2:0]  Qj, Qk;                        // Estacao de reserva que encaminha o dado para o registrador
  output reg  [2:0]  Ufop_ADD1;                        // Opcode da instrucao despachada
  output reg  [2:0]  Ufop_ADD2;                        // Opcode da instrucao despachada
  output reg         Enable_VQ_ADD1;   // Estacao de reserva destino para a instrucao despachada
  output reg         Enable_VQ_ADD2;   // Estacao de reserva destino para a instrucao despachada
  output reg  [3:0]  R_target_despacho, R_target_ADD1, R_target_ADD2; // Registrador de destino da estacao de reserva ADD1 e ADD2
  output reg  [3:0]  R_res_station_despacho; // Estacao de reserva usada para o despacho
  output reg         R_enable_despacho; // Sinal de habilitacao da escrita no banco de registradores para o despacho
  output reg         Pop; // Sinal de pop para a unidade de despacho

  // assign Opcode = Instrucao_Despachada [15:13]; // Extrai o opcode da instrucao despachada

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
  assign Qi_Busy = {1'b1, 1'b1, Busy_ADD2, Busy_ADD1}; // Sinal de prontidao das estacoes de reserva

  always @(posedge Clock or posedge Reset)
    if (Reset)
      begin
        Vj                     <= Vj_Vk_sem_valor; // Valor padrao para vj
        Vk                     <= Vj_Vk_sem_valor; // Valor padrao para vk
        Qj                     <= Qj_Qk_sem_valor; // Estacao de reserva padrao para qj
        Qk                     <= Qj_Qk_sem_valor; // Estacao de reserva padrao para qk
        Enable_VQ_ADD1         <= 1'b0; // Desativa a estacao de reserva R1
        Enable_VQ_ADD2         <= 1'b0; // Desativa a estacao de reserva R2
        R_enable_despacho      <= 1'b0; // Desativa o sinal de habilitacao da escrita no banco de registradores para o despacho
        R_target_despacho      <= 3'b000; // Qual registrador de destino da estacao de reserva despacho
        R_res_station_despacho <= 3'b000; // Estacao de reserva despacho
        R_target_ADD1          <= 3'b000; // Registrador de destino da estacao de reserva ADD1
        R_target_ADD2          <= 3'b000; // Registrador de destino da estacao de reserva ADD2
        Ufop_ADD1              <= 3'b000; // Opcode padrao para instrucao sem valor
        Ufop_ADD2              <= 3'b000; // Opcode padrao para instrucao sem valor
        Pop                    <= 1'b0; // Sinal de pop padrao
      end
    else
      begin
        Pop = 1'b1; // Ativa o sinal de pop para a unidade de despacho
        if (Instrucao_Despachada [15:13] == 3'b000) // NOP
          begin
            // Faz nada
          end
        else
          begin
            Enable_VQ_ADD1 <= 1'b0; // Desativa a estacao de reserva R1
            Enable_VQ_ADD2 <= 1'b0; // Desativa a estacao de reserva R2
            // Resolvendo vj ou qj
            // $display("[%0t] unidade_despacho Rs_Qi: %p",$time, Rs_Qi);
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

            // Devolve a estacao de reserva responsavel por realizar a instrucao despachada NAO ESTA NO MESMO PADRAO DE RS_QI
            if (!Qi_Busy[0])
              begin
                Enable_VQ_ADD1         <= 1'b1;                         // Ativa a estacao de reserva R1
                Enable_VQ_ADD2         <= 1'b0;                         // Desativa a estacao de reserva R2
                R_target_ADD1          <= Ri;                           // Registrador de destino da estacao de reserva ADD1
                R_enable_despacho      <= 1'b1;                         // Habilita o registrador de destino para escrita
                R_target_despacho      <= Ri;                           // Registrador de destino da estacao de reserva despacho
                R_res_station_despacho <= RES_STATION_ADD1;             // Estacao de reserva despacho
                Ufop_ADD1              <= Instrucao_Despachada [15:13]; // Opcode da instrucao despachada

                // Estacao_Reserva_Destino <= RES_STATION_ADD1; // Estacao de reserva R1
              end
            else if (!Qi_Busy[1])
              begin
                Enable_VQ_ADD1         <= 1'b0; // Desativa a estacao de reserva R1
                Enable_VQ_ADD2         <= 1'b1;                         // Ativa a est
                R_target_ADD2          <= Ri;
                R_enable_despacho      <= 1'b1;                         // Habilita o registrador de destino para escrita
                R_target_despacho      <= Ri;                           // Registrador de destino da estacao de reserva despacho
                R_res_station_despacho <= RES_STATION_ADD2;             // Estacao de reserva despacho
                Ufop_ADD2              <= Instrucao_Despachada [15:13]; // Opcode da instrucao despachada
              end
            else if (Qi_Busy[1:0] == 2'b11) // Estacoes de reservas ocupadas
              begin
                R_enable_despacho <= 1'b0; // Desabilita o registrador de destino para escrita
                Pop               <= 1'b0;     // Desativa o sinal de pop para a unidade de despacho
              end
          end
      end
  // O acesso aos registradores sera feito pela tabela de registradores

endmodule
