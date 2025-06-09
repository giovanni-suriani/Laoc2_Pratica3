module registrador_SP(R, Rin, Clock, Resetn, Q);
  // Modulo que representa um registrador de 16 bits que quando habilitado
  // armazena o valor Rin na entrada R. O valor armazenado é lido na

  // inputs
  input [15:0] R;
  input Rin, Clock, Resetn;

  // outputs
  output [15:0] Q; // valor armazenado

  reg [15:0] Q;
  always @(negedge Clock)
    if (Rin && !Resetn) // se Rin for alto e Resetn for baixo, armazena R
      Q <= R;
    else if (Resetn)
      Q <= 16'd64; // Reseta o registrador Q para o tamanho maximo de memoria
endmodule
