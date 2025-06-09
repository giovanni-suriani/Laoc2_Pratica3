module registrador_PC(R, IncrPc, Rin, Clock, Resetn, Q);
  // Modulo que representa um registrador de 16 bits que quando habilitado
  // armazena o valor Rin na entrada R. O valor armazenado é lido na

  // inputs
  input [15:0] R;
  input Rin, Clock, Resetn, IncrPc;

  // outputs
  output [15:0] Q; // valor armazenado

  reg [15:0] Q;
  // always @(negedge Clock or  Resetn or posedge IncrPc)
  always @(negedge Clock)
    begin
      if (Resetn)
        Q <= 16'd0;                         // Reset síncrono ativo em 1
      else if (Rin)
        Q <= R;                             // Load direto se Rin = 1
      else if (IncrPc)
        Q <= Q + 1;                         // Incrementa PC se habilitado
    end
endmodule
