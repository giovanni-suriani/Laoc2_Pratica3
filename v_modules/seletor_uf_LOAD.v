module seletor_uf_LOAD (
    Clock,
    Reset,
    Vj,
    Vk,
    Qj,
    Qk,
    Rs_Qi,
    Rs_Qi_Data,
    A,
    Qi_CDB,
    Qi_CDB_data,
    Ufop,
    Op0,
    Op1,
    Op2,
    Busy,
    Ready_to_uf);
  parameter Vj_Vk_sem_valor = 16'b1111_1111_1111_0000, // Valor padrao para algo sem valor (como xxx nao existe na fpga)
            Qj_Qk_sem_valor = 3'b000, // Valor padrao para estacao de reserva sem valor
            Qi_CDB_data_sem_valor = 16'b1111_1111_1111_0000,
            A_sem_valor     = 7'b1111000;

  input Clock;
  input Reset;
  input [15:0]     Vj;
  input [15:0]     Vk;
  input [6:0]      A;
  input [2:0]      Qj;
  input [2:0]      Qk;
  input [2:0]      Qi_CDB;
  input [15:0]     Qi_CDB_data;
  // input [1:0]      Rs_Qi [3:0];
  // input [15:0]     Rs_Qi_data [3:0];
  input            Busy; // Sinal de ocupado da unidade funcional
  input [2:0]      Ufop;
  output reg[15:0] Op0;
  output reg[15:0] Op1;
  output reg[15:0] Op2;
  output reg Ready_to_uf; // Talvez fazer um sinal one hot aqui

  reg clear; // Sinal para limpar os registradores Op1 e Op2

  always @(posedge Clock or posedge Reset)
    if (Reset)
      begin
        Op0             <= Vj_Vk_sem_valor;
        Op1             <= Vj_Vk_sem_valor;
        Op2             <= Vj_Vk_sem_valor;
        Ready_to_uf   <= 1'b0;
      end
    else
      begin
        if (Busy == 0)
          begin
            Op0 = Vj_Vk_sem_valor; // Reseta Op1 e Op2 para o valor padrao
            Op1 = Vj_Vk_sem_valor; // Reseta Op1 e Op2 para o valor padrao
            Op2 = Vj_Vk_sem_valor;
            Ready_to_uf <= 1'b0; // Desativa o sinal de pronto para a unidade funcional
          end
        if (Busy == 1)
          begin
            $display("[%0t] seletor_uf: Vj: %h, Vk: %h, Qj: %h, Qk: %h, Qi_CDB: %h, Qi_CDB_data: %h",
                     $time, Vj, Vk, Qj, Qk, Qi_CDB, Qi_CDB_data);
            if (Op1 == Vj_Vk_sem_valor)
              begin
                // Check primeiro de Vj
                if (Vj == Vj_Vk_sem_valor)
                  begin
                    if (Qj == Qi_CDB)
                      begin
                        Op1 = Qi_CDB_data;
                      end
                  end
                else if (Vj != Vj_Vk_sem_valor)
                  begin
                    Op1 = Vj;
                  end
              end
            if (Op2 == Vj_Vk_sem_valor)
              begin
                // Check de A depois de Vk
                if (A != A_sem_valor)
                  begin
                    Op2 = A; // Se A for sem valor, atribui o valor padrao
                  end
                else
                  if (Vk == Vj_Vk_sem_valor)
                    begin
                      if (Qj == Qi_CDB)
                        begin
                          Op2 = Qi_CDB_data;
                        end
                    end
                  else if (Vj != Vj_Vk_sem_valor)
                    begin
                      Op2 = Vk;
                    end
              end

            // Check se Op1 e Op2 estao prontos
            if (Ufop == 3'd5) // LOAD
              begin
                Op0 = Vj; // Op0 recebe o valor de Vj para LOAD


                if (Op1 != Vj_Vk_sem_valor && Op2 != Vj_Vk_sem_valor)
                  begin
                    Ready_to_uf <= 1'b1; // Pronto para a unidade funcional
                  end
              end
          end
      end
endmodule
