module res_station_R (
    Clock,
    Reset,
    Opcode,
    Busy,
    Vj, Vk,              // valores dos operandos
    Qj, Qk,               // estacoes de reserva dependentes
    Ready, // pode executar?
    Result,
    Ufop, // qual operacao esta sendo executada
    Enable_VQ // habilita a sobrescrita do Vj e Vk, Qj e Qk
  );

  // Cada Estacao de reserva possui uma unidade funcional associada

  input Clock, Reset;
  input [2:0] Opcode;
  output reg Busy;
  input [15:0] Vj, Vk;
  input [2:0] Qj, Qk;
  input Enable_VQ;        // Habilita a sobrescrita do Vj e Vk, Qj e Qk
  output [2:0] Ufop;      // Qual operacao esta sendo executada
  output reg Ready;
  output reg [15:0] Result;

  reg [15:0] Vj_reg, Vk_reg; // Registradores para os operandos
  reg [2:0] Qj_reg, Qk_reg;   // Registradores

  assign Ufop = Opcode;   // Passa o opcode diretamente para a saida Ufop

  // Talvez Busy seja um reg

  always @(Reset or Enable_VQ)
    begin
      if (Reset)
        begin
          Ready  <= 1'b1;   // Inicialmente esta pronto
          Result <= 16'b0; // Resultado padrao
        end
      else
        begin
          // Tenho que passar os operandos para a unidade funcional
          if (Enable_VQ)
            begin
              Vj_reg <= Vj;  // Sobrescreve o valor de Vj
              Vk_reg <= Vk;  // Sobrescreve o valor de Vk
              Qj_reg <= Qj;  // Sobrescreve o valor de Qj
              Qk_reg <= Qk;  // Sobrescreve o valor de Qk
              Busy  <= 1'b1; // Ativa a unidade funcional
              Ready <= 1'b1; // Ativa a prontidao, pois esta executando
            end
        end
    end





  // aqui voce decide se tem operandos prontos (Qj e Qk == 0)
  // e faz a operacao se puder
endmodule
