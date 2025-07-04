module res_station_R (
    Clock,
    Reset,
    Opcode,
    Busy,
    Done,                // Sinal de finalizacao da operacao da unidade funcional
    Finished,            // Sinal de finalizacao da operacao da instrucao
    Vj, Vk,              // valores dos operandos
    Qj, Qk,              // estacoes de reserva dependentes
    Vj_reg, Vk_reg,
    Qj_reg, Qk_reg,
    Ufop, // qual operacao esta sendo executada
    R_target, // Registrador de destino
    R_enable, // Sinal de habilitacao da escrita no banco de registradores
    Clear_counter, // Sinal de clear para resetar o contador da unidade funcional
    Enable_VQ // habilita a sobrescrita do Vj e Vk, Qj e Qk
    // Ready, // pode executar?
    // Result,
  );

  // Cada Estacao de reserva possui uma unidade funcional associada

  input                 Clock, Reset;
  input                 Done;            // Sinal de finalizacao da operacao da unidade funcional
  input                 Finished;        // Sinal de finalizacao da operacao da instrucao
  input [2:0]           Opcode;
  input [2:0]           R_target;        // Registrador de destino
  input [15:0]          Vj, Vk;
  input [2:0]           Qj, Qk;
  input                 Enable_VQ;       // Habilita a sobrescrita do Vj e Vk, Qj e Qk
  output reg            R_enable;        // Sinal de habilitacao da escrita no banco
  output reg            Busy;
  output reg [2:0]      Ufop;            // Qual operacao esta sendo executada
  output reg [2:0]      Clear_counter;   // Sinal de clear para resetar o contador da unidade funcional
  // output reg Ready;
  // output reg [15:0] Result;

  output reg [15:0]      Vj_reg, Vk_reg;  // Registradores para os operandos
  output reg [2:0]       Qj_reg, Qk_reg;  // Registradores

  // assign Ufop = Opcode;   // Passa o opcode diretamente para a saida Ufop


  parameter Vj_Vk_sem_valor = 16'b1111_1111_1111_0000, // Valor padrao para algo sem valor (como xxx nao existe na fpga)
            Qj_Qk_sem_valor = 3'b000, // Valor padrao para estacao de reserva sem valor
            A_sem_valor     = 7'b1111000; // Valor padrao para A (imediato) sem valor

  // Talvez Busy seja um reg

  always @(Reset or Enable_VQ or Done or Finished)
    begin
      if (Reset)
        begin
          Busy   <= 1'b0; // Inicialmente nao esta ocupado
          R_enable <= 1'b0; // Desabilita o registrador de destino para escrita
          Clear_counter <= 1'b1; // Ativa o sinal de clear para resetar o contador da unidade funcional
          Vj_reg <= Vj_Vk_sem_valor; // Valor padrao para vj
          Vk_reg <= Vj_Vk_sem_valor; // Valor padrao para vk
          Qj_reg <= Qj_Qk_sem_valor; // Estacao de reserva padrao para qj
          Qk_reg <= Qj_Qk_sem_valor; // Est
          Ufop   <= 3'b000; // Inicializa o opcode como NOP
          // Ready  <= 1'b1;   // Inicialmente esta pronto
          // Result <= 16'b0; // Resultado padrao
        end
      else
        begin
          // Tenho que passar os operandos para a unidade funcional
          if (Finished)
            begin
              Busy     <= 1'b0; // Desativa a unidade funcional
              R_enable <= 1'b0; // Habilita o registrador de destino para escrita
              // Ready <= 1'b0; // Desativa a prontidao, pois nao esta executando
              // Result <= Vj_reg + Vk_reg; // Resultado da operacao
            end
          else if (Done)
            begin
              R_enable     <= 1'b1; // Habilita o registrador de destino para escrita
              Clear_counter <= 1'b1; // Ativa o sinal de clear para resetar o contador da unidade funcional
            end
          if (Enable_VQ)
            begin
              Vj_reg        <= Vj;  // Sobrescreve o valor de Vj
              Vk_reg        <= Vk;  // Sobrescreve o valor de Vk
              Qj_reg        <= Qj;  // Sobrescreve o valor de Qj
              Qk_reg        <= Qk;  // Sobrescreve o valor de Qk
              Busy          <= 1'b1; // Ativa a unidade funcional
              Clear_counter <= 1'b0; // Desativa o sinal de clear para resetar o contador da unidade funcional
              Ufop          <= Opcode; // Atualiza o opcode da unidade funcional
              // R_enable <= 1'b0; // Desabilita o registrador de destino para escrita
              // Ready <= 1'b1; // Ativa a prontidao, pois esta executando
            end
        end
    end





  // aqui voce decide se tem operandos prontos (Qj e Qk == 0)
  // e faz a operacao se puder
endmodule
