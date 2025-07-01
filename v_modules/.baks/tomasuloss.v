module tomasulo(
    input Clock,
    input Reset
  );

  /* Muito provavel ter que usar alguma logica de contagem de ciclos de instrucao (Tstep) */

  /* Para despacho duplo */
  parameter  FREE_REGISTER = 3'd0,    // Registrador livre, sem estacao de reserva
             RES_STATION_ADD1 = 3'd1, // Estacao de reserva R2
             RES_STATION_ADD2 = 3'd2; // Estacao de reserva R2

  parameter sem_valor = 16'b1111_1111_1111_0000; // Valor padrao para algo sem valor (como xxx nao existe na fpga)

  // Instanciação do módulo register status
  wire [3:0]  Qi_CDB;
  wire [15:0] Qi_CDB_data;
  wire [1:0]  Rs_Qi [3:0];
  wire [15:0] Rs_Qi_data [3:0];
  wire        Finished_ADD1;                          // Sinal de finalizacao da operacao da unidade funcional ADD1
  wire        Finished_ADD2;                          // Sinal de finalizacao da operacao da unidade


  // Instancia do modulo fila de instrucoes
  wire [15:0] Instrucao_Despachada;                   // Saida da fila de instrucoes
  wire [2:0] Ri = Instrucao_Despachada[12:10];        // Extrai o primeiro operando da instrucao despachada
  wire [2:0] Rj = Instrucao_Despachada[9:6];          // Extrai o segundo operando da instrucao despachada
  wire [2:0] Rk = Instrucao_Despachada[5:3];          // Extrai o primeiro operando da instrucao despachada

  // Instancia do modulo unidade_despacho
  wire        Pop;
  wire [2:0]  Opcode;                                 // Opcode da instrucao despachada
  wire [15:0] Vj;                                     // Valor do primeiro operando (Variaveis)
  wire [15:0] Vk;                                     // Valor do segundo operando (Variaveis)
  wire [2:0]  Qj;                                     // Estacao de reserva do primeiro operando
  wire [2:0]  Qk;                                     // Estacao de reserva do segundo operando
  wire        Enable_VQ_ADD1;                         // Sinal de habilitacao da estacao de reserva ADD1
  wire        Enable_VQ_ADD2;                         // Sinal de habilitacao da estacao de reserva ADD2
  wire [15:0] Vk_R1, Vk_R2;                           // Valor do segundo operando (Variaveis)


  // Instancia do modulo de estacao de reserva
  // wire [15:0] Q_ADD1, Q_ADD2;                      // Valor do segundo operando (Variaveis)
  // wire        Ready_R1, Ready_R2;                  // Sinal de pronto para executar a operacao
  wire        Busy_ADD1, Busy_ADD2;                   // Sinal de ocupado da estacao de reserva
  wire [2:0]  R_target_ADD1, R_target_ADD2;           // Registrador de destino da estacao de reserva ADD1 e ADD2
  wire        R_enable_ADD1;                          // Sinal de habilitacao da escrita no banco de registradores
  wire        R_enable_ADD2;                          // Sinal de habilitacao da escrita no banco de registradores

  // Instancia do modulo unidade_funcional_R
  wire [15:0] A;                                      // Valor do primeiro operando (Variaveis)
  wire [15:0] B;                                      // Sinal de saida
  wire [2:0]  Ufop_ADD1;                                   // Sinal de operacao
  wire [2:0]  Ufop_ADD2;                                   // Sinal de operacao
  wire [15:0] Q_ADD1;                                      // Sinal de saida da unidade
  wire [15:0] Q_ADD2;                                      // Sinal de saida da unidade
  wire        Write_Enable_CDB;                       // Sinal de habilitacao da escrita no CDB
  wire        Done_ADD1;                                // Sinal de finalizacao da operacao da unidade funcional ADD1
  wire        Done_ADD2;                                // Sinal de finalizacao da operacao da unidade funcional ADD1

  // Instancia do modulo seletor de unidade funcional
  wire Ready_to_uf;                           // Sinal de pronto para

  // Sinais inuteis
  wire        Full;                       // Sinal de FIFO cheia
  wire        Empty;                      // Sinal de FIFO vazia
  integer     conta_ciclos = 0;


  // Instancia do modulo register_status
  register_status u_register_status(
                    .Clock         (Clock       ),
                    .Reset         (Reset       ),
                    .Rs_Qi         (Rs_Qi       ),
                    .Rs_Qi_data    (Rs_Qi_data  ),
                    .R_enable_ADD1 (R_enable_ADD1),
                    .R_enable_ADD2 (R_enable_ADD2),
                    .R_target_ADD1 (R_target_ADD1),
                    .R_target_ADD2 (R_target_ADD2),
                    .Finished_ADD1 (Finished_ADD1),
                    .Finished_ADD2 (Finished_ADD2),
                    .Qi_CDB        (Qi_CDB      ),
                    .Qi_CDB_data   (Qi_CDB_data )
                  );

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
                     .Busy_ADD1                   (Busy_ADD1                   ),
                     .Busy_ADD2                   (Busy_ADD2                   ),
                     .Instrucao_Despachada        (Instrucao_Despachada        ),
                     .Rs_Qi                       (Rs_Qi                       ),
                     .Rs_Qi_data                  (Rs_Qi_data                  ),
                     .Vj                          (Vj                          ),
                     .Vk                          (Vk                          ),
                     .Qj                          (Qj                          ),
                     .Qk                          (Qk                          ),
                     .Ufop_ADD1                   (Ufop_ADD1                   ),
                     .Ufop_ADD2                   (Ufop_ADD2                   ),
                     .Enable_VQ_ADD1              (Enable_VQ_ADD1              ),
                     .Enable_VQ_ADD2              (Enable_VQ_ADD2              ),
                     .R_target_ADD1               (R_target_ADD1               ),
                     .R_target_ADD2               (R_target_ADD2               ),
                     .Pop                         (Pop                         )
                   );

  // Instancia do modulo CDB_arbiter
  CDB_arbiter u_CDB_arbiter(
                .Clock            (Clock            ),
                .Reset            (Reset            ),
                .Write_Enable_CDB (Write_Enable_CDB ),
                .Done_ADD1        (Done_ADD1        ),
                .Done_ADD2        (Done_ADD2        ),
                .Q_ADD1           (Q_ADD1           ),
                .Q_ADD2           (Q_ADD2           ),
                .Qi_CDB           (Qi_CDB           ),
                .Qi_CDB_data      (Qi_CDB_data      )
              );

  res_station_R ADD1(
                  .Clock     (Clock     ),
                  .Reset     (Reset     ),
                  .Opcode    (Opcode        ),
                  .Busy      (Busy_ADD1   ),
                  .Done      (Done_ADD1  ),
                  .Finished  (Finished_ADD1),
                  .Vj        (Vj        ),
                  .Vk        (Vk        ),
                  .Qj        (Qj        ),
                  .Qk        (Qk        ),
                  .R_target  (R_target_ADD1  ),
                  .R_enable  (R_enable_ADD1  ),
                  .Enable_VQ (Enable_VQ_ADD1),
                  .Ufop      (Ufop_ADD1      )
                  // .Ready     (Ready_R1  ),
                  // .Result    (Q_ADD1    )
                );

  res_station_R ADD2(
                  .Clock     (Clock     ),
                  .Reset     (Reset     ),
                  .Opcode    (Opcode        ),
                  .Busy      (Busy_ADD2   ),
                  .Done      (Done_ADD2  ),
                  .Finished  (Finished_ADD2),
                  .Vj        (Vj        ),
                  .Vk        (Vk        ),
                  .Qj        (Qj        ),
                  .Qk        (Qk        ),
                  .R_target  (R_target_ADD2  ),
                  .R_enable  (R_enable_ADD2  ),
                  .Enable_VQ (Enable_VQ_ADD2),
                  .Ufop      (Ufop_ADD2 )
                  // .Ready     (Ready_R2  ),
                  // .Result    (Q_ADD2    )
                );

  // Instancia do modulo seletor de unidade funcional
  seletor_uf seletor_uf_ADD1(
               .Clock       (Clock       ),
               .Reset       (Reset       ),
               .Vj          (Vj          ),
               .Vk          (Vk          ),
               .Qj          (Qj          ),
               .Qk          (Qk          ),
               .Qi_CDB      (Qi_CDB      ),
               .Qi_CDB_data (Qi_CDB_data ),
               .A           (A           ),
               .B           (B           ),
               .Ready_to_uf (Ready_to_uf ),
               .Busy        (Busy_ADD1)
             );

  unidade_funcional_R unidade_funcional_ADD1(
                        .A                (A                ),
                        .B                (B                ),
                        .Ufop             (Ufop_ADD1        ),
                        .Ready_to_uf      (Ready_to_uf      ),
                        .Busy             (Busy_ADD1        ),
                        .Q                (Q_ADD1                ),
                        .Reset            (Reset            ),
                        .Write_Enable_CDB (Write_Enable_CDB ),
                        .Done             (Done_ADD1     )
                      );

  always @(posedge Reset)
    begin
      // Ready_R1
    end

endmodule
