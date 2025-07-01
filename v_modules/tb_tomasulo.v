`timescale 1ps/1ps

module tb_tomasulo;
  reg Clock;
  reg Reset;
  reg Pop;

  // Instancia do modulo tomasulo
  tomasulo uut (
             .Clock(Clock),
             .Reset(Reset),
             .Pop(Pop)
           );

  always #50 Clock = ~Clock; // Clock com periodo de 10ps

  initial
    begin
      // Teste de funcionalidade
      Clock = 0;
      Reset = 1;
      Pop = 0;
      @(posedge Clock);
      @(posedge Clock);
      Reset = 0;
      Pop = 1;
      // Espera 4 ciclos de clock
      @(posedge Clock);
      @(posedge Clock);
      Pop = 0;
      @(posedge Clock);
      @(posedge Clock);
      // Ativa o despacho de instrução
      $display("[%0t] Ativando despacho", $time);

      // Depurando unidade de despacho

      /*
        Instrucao 1: ADD, R0, R1, R2
        Instrucao 2: SUB, R0, R1, R2
        Instrucao 3: ADD, R0, R1, R2
        Instrucao 4: ADD, R0, R1, R2
        Instrucao 5: ADD, R0, R1, R2
        Instrucao 6: ADD, R0, R1, R2
        Instrucao 7: SUB, R0, R1, R2
      */


      // Finaliza a simulação após um tempo determinado
    end

endmodule
