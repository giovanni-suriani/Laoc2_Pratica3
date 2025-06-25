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
    B);
  parameter Vj_Vk_sem_valor = 16'b1111_1111_1111_0000, // Valor padrao para algo sem valor (como xxx nao existe na fpga)
            Qj_Qk_sem_valor = 3'b000, // Valor padrao para estacao de reserva sem valor
            Qi_CDB_data_sem_valor = 16'b1111_1111_1111_0000;
  input Clock;
  input Reset;
  input Vj;
  input Vk;
  input Qj;
  input Qk;
  input Qi_CDB;
  input Qi_CDB_data;
  output reg[15:0] A;
  output reg[15:0] B;
  output Ready_to_uf;

  always @(posedge Clock or posedge Reset)
    if (Reset)
      begin
        A <= 16'b0;
        B <= 16'b0;
      end
    else
      begin
        // Check primeiro de Vj
        if (Vj == Vj_Vk_sem_valor)
          begin
            if (Qj == Qi_CDB)
              begin
                A <= Qi_CDB_data;
              end
          end
        else if (Vj != Vj_Vk_sem_valor) 
          begin
            A <= Vj;
          end

        // Check de Vk
        if (Vk == Vj_Vk_sem_valor)
          begin
            if (Qj == Qi_CDB)
              begin
                B <= Qi_CDB_data;
              end
          end
        else if (Vj != Vj_Vk_sem_valor) 
          begin
            B <= Vk;
          end
      end

endmodule
