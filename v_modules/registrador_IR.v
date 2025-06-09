module registrador_IR(R, Rin, Clock, Resetn, Q);
  // Modulo que representa um registrador de 16 bits que quando habilitado
  // armazena o valor Rin na entrada R. O valor armazenado é lido na

  // inputs
  input [9:0] R; // entrada de dados
  input Rin, Clock, Resetn; // Rin habilita escrita, Clock é o clock do processador, Resetn é o reset

  // outputs
  output reg [9:0] Q; // valor armazenado

  // reg [8:0] Q;
  always @(negedge Clock)
    begin
      if (Rin)
        begin
          // $display("[%0t] quero ve-la sorrir, Rin = %0d, R = %0d",$time, Rin, R);
          Q <= R; // armazena o valor de R no registrador Q
        end
      else if (Resetn)
        Q <= 9'd0; // Reseta o registrador Q para 0
    end

endmodule
