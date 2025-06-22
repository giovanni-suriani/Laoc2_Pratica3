module tomasulo(
    input Clock,
    input Reset,
    input Pop);

  /* Muito provavel ter que usar alguma logica de contagem de ciclos de instrucao (Tstep) */

  /* Para despacho duplo */
  parameter  FREE_REGISTER = 3'd0,    // Registrador livre, sem estacao de reserva
             RES_STATION_ADD1 = 3'd1, // Estacao de reserva R2
             RES_STATION_ADD2 = 3'd2; // Estacao de reserva R2

  parameter sem_valor = 16'b1111_1111_1111_0000; // Valor padrao para algo sem valor (como xxx nao existe na fpga)

  // Instanciação do módulo registrador
  wire [3:0]  Qi_CDB;
  wire [15:0] Qi_CDB_data;
  wire [1:0]  Rs_Qi [2:0];
  wire [15:0] Rs_Qi_data [2:0];


  // Instancia do modulo fila de instrucoes
  wire [15:0] Instrucao_Despachada;                   // Saida da fila de instrucoes
  wire [2:0] Op = Instrucao_Despachada[15:13];        // Extrai a operacao da instrucao despachada
  wire [2:0] Ri = Instrucao_Despachada[12:10];        // Extrai o primeiro operando da instrucao despachada
  wire [2:0] Rj = Instrucao_Despachada[9:6];          // Extrai o segundo operando da instrucao despachada
  wire [2:0] Rk = Instrucao_Despachada[5:3];          // Extrai o primeiro operando da instrucao despachada

  // Instancia do modulo unidade_despacho
  wire [15:0] Vj;                                     // Valor do primeiro operando (Variaveis)
  wire [15:0] Vk;                                     // Valor do segundo operando (Variaveis)
  wire [2:0]  Qj;                                     // Estacao de reserva do primeiro operando
  wire [2:0]  Qk;                                     // Estacao de reserva do segundo operando
  wire        Estacao_Reserva_ADD1_Enable;            // Sinal de habilitacao da estacao de reserva ADD1
  wire        Estacao_Reserva_ADD2_Enable;            // Sinal de habilitacao da estacao de reserva ADD2
  wire [15:0] Vk_R1, Vk_R2;                           // Valor do segundo operando (Variaveis)


  // Instancia do modulo de estacao de reserva 
  wire [15:0] Q_ADD1, Q_ADD2;                         // Valor do segundo operando (Variaveis)
  wire        Ready_R1, Ready_R2;                     // Sinal de pronto para executar a operacao
  wire        Busy_R1, Busy_R2;                       // Sinal de ocupado da estacao de reserva

  // Sinais inuteis
  wire        Full;                       // Sinal de FIFO cheia
  wire        Empty;                      // Sinal de FIFO vazia
  integer     conta_ciclos = 0;


// Instancia do modulo register_status
register_status u_register_status(
                  .Clock       (Clock       ),
                  .Reset       (Reset       ),
                  .Qi_CDB      (Qi_CDB      ),
                  .Qi_CDB_data (Qi_CDB_data ),
                  .Rs_Qi       (Rs_Qi       ),
                  .Rs_Qi_data  (Rs_Qi_data  )
                )
                  ;

  // Instancia do modulo unidade_despacho
  fila_de_instrucoes u_fila_de_instrucoes(
                       .Clock                (Clock                ),
                       .Reset                (Reset                ),
                       .Pop                  (Pop                  ),
                       .Instrucao_Despachada (Instrucao_Despachada ),
                       .Full                 (Full                 ),
                       .Empty                (Empty                )
                     );

  unidade_despacho u_unidade_despacho(
                     .Clock                       (Clock                       ),
                     .Reset                       (Reset                       ),
                     .Ready_R1                    (Ready_R1                    ),
                     .Ready_R2                    (Ready_R2                    ),
                     .Instrucao_Despachada        (Instrucao_Despachada        ),
                     .Rs_Qi                       (Rs_Qi                       ),
                     .Rs_Qi_data                  (Rs_Qi_data                  ),
                     .Vj                          (Vj                          ),
                     .Vk                          (Vk                          ),
                     .Qj                          (Qj                          ),
                     .Qk                          (Qk                          ),
                     .Estacao_Reserva_ADD1_Enable (Estacao_Reserva_ADD1_Enable ),
                     .Estacao_Reserva_ADD2_Enable (Estacao_Reserva_ADD2_Enable )
                   );

  res_station_R Estacao_De_Reserva_R_1(
                  .Clock  (Clock     ),
                  .Reset  (Reset     ),
                  .Op     (Op        ),
                  .Busy   (Busy_R1   ),
                  .Vj     (Vj        ),
                  .Vk     (Vk        ),
                  .Qj     (Qj        ),
                  .Qk     (Qk        ),
                  .Ready  (Ready_R1  ),
                  .Result (Q_ADD1    ),
                  .Enable_VQ (Estacao_Reserva_ADD1_Enable)
                );

  res_station_R Estacao_De_Reserva_R_2(
                  .Clock  (Clock     ),
                  .Reset  (Reset     ),
                  .Op     (Op        ),
                  .Busy   (Busy_R2   ),
                  .Vj     (Vj        ),
                  .Vk     (Vk        ),
                  .Qj     (Qj        ),
                  .Qk     (Qk        ),
                  .Ready  (Ready_R2  ),
                  .Result (Q_ADD2    ),
                  .Enable_VQ (Estacao_Reserva_ADD2_Enable)
                );



endmodule
