module res_station_R (
    Clock,
    Reset,
    Opcode,
    Busy,
    Done,
    Vj, Vk,              // valores dos operandos
    Qj, Qk,               // estacoes de reserva dependentes
    Ufop, // qual operacao esta sendo executada
    R_target, // Registrador de destino
    R_enable, // Sinal de habilitacao da escrita no banco de registradores
    Enable_VQ // habilita a sobrescrita do Vj e Vk, Qj e Qk
    // Ready, // pode executar?
    // Result,
  );

  // Cada Estacao de reserva possui uma unidade funcional associada

  input Clock, Reset;
  input Done; // Sinal de finalizacao da operacao da unidade funcional
  input [2:0] Opcode;
  input [2:0] R_target; // Registrador de destino
  input [15:0] Vj, Vk;
  input [2:0] Qj, Qk;
  input Enable_VQ;        // Habilita a sobrescrita do Vj e Vk, Qj e Qk
  output reg R_enable; // Sinal de habilitacao da escrita no banco
  output reg Busy;
  output [2:0] Ufop;      // Qual operacao esta sendo executada
  // output reg Ready;
  // output reg [15:0] Result;

  reg [15:0] Vj_reg, Vk_reg; // Registradores para os operandos
  reg [2:0] Qj_reg, Qk_reg;   // Registradores

  assign Ufop = Opcode;   // Passa o opcode diretamente para a saida Ufop

  // Talvez Busy seja um reg

  always @(Reset or Enable_VQ or Done)
    begin
      if (Reset)
        begin
          Busy   <= 1'b0; // Inicialmente nao esta ocupado
          R_enable <= 1'b0; // Desabilita o registrador de destino para escrita
          // Ready  <= 1'b1;   // Inicialmente esta pronto
          // Result <= 16'b0; // Resultado padrao
        end
      else
        begin
          // Tenho que passar os operandos para a unidade funcional
          if (Done)
            begin
              Busy     <= 1'b0; // Desativa a unidade funcional
              // Ready <= 1'b0; // Desativa a prontidao, pois nao esta executando
              // Result <= Vj_reg + Vk_reg; // Resultado da operacao
              R_enable <= 1'b1; // Habilita o registrador de destino para escrita
            end
          else if (Enable_VQ)
            begin
              Vj_reg <= Vj;  // Sobrescreve o valor de Vj
              Vk_reg <= Vk;  // Sobrescreve o valor de Vk
              Qj_reg <= Qj;  // Sobrescreve o valor de Qj
              Qk_reg <= Qk;  // Sobrescreve o valor de Qk
              Busy  <= 1'b1; // Ativa a unidade funcional
              // Ready <= 1'b1; // Ativa a prontidao, pois esta executando
            end
        end
    end





  // aqui voce decide se tem operandos prontos (Qj e Qk == 0)
  // e faz a operacao se puder
endmodule
