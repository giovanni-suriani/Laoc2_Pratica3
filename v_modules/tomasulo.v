module tomasulo(
        input Clock,
        input Reset,
        input Pop);

    /* Para despacho duplo */
    parameter  RES_STATION_ADD1 = 2'b00, // Estacao de reserva 1
               RES_STATION_ADD2 = 2'b01; // Estacao de reserva 2

    parameter sem_valor = 16'b1111_1111_1111_0000; // Valor padrao para algo sem valor (como xxx nao existe na fpga)

    // Instanciação do módulo registrador
    reg [2:0]  ADD1, ADD2, ADD3; // escolher de qual das estações de reserva o resultado será lido, para determinado registrador
    reg        Qi_CDB;
    reg [15:0] CDB;
    reg        Rin;
    wire [15:0] R1out, R2out, R3Out; // Saidas dos registradores

    // Instancia do modulo fila de instrucoes
    wire [15:0] Instrucao_Despachada; // Saida da fila de instrucoes
    wire [3:0]  Op;                   // Operacao da instrucao despachada
    wire [15:0] Rj;                   // Valor do primeiro operando (Estaticos)
    wire [15:0] Rk;                   // Valor do segundo operando  (Estaticos)

    assign Op = Instrucao_Despachada[15:12]; // Extrai a operacao da instrucao despachada
    assign Rj = Instrucao_Despachada[11:8];  // Extrai o primeiro operando da instrucao despachada
    assign Rk = Instrucao_Despachada[7:4];   // Extrai o segundo operando da instrucao despachada

    // Instancia do modulo res_station_R, por enquanto apenas DUAS estacoes
    wire [15:0] Vj_R1, Vj_R2;                       // Valor do primeiro operando (Variaveis)
    wire [15:0] Vk_R1, Vk_R2;                       // Valor do segundo operando (Variaveis)
    wire [15:0] Q_ADD1, Q_ADD2;                       // Valor do segundo operando (Variaveis)
    // wire [2:0]  Qj1, Qj2;                        // Estacao de reserva do primeiro operando
    // wire [2:0]  Qk1, Qk2;                        // Estacao de reserva do segundo operando
    wire  Ready_R1, Ready_R2;                       // Sinal de pronto para executar a operacao
    wire  Busy_R1, Busy_R2;                        // Sinal de ocupado da estacao de reserva

    // Sinais inuteis
    wire Full;                       // Sinal de FIFO cheia
    wire Empty;                      // Sinal de FIFO vazia

    registrador R1 (
                    .Qi     (QiR1), // if QiR1 == Qi_CDB, então armazena CDB no registrador
                    .Qi_CDB (Qi_CDB),
                    .CDB    (CDB),
                    .Rin    (Rin),
                    .Clock  (Clock),
                    .Reset  (Reset),
                    .Q      (R1out)
                );

    registrador R2 (
                    .Qi     (QiR2),
                    .Qi_CDB (Qi_CDB),
                    .CDB    (CDB),
                    .Rin    (Rin),
                    .Clock  (Clock),
                    .Reset  (Reset),
                    .Q      (R2out)
                );

    registrador R3 (
                    .Qi     (QiR3),
                    .Qi_CDB (Qi_CDB),
                    .CDB    (CDB),
                    .Rin    (Rin),
                    .Clock  (Clock),
                    .Reset  (Reset),
                    .Q      (R3Out)
                );

    fila_de_instrucoes u_fila_de_instrucoes(
                           .Clock                (Clock                ),
                           .Reset                (Reset                ),
                           .Pop                  (Pop                  ),
                           .Instrucao_Despachada (Instrucao_Despachada ),
                           .Full                 (Full                 ),
                           .Empty                (Empty                )
                       );

    res_station_R Estacao_De_Reserva_R_1(
                      .Clock  (Clock     ),
                      .Reset  (Reset     ),
                      .Op     (Op        ),
                      .Busy   (Busy_R1   ),
                      .Vj     (Vj_R1     ),
                      .Vk     (Vk_R1     ),
                      .Qj     (Qi_CDB    ),
                      .Qk     (Qi_CDB    ),
                      .Ready  (Ready_R1  ),
                      .Result (Q_ADD1    )
                  );

    res_station_R Estacao_De_Reserva_R_2(
                      .Clock  (Clock     ),
                      .Reset  (Reset     ),
                      .Op     (Op        ),
                      .Busy   (Busy_R2   ),
                      .Vj     (Vj_R2     ),
                      .Vk     (Vk_R2     ),
                      .Qj     (Qi_CDB    ),
                      .Qk     (Qi_CDB    ),
                      .Ready  (Ready_R2  ),
                      .Result (Q_ADD2    )
                  );



endmodule
