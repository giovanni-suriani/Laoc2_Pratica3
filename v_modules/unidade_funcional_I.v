module unidade_funcional_I(Clock, Clear, Op1, Op2, Op3, Ufop, Ready_to_uf, Reset, Q,
                             //  Busy,
                             Write_Enable_CDB, Done);
  // Talvez crirar um sinal para indicar se comeca ou nao a execucao, quem envia eh a estacao de reserva
  input             Clock; // Sinal de clock
  input             Clear; // Sinal de clear para o contador
  input [15:0]      Op1, Op2, Op3;
  input [2:0]       Ufop; // 2 bits para selecionar a operação da ULA
  input             Ready_to_uf; // Sinal de pronto para a unidade funcional
  input             Reset; // Sinal de reset
  // output            Busy; // Sinal de ocupado da unidade funcional
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
  reg [1:0] Tstep; // Registrador para armazenar o valor do contador

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



  always @(posedge Clock or posedge Reset ) // Talvez trocar por logica flip flop
    begin
      if (Reset)
        begin
          Q                <= 16'b0; // Reseta o valor de Q
          Write_Enable_CDB <= 1'b0; // Desabilita escrita no CDB
          Done             <= 1'b0; // Indica que a operação não foi concluída
          Tstep            <= 1'b0; // Reseta o contador de etapas
          wren             <= 1'b0; // Desabilita escrita na memória
          Address          <= 4'b0; // Reseta o endereço da memória
          Din              <= 16'b0; // Reseta o dado a ser escrito na memória
          // conta_ciclos <= 1'b0; // Reseta o contador de ciclos
        end
      if (Ready_to_uf)
        begin
          case (Tstep)
            3'd0:
              begin
                // $display("[%0t] uf tipo i",$time);
                Tstep   <= Tstep + 1; // Incrementa o contador de etapas
                Address <= Op1 + Op2;
                case (Ufop)
                  3'b000: //NOP
                    begin
                      Q <= 0; // Se for adição, Q recebe 0
                      Done <= 1'b0; // Indica que a operação não foi concluída
                    end

                  3'd4: // Load
                    begin
                      Address <= Op1 + Op2; // Endereço da memória a ser lido
                    end

                  3'd5: // Store
                    begin
                      $display("[%0t]Ciclo 1 uf tipo i: Store, Address: %h, Op1: %h, Op2: %h, Op3: %h", $time, Address, Op1, Op2, Op3);
                      Address          <= Op1 + Op2; // Endereço da memória a ser escrito
                      Din              <= Op3;    // Dado a ser escrito na memória
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
                    $display("[%0t]Ciclo 2 uf tipo i: LOAD, Address: %h, Op1: %h, Op2: %h, Op3: %h", $time, Address, Op1, Op2, Op3);
                    // Q <= Mem_data;
                    // Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
                    // Done <= 1'b1; // Indica que a operação foi concluída
                    Tstep <= Tstep + 1; // Incrementa o contador de etapas
                  end

                3'd5: // Store
                  begin
                    // Din <= Q; // Dado a ser escrito na memória
                    // wren <= 1'b1; // Habilita escrita na memória
                    // Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
                    $display("[%0t] Ciclo 2 uf tipo i: Store, Address: %d, Op1: %d, Op2: %d, Op3: %d", $time, Address, Op1, Op2, Op3);
                    Done <= 1'b1; // Indica que a operação foi concluída
                  end
              endcase
            3'd2:
              case (Ufop)
                3'b000: //NOP
                  begin
                    Q <= 0; // Se for adição, Q recebe 0
                    Done <= 1'b0; // Indica que a operação não foi concluída
                  end

                3'd4: // Load
                  begin
                    $display("[%0t]Ciclo 3 uf tipo i: LOAD, Address: %h, Op1: %h, Op2: %h, Op3: %h", $time, Address, Op1, Op2, Op3);
                    Q <= Mem_data;
                    Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
                    Done <= 1'b1; // Indica que a operação foi concluída
                  end
              endcase


          endcase
        end
      if (Clear)
        begin
          Done  <= 1'b0; // Reseta o sinal de Done
          Tstep <= 1'b0; // Reseta o contador de etapas
          wren  <= 1'b0; // Desabilita escrita na memória
          Write_Enable_CDB <= 1'b0; // Desabilita escrita no CDB
        end

    end
endmodule
