module seletor_uf (
    Clock,
    Reset,
    Vj,
    Vk,
    Qj,
    Qk,
    Qi_CDB,
    Qi_CDB_data,
    A,
    B,
    Busy,
    Ready_to_uf);
  parameter Vj_Vk_sem_valor = 16'b1111_1111_1111_0000, // Valor padrao para algo sem valor (como xxx nao existe na fpga)
            Qj_Qk_sem_valor = 3'b000, // Valor padrao para estacao de reserva sem valor
            Qi_CDB_data_sem_valor = 16'b1111_1111_1111_0000;
  input Clock;
  input Reset;
  input [15:0] Vj;
  input [15:0] Vk;
  input [15:0] Qj;
  input [2:0]  Qk;
  input [2:0]  Qi_CDB;
  input [15:0] Qi_CDB_data;
  input        Busy; // Sinal de ocupado da unidade funcional
  output reg[15:0] A;
  output reg[15:0] B;
  output reg Ready_to_uf; // Talvez fazer um sinal one hot aqui

  reg clear; // Sinal para limpar os registradores A e B

  always @(posedge Clock or posedge Reset)
    if (Reset)
      begin
        A             <= Vj_Vk_sem_valor;
        B             <= Vj_Vk_sem_valor;
        Ready_to_uf   <= 1'b0;
      end
    else
      begin
        if (Busy == 0)
          begin
            A = Vj_Vk_sem_valor; // Reseta A e B para o valor padrao
            B = Vj_Vk_sem_valor;
            Ready_to_uf <= 1'b0; // Desativa o sinal de pronto para a unidade funcional
          end
        if (Busy == 1)
          begin
            if (A == Vj_Vk_sem_valor)
              begin
                // Check primeiro de Vj
                if (Vj == Vj_Vk_sem_valor)
                  begin
                    if (Qj == Qi_CDB)
                      begin
                        A = Qi_CDB_data;
                      end
                  end
                else if (Vj != Vj_Vk_sem_valor)
                  begin
                    A = Vj;
                  end
              end
            if (B == Vj_Vk_sem_valor)
              begin
                // Check de Vk
                if (Vk == Vj_Vk_sem_valor)
                  begin
                    if (Qj == Qi_CDB)
                      begin
                        B = Qi_CDB_data;
                      end
                  end
                else if (Vj != Vj_Vk_sem_valor)
                  begin
                    B = Vk;
                  end
              end

            // Check se A e B estao prontos
            if (A != Vj_Vk_sem_valor && B != Vj_Vk_sem_valor)
              begin
                Ready_to_uf <= 1'b1; // Pronto para a unidade funcional
              end
          end
      end
endmodule
