module unidade_funcional_R(A, B, Ufop, Ready_to_uf, Q, Busy, Write_Enable_CDB);
  // Talvez crirar um sinal para indicar se comeca ou nao a execucao, quem envia eh a estacao de reserva
  input [15:0] A, B;
  input [2:0] Ufop; // 2 bits para selecionar a operação da ULA
  input Ready_to_uf; // Sinal de pronto para a unidade funcional
  output Busy; // Sinal de ocupado da unidade funcional
  output reg [15:0] Q; // Saída da ULA
  output reg Write_Enable_CDB; // Sinal para habilitar a escrita no CDB
  always @(Ready_to_uf) // Talvez trocar por logica flip flop
    begin
      if (Ready_to_uf)
        begin
          case (Ufop)
            3'b000: //NOP
              begin
                Q <= 0; // Se for adição, Q recebe 0
                Write_Enable_CDB <= 1'b0; // Desabilita escrita no CDB
              end

            3'b001: // Adicao
              begin
                Q <= A + B;
                Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
              end

            3'b010: // SLT
              begin
                if (A < B)
                  Q <= 16'd1; // Se A for menor que B, Q recebe 1
                else
                  Q <= 16'd0; // Caso contrário, Q recebe 0
                Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
              end

            3'b011: // CMP
              begin
                if (A == B)
                  Q <= 16'd1; // Se A for igual a B, Q recebe 1
                else
                  Q <= 16'd0; // Caso contrário, Q recebe 0
                Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
              end

            3'b100: // Soma 4
              begin
                Q <= B + 16'd4; // Adição de 4
                Write_Enable_CDB <= 1'b1; // Habilita escrita no CDB
              end

            3'b101: // Subtrai 4
              begin
                Write_Enable_CDB <= 1'b0; // Desabilita escrita no CDB
                Q <= B - 16'd4; // Subtração de 4
              end
          endcase
        end
    end
endmodule
