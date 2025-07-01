module unidade_funcional_R(A, B, Ufop, Ready_to_uf, Reset, Q, Busy, Write_Enable_CDB, Done);
  // Talvez crirar um sinal para indicar se comeca ou nao a execucao, quem envia eh a estacao de reserva
  input [15:0] A, B;
  input [2:0] Ufop; // 2 bits para selecionar a operação da ULA
  input Ready_to_uf; // Sinal de pronto para a unidade funcional
  input Reset; // Sinal de reset
  output Busy; // Sinal de ocupado da unidade funcional
  output reg [15:0] Q; // Saída da ULA
  output reg Write_Enable_CDB; // Sinal para habilitar a escrita no CDB
  output reg Done; // Sinal de finalização da operação
  always @(Ready_to_uf or Reset) // Talvez trocar por logica flip flop
    begin
      if (Reset)
      begin
        Q <= 16'b0; // Reseta o valor de Q
        Write_Enable_CDB <= 1'b0; // Desabilita escrita no CDB
        Done <= 1'b0; // Indica que a operação não foi concluída
      end
      if (Ready_to_uf)
        begin
          case (Ufop)
            3'b000: //NOP
              begin
                Q <= 0; // Se for adição, Q recebe 0
                Done <= 1'b0; // Indica que a operação não foi concluída
              end

            3'b010: // Adicao
              begin
                Q <= A + B;
                Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
                Done <= 1'b1; // Indica que a operação foi concluída
              end

            3'b011: // Subtracao
              begin
                Q <= A - B; // Se for subtração, Q recebe A - B
                Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
                Done <= 1'b1; // Indica que a operação foi concluída
              end

            3'b110: // SLT
              begin
                if (A < B)
                  Q <= 16'd1; // Se A for menor que B, Q recebe 1
                else
                  Q <= 16'd0; // Caso contrário, Q recebe 0
                Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
                Done <= 1'b1; // Indica que a operação foi concluída
              end

            3'b111: // CMP
              begin
                if (A == B)
                  Q <= 16'd1; // Se A for igual a B, Q recebe 1
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
        end
    end
endmodule
