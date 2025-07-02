module unidade_funcional_R(Clock, Clear, A, B, Ufop, Ready_to_uf, Reset, Q, Busy, Write_Enable_CDB, Done);
  // Talvez crirar um sinal para indicar se comeca ou nao a execucao, quem envia eh a estacao de reserva
  input             Clock; // Sinal de clock
  input             Clear; // Sinal de clear para o contador
  input [15:0]      A, B;
  input [2:0]       Ufop; // 2 bits para selecionar a operação da ULA
  input             Ready_to_uf; // Sinal de pronto para a unidade funcional
  input             Reset; // Sinal de reset
  output            Busy; // Sinal de ocupado da unidade funcional
  output reg [15:0] Q; // Saída da ULA
  output reg        Write_Enable_CDB; // Sinal para habilitar a escrita no CDB
  output reg        Done; // Sinal de finalização da operação
  // reg conta_ciclos; // Contador de ciclos para a operação
  // wire [2:0] Tstep; // Sinal de clock do contador

  /*   contador_3bits u_contador_3bits(
                     .Clear  (Clear  ),
                     .Clock  (Clock  ),
                     .Reset  (Reset  ),
                     .Tstep  (Tstep  )
                   ); */
  reg Tstep; // Registrador para armazenar o valor do contador

  // Sinais para memoria de dados
  reg [3:0] Address; // Registrador para armazenar o endereço
  reg         wren;
  reg  [15:0] Din;
  wire [15:0] Mem_data;
  memoria_dados u_memoria_dados(
                  .Reset   (Reset          ),
                  .Clock   (Clock          ),
                  .wren    (wren           ),
                  .Address (Address        ),
                  .Din     (Din            ),
                  .Q       (Mem_data       )
                );



  always @(posedge Clock or posedge Reset) // Talvez trocar por logica flip flop
    begin
      if (Reset)
        begin
          Q                <= 16'b0; // Reseta o valor de Q
          Write_Enable_CDB <= 1'b0; // Desabilita escrita no CDB
          Done             <= 1'b0; // Indica que a operação não foi concluída
          Tstep            <= 1'b0; // Reseta o contador de etapas
          // conta_ciclos <= 1'b0; // Reseta o contador de ciclos
        end
      if (Clear)
        begin
          Done <= 1'b0; // Reseta o sinal de Done
          Tstep <= 1'b0; // Reseta o contador de etapas
        end
      if (Ready_to_uf)
        begin
          case (Tstep)
            3'd0:
              begin
                  Tstep   <= Tstep + 1; // Incrementa o contador de etapas
                  Address <= A + B;
                case (Ufop)
                  3'b000: //NOP
                    begin
                      Q <= 0; // Se for adição, Q recebe 0
                      Done <= 1'b0; // Indica que a operação não foi concluída
                    end

                  3'd4: // Load
                    begin
                      
                    end

                  3'd5: // Store
                    begin
                      Din              <= A + B;    // Dado a ser escrito na memória
                      wren             <= 1'b1; // Habilita escrita na memória
                      Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
                    end
                endcase
              end
            // 3'd1:
            //   begin
            //   end
            3'd1:
              case (Ufop)
                3'b000: //NOP
                  begin
                    Q <= 0; // Se for adição, Q recebe 0
                    Done <= 1'b0; // Indica que a operação não foi concluída
                  end

                3'd4: // Load
                  begin
                    Q <= Mem_data;
                    Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
                    Done <= 1'b1; // Indica que a operação foi concluída
                  end

                3'd5: // Store
                  begin
                    // Din <= Q; // Dado a ser escrito na memória
                    // wren <= 1'b1; // Habilita escrita na memória
                    // Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
                    Done <= 1'b1; // Indica que a operação foi concluída
                  end

              endcase
          endcase
        end
    end
endmodule
