module unidade_funcional_R(Clock, Clear, Op1, Op2, Ufop, Ready_to_uf, Reset, Q, Busy, Write_Enable_CDB, Done);
  // Talvez crirar um sinal para indicar se comeca ou nao a execucao, quem envia eh a estacao de reserva
  input             Clock; // Sinal de clock
  input             Clear; // Sinal de clear para o contador
  input [15:0]      Op1, Op2;
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
        Write_Enable_CDB <= 1'b0; // Desabilita escrita no CDB
      end
      if (Ready_to_uf)
        begin
          case (Tstep)
            3'd0:
              begin
                Tstep <= Tstep + 1; // Incrementa o contador de etapas
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

                3'b010: // Adicao
                  begin
                    Q <= Op1 + Op2;
                    Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
                    Done <= 1'b1; // Indica que a operação foi concluída
                  end

                3'b011: // Subtracao
                  begin
                    Q <= Op1 - Op2; // Se for subtração, Q recebe A - Op2
                    Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
                    Done <= 1'b1; // Indica que a operação foi concluída
                  end

                3'b110: // SLT
                  begin
                    if (Op1 < Op2)
                      Q <= 16'd1; // Se Op1 for menor que Op2, Q recebe 1
                    else
                      Q <= 16'd0; // Caso contrário, Q recebe 0
                    Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
                    Done <= 1'b1; // Indica que a operação foi concluída
                  end

                3'b111: // CMP
                  begin
                    if (Op1 == Op2)
                      Q <= 16'd1; // Se Op1 for igual a Op2, Q recebe 1
                    else
                      Q <= 16'd0; // Caso contrário, Q recebe 0
                    Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
                  end

                default: // Caso não seja nenhuma das operações definidas
                  begin
                    Q <= 16'b0; // Q recebe 0
                    Write_Enable_CDB <= 1'b0; // Desabilita escrita no CDB
                    Done <= 1'b0; // Indica que a operação não foi concluída
                  end
              endcase
          endcase
        end
    end
endmodule
