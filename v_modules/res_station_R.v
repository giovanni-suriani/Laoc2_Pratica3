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

  input Clock, Reset;
  input [2:0] Opcode;
  input Busy;
  input [15:0] Vj, Vk;
  input [2:0] Qj, Qk;
  input Enable_VQ; // Habilita a sobrescrita do Vj e Vk, Qj e Qk
  output [2:0] Ufop; // Qual operacao esta sendo executada
  output reg Ready;
  output reg [15:0] Result;

  assign Ufop = Opcode; // Passa o opcode diretamente para a saida Ufop

  always @(posedge Clock or posedge Reset)
    if (Reset)
      begin
        Ready <= 1'b1;   // Inicialmente esta pronto
        Result <= 16'b0; // Resultado padrao
      end


  // aqui voce decide se tem operandos prontos (Qj e Qk == 0)
  // e faz a operacao se puder
endmodule
