`timescale 1ps/1ps

module tb_tomasulo;
  reg Clock;
  reg Reset;
  reg Pop;

  // Instancia do modulo tomasulo
  tomasulo u_tomasulo(
    .Clock(Clock),
    .Reset(Reset),
    .Pop(Pop)
  );

  always #50 Clock = ~Clock; // Clock com periodo de 10ps

  initial begin
    // Teste de funcionalidade
    Clock = 0;
    Reset = 1;
    #100 Pop = 0; // Desativa o pop depois de 2 ciclos

    // Finaliza a simulação após um tempo determinado
    #200 $finish;
  end

endmodule