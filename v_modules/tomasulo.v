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

  parameter Vj_Vk_sem_valor = 16'b1111_1111_1111_0000, // Valor padrao para algo sem valor (como xxx nao existe na fpga)
            Qj_Qk_sem_valor = 3'b000, // Valor padrao para estacao de reserva sem valor
            A_sem_valor     = 7'b1010000; // Valor padrao para A (imediato) sem valor


  // Instanciacao do modulo contador
  wire       Clear;                     // Sinal de clear do contador
  wire [2:0] Tstep;                     // Sinal de clock do contador

  // Instanciação do modulo register status
  wire [3:0]  Qi_CDB;
  wire [15:0] Qi_CDB_data;
  wire [1:0]  Rs_Qi [3:0];
  wire [15:0] Rs_Qi_data [3:0];
  wire        Finished_ADD1;                          // Sinal de finalizacao da operacao da unidade funcional ADD1
  wire        Finished_ADD2;                          // Sinal de finalizacao da operacao da unidade
  wire        Finished_LOAD1;                                  // Sinal de finalizacao da operacao da unidade funcional LOAD1
  wire        Finished_LOAD2;                                  // Sinal de finalizacao da operacao da unidade funcional


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
  wire [6:0]  A;                                      // Imediato para calculo de endereco
  wire        Enable_VQ_ADD1;                         // Sinal de habilitacao da estacao de reserva ADD1
  wire        Enable_VQ_ADD2;                         // Sinal de habilitacao da estacao de reserva ADD2
  wire        Enable_VQ_LOAD1;                         // Sinal de habilitacao da estacao de reserva ADD1
  wire        Enable_VQ_LOAD2;                         // Sinal de habilitacao da estacao de reserva ADD1
  wire [15:0] Vk_R1, Vk_R2;                           // Valor do segundo operando (Variaveis)
  wire        R_enable_despacho;
  wire [3:0]  R_target_despacho;                     // Registrador de destino da instrucao
  wire [3:0]  R_res_station_despacho;                // Estacao de reserva que o registrador destino esta dependente
  wire Pop_I;
  wire Pop_R; // Sinal de pop para a unidade de despacho

  // Instancia do modulo de estacao de reserva R
  wire [15:0] Vj_reg_ADD1, Vj_reg_ADD2;           // Registrador para o primeiro operando
  wire [15:0] Vk_reg_ADD1, Vk_reg_ADD2;           // Registrador para o segundo operando
  wire [2:0]  Qj_reg_ADD1, Qj_reg_ADD2;           // Registrador para a estacao de reserva do primeiro
  wire [2:0]  Qk_reg_ADD1, Qk_reg_ADD2;           // Registrador para a estacao de reserva do segundo
  wire        Busy_ADD1, Busy_ADD2;                   // Sinal de ocupado da estacao de reserva
  wire [3:0]  R_target_ADD1, R_target_ADD2;           // Registrador de destino da estacao de reserva ADD1 e ADD2
  wire        R_enable_ADD1;                          // Sinal de habilitacao da escrita no banco de registradores
  wire        R_enable_ADD2;                          // Sinal de habilitacao da escrita no banco de registradores


  // Instancia do modulo unidade_funcional_R
  wire [15:0] Op1_ADD1, Op1_ADD2;                                      // Valor do primeiro operando (Variaveis)
  wire [15:0] Op2_ADD1, Op2_ADD2;                                      // Sinal de saida
  wire [15:0] Op1_LOAD1, Op1_LOAD2;                                  // Sinal de saida
  wire [15:0] Op2_LOAD1, Op2_LOAD2;                                  // Sinal de saida
  wire [15:0] Op3_LOAD1, Op3_LOAD2;                                  // Sinal de saida
  wire [2:0]  Ufop_ADD1;                                   // Sinal de operacao
  wire [2:0]  Ufop_ADD2;                                   // Sinal de operacao
  wire [2:0]  Ufop_LOAD1;                                   // Sinal de operacao
  wire [2:0]  Ufop_LOAD2;                                   // Sinal de operacao
  wire [15:0] Q_ADD1;                                      // Sinal de saida da unidade
  wire [15:0] Q_ADD2;                                      // Sinal de saida da unidade
  wire [15:0] Q_LOAD1;                                     // Sinal de saida da unidade
  wire [15:0] Q_LOAD2;                                     // Sinal de saida da
  wire        Write_Enable_CDB;                       // Sinal de habilitacao da escrita no CDB
  wire        Write_Enable_CDB_LOAD1;                       // Sinal de habilitacao da escrita no CDB
  wire        Write_Enable_CDB_LOAD2;                       // Sinal de habilitacao da escrita no CDB
  wire        Done_ADD1;                                // Sinal de finalizacao da operacao da unidade funcional ADD1
  wire        Done_ADD2;                                // Sinal de finalizacao da operacao da unidade funcional ADD1
  wire        Done_LOAD1;                              // Sinal de finalizacao da operacao da unidade funcional LOAD1
  wire        Done_LOAD2;                              // Sinal de finalizacao da operacao da unidade

  // Instancia do modulo seletor de unidade funcional
  wire Ready_to_uf_ADD1;                           // Sinal de pronto para
  wire Ready_to_uf_ADD2;                           // Sinal de pronto para
  wire Ready_to_uf_LOAD1;                         // Sinal de pronto para
  wire Ready_to_uf_LOAD2;                         // Sinal de pronto para
  wire Clear_counter_ADD1;                         // Sinal de clear para resetar o contador da unidade funcional ADD1
  wire Clear_counter_ADD2;                         // Sinal de clear para resetar o contador da unidade funcional ADD2
  wire Clear_counter_LOAD1;                       // Sinal de clear para resetar o contador da unidade funcional LOAD1
  wire Clear_counter_LOAD2;                       // Sinal de clear para resetar o contador da unidade funcional LOAD2

  // Instancia do modulo de estacao de reserva I
  wire [15:0] Vj_reg_LOAD1,   Vj_reg_LOAD2;              // Registrador para o primeiro operando
  wire [15:0] Vk_reg_LOAD1,   Vk_reg_LOAD2;              // Registrador para o segundo operando
  wire [6:0]  A_reg_LOAD1,    A_reg_LOAD2;              // Registrador para o segundo operando
  wire [2:0]  Qj_reg_LOAD1,   Qj_reg_LOAD2;              // Registrador para a estacao de reserva do primeiro
  wire [2:0]  Qk_reg_LOAD1,   Qk_reg_LOAD2;              // Registrador para a estacao de reserva do segundo
  wire        Busy_LOAD1,     Busy_LOAD2;                // Sinal de ocupado da estacao de reserva
  wire [3:0]  R_target_LOAD1, R_target_LOAD2;          // Registrador de destino da estacao de reserva LOAD1 e LOAD2
  wire        R_enable_LOAD1, R_enable_LOAD2;          // Sinal de habilitacao da escrita no banco de registradores


  // Sinais inuteis
  wire        Full;                       // Sinal de FIFO cheia
  wire        Empty;                      // Sinal de FIFO vazia
  integer     conta_ciclos = 0;
  wire [15:0] Dummy;

  // Instancia do modulo register_status
  register_status u_register_status(
                    .Clock                    (Clock       ),
                    .Reset                    (Reset       ),
                    .Rs_Qi                    (Rs_Qi       ),
                    .Rs_Qi_data               (Rs_Qi_data  ),
                    .R_enable_ADD1            (R_enable_ADD1),
                    .R_enable_ADD2            (R_enable_ADD2),
                    .R_enable_LOAD1           (R_enable_LOAD1),
                    .R_enable_LOAD2           (R_enable_LOAD2),
                    .R_target_ADD1            (R_target_ADD1),
                    .R_target_ADD2            (R_target_ADD2),
                    .R_target_LOAD1           (R_target_LOAD1),
                    .R_target_LOAD2           (R_target_LOAD2),
                    .Finished_ADD1            (Finished_ADD1),
                    .Finished_ADD2            (Finished_ADD2),
                    .Finished_LOAD1           (Finished_LOAD1),
                    .Finished_LOAD2           (Finished_LOAD2),
                    .R_enable_despacho        (R_enable_despacho),
                    .R_target_despacho        (R_target_despacho),
                    .R_res_station_despacho   (R_res_station_despacho),
                    .Qi_CDB                   (Qi_CDB      ),
                    .Qi_CDB_data              (Qi_CDB_data )
                  );

  // Instancia do modulo unidade_despacho
  fila_de_instrucoes u_fila_de_instrucoes(
                       .Clock                (Clock                ),
                       .Reset                (Reset                ),
                       .Pop                  (Pop                  ),
                       .Pop_R                (Pop_R                ),
                       .Pop_I                (Pop_I                ),
                       .Instrucao_Despachada (Instrucao_Despachada ),
                       .Full                 (Full                 ),
                       .Empty                (Empty                )
                     );

  unidade_despacho u_unidade_despacho(
                     .Clock                       (Clock                       ),
                     .Reset                       (Reset                       ),
                     .Busy_ADD1                   (Busy_ADD1                   ),
                     .Busy_ADD2                   (Busy_ADD2                   ),
                     .Busy_LOAD1                  (Busy_LOAD1                  ),
                     .Busy_LOAD2                  (Busy_LOAD2                  ),
                     .Instrucao_Despachada        (Instrucao_Despachada        ),
                     .Rs_Qi                       (Rs_Qi                       ),
                     .Rs_Qi_data                  (Rs_Qi_data                  ),
                     .Vj                          (Vj                          ),
                     .Vk                          (Vk                          ),
                     .Qj                          (Qj                          ),
                     .Qk                          (Qk                          ),
                     .A                           (A                           ),
                     .Opcode                      (Opcode                      ),
                     //  .Ufop_ADD1                   (Ufop_ADD1                   ),
                     //  .Ufop_ADD2                   (Ufop_ADD2                   ),
                     //  .Ufop_LOAD1                  (Ufop_LOAD1                  ),
                     //  .Ufop_LOAD2                  (Ufop_LOAD2                  ),
                     .Enable_VQ_ADD1              (Enable_VQ_ADD1              ),
                     .Enable_VQ_ADD2              (Enable_VQ_ADD2              ),
                     .Enable_VQ_LOAD1             (Enable_VQ_LOAD1             ),
                     .Enable_VQ_LOAD2             (Enable_VQ_LOAD2             ),
                     .R_target_ADD1               (R_target_ADD1               ),
                     .R_target_ADD2               (R_target_ADD2               ),
                     .R_target_LOAD1              (R_target_LOAD1              ),
                     .R_target_LOAD2              (R_target_LOAD2              ),
                     .R_enable_despacho           (R_enable_despacho           ),
                     .R_target_despacho           (R_target_despacho           ),
                     .R_res_station_despacho      (R_res_station_despacho      ),
                     .Pop                         (Pop                         ),
                     .Pop_R                       (Pop_R                       ),
                     .Pop_I                       (Pop_I                       )
                   );

  // Instancia do modulo CDB_arbiter
  CDB_arbiter u_CDB_arbiter(
                .Clock            (Clock            ),
                .Reset            (Reset            ),
                .Write_Enable_CDB_LOAD1 (Write_Enable_CDB_LOAD1 ),
                .Write_Enable_CDB_LOAD2 (Write_Enable_CDB_LOAD2 ),
                .Done_ADD1        (Done_ADD1        ),
                .Done_ADD2        (Done_ADD2        ),
                .Done_LOAD1       (Done_LOAD1       ),
                .Done_LOAD2       (Done_LOAD2       ),
                .Q_ADD1           (Q_ADD1           ),
                .Q_ADD2           (Q_ADD2           ),
                .Q_LOAD1          (Q_LOAD1          ),
                .Q_LOAD2          (Q_LOAD2          ),
                .Qi_CDB           (Qi_CDB           ),
                .Qi_CDB_data      (Qi_CDB_data      )
              );

  res_station_R ADD1(
                  .Clock            (Clock              ),
                  .Reset            (Reset              ),
                  .Opcode           (Opcode             ),
                  .Busy             (Busy_ADD1          ),
                  .Done             (Done_ADD1          ),
                  .Finished         (Finished_ADD1      ),
                  .Vj               (Vj                 ),
                  .Vk               (Vk                 ),
                  .Vj_reg           (Vj_reg_ADD1 ),
                  .Vk_reg           (Vk_reg_ADD1 ),
                  .Qj               (Qj                 ),
                  .Qk               (Qk                 ),
                  .Qj_reg           (Qj_reg_ADD1 ),
                  .Qk_reg           (Qk_reg_ADD1 ),
                  .R_target         (R_target_ADD1      ),
                  .R_enable         (R_enable_ADD1      ),
                  .Clear_counter    (Clear_counter_ADD1 ),
                  .Enable_VQ        (Enable_VQ_ADD1     ),
                  .Ufop             (Ufop_ADD1          )
                  // .Ready     (Ready_R1  ),
                  // .Result    (Q_ADD1    )
                );

  res_station_R ADD2(
                  .Clock            (Clock              ),
                  .Reset            (Reset              ),
                  .Opcode           (Opcode             ),
                  .Busy             (Busy_ADD2          ),
                  .Done             (Done_ADD2          ),
                  .Finished         (Finished_ADD2      ),
                  .Vj               (Vj                 ),
                  .Vk               (Vk                 ),
                  .Vj_reg           (Vj_reg_ADD2 ),
                  .Vk_reg           (Vk_reg_ADD2 ),
                  .Qj               (Qj                 ),
                  .Qk               (Qk                 ),
                  .Qj_reg           (Qj_reg_ADD2 ),
                  .Qk_reg           (Qk_reg_ADD2 ),
                  .R_target         (R_target_ADD2      ),
                  .R_enable         (R_enable_ADD2      ),
                  .Clear_counter    (Clear_counter_ADD2 ),
                  .Enable_VQ        (Enable_VQ_ADD2     ),
                  .Ufop             (Ufop_ADD2          )
                  // .Ready     (Ready_R1  ),
                  // .Result    (Q_ADD1    )
                );

  // Instancia do modulo seletor de unidade funcional
  seletor_uf seletor_uf_ADD1(
               .Clock         (Clock       ),
               .Reset         (Reset       ),
               .Vj            (Vj_reg_ADD1 ),
               .Vk            (Vk_reg_ADD1 ),
               .Qj            (Qj_reg_ADD1 ),
               .Qk            (Qk_reg_ADD1 ),
               .Qi_CDB        (Qi_CDB      ),
               .Qi_CDB_data   (Qi_CDB_data ),
               .A             (A_sem_valor      ),
               .Op1           (Op1_ADD1           ),
               .Op2           (Op2_ADD1           ),
               .Op3           (Dummy       ),
               .Ready_to_uf   (Ready_to_uf_ADD1 ),
               .Busy          (Busy_ADD1)
             );

  seletor_uf seletor_uf_ADD2(
               .Clock         (Clock       ),
               .Reset         (Reset       ),
               .Vj            (Vj_reg_ADD2 ),
               .Vk            (Vk_reg_ADD2 ),
               .Qj            (Qj_reg_ADD2 ),
               .Qk            (Qk_reg_ADD2 ),
               .Qi_CDB        (Qi_CDB      ),
               .Qi_CDB_data   (Qi_CDB_data ),
               .A             (A_sem_valor      ),
               .Op1           (Op1_ADD2      ),
               .Op2           (Op2_ADD2      ),
               .Op3           (Dummy       ),
               .Ready_to_uf   (Ready_to_uf_ADD2 ),
               .Busy          (Busy_ADD2)
             );

  unidade_funcional_R unidade_funcional_ADD1(
                        .Clock            (Clock                 ),
                        .Clear            (Clear_counter_ADD1    ),
                        .Op1              (Op1_ADD1                ),
                        .Op2              (Op2_ADD1                ),
                        .Ufop             (Ufop_ADD1             ),
                        .Ready_to_uf      (Ready_to_uf_ADD1      ),
                        // .Busy             (Busy_ADD1             ),
                        .Q                (Q_ADD1                ),
                        .Reset            (Reset                 ),
                        .Write_Enable_CDB (Write_Enable_CDB      ),
                        .Done             (Done_ADD1             )
                      );

  unidade_funcional_R unidade_funcional_ADD2(
                        .Clock            (Clock                 ),
                        .Clear            (Clear_counter_ADD2    ),
                        .Op1              (Op1_ADD2              ),
                        .Op2              (Op2_ADD2                ),
                        .Ufop             (Ufop_ADD2             ),
                        .Ready_to_uf      (Ready_to_uf_ADD2      ),
                        // .Busy             (Busy_ADD2             ),
                        .Q                (Q_ADD2                ),
                        .Reset            (Reset                 ),
                        .Write_Enable_CDB (Write_Enable_CDB      ),
                        .Done             (Done_ADD2             )
                      );

  res_station_I LOAD1(
                  .Clock         (Clock                          ),
                  .Reset         (Reset                          ),
                  .Done          (Done_LOAD1                     ),
                  .Finished      (Finished_LOAD1                 ),
                  .Opcode        (Opcode                         ),
                  .R_target      (R_target_LOAD1                 ),
                  .Vj            (Vj                             ),
                  .Vk            (Vk                             ),
                  .Qj            (Qj                             ),
                  .Qk            (Qk                             ),
                  .A             (A                              ),
                  .Enable_VQ     (Enable_VQ_LOAD1                 ),
                  .R_enable      (R_enable_LOAD1                 ),
                  .Busy          (Busy_LOAD1                     ),
                  .Ufop          (Ufop_LOAD1                     ),
                  .Clear_counter (Clear_counter_LOAD1            ),
                  .Vj_reg        (Vj_reg_LOAD1                   ),
                  .Vk_reg        (Vk_reg_LOAD1                   ),
                  .Qj_reg        (Qj_reg_LOAD1                   ),
                  .Qk_reg        (Qk_reg_LOAD1                   ),
                  .A_reg         (A_reg_LOAD1                  )
                );

  seletor_uf seletor_uf_LOAD1(
               .Clock         (Clock             ),
               .Reset         (Reset             ),
               .Vj            (Vj_reg_LOAD1      ),
               .Vk            (Vk_reg_LOAD1      ),
               .Qj            (Qj_reg_LOAD1      ),
               .Qk            (Qk_reg_LOAD1      ),
               .A             (A_reg_LOAD1       ),
               .Qi_CDB        (Qi_CDB            ),
               .Qi_CDB_data   (Qi_CDB_data       ),
               .Op1           (Op1_LOAD1         ),
               .Op2           (Op2_LOAD1         ),
               .Op3           (Op3_LOAD1         ),
               .Ready_to_uf   (Ready_to_uf_LOAD1 ),
               .Busy          (Busy_LOAD1        )
             );

  unidade_funcional_I unidade_funcional_LOAD1(
                        .Clock            (Clock                 ),
                        .Clear            (Clear_counter_LOAD1   ),
                        .Op1              (Op1_LOAD1              ),
                        .Op2              (Op2_LOAD1              ),
                        .Op3              (Op3_LOAD1              ),
                        .Ufop             (Ufop_LOAD1            ),
                        .Ready_to_uf      (Ready_to_uf_LOAD1     ),
                        // .Busy             (Busy_LOAD1            ),
                        .Q                (Q_LOAD1                ),
                        .Reset            (Reset                 ),
                        .Write_Enable_CDB (Write_Enable_CDB_LOAD1      ),
                        .Done             (Done_LOAD1            )
                      );


  always @(posedge Reset)
    begin
      // Ready_R1
    end

endmodule
