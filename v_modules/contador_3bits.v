module contador_3bits(Clear, Clock, Tstep, Reset);

  /*
  Usado pela unidade de controle para saber em que etapa da instrução está.
   
  Ao receber Clear, volta para T0.
   
  Caso contrário, incrementa em cada borda de subida do clock.
  */

  input Clear, Clock, Reset;
  output reg [2:0] Tstep;
  reg Espera1ciclo_d = 0; // armazena o valor anterior de Espera1ciclo
  reg Resetn_d = 1;                   // armazena o valor anterior de Resetn
  reg Run_d = 0;                   // armazena o valor anterior de Run
  always @(posedge Clock)
    begin
      if (Reset) // se Clear for alto e Resetn for baixo, volta para T0
        begin
          Tstep <= 3'b0;
        end
      else if(Clear)
        begin
          Tstep <= 3'b0; // Reseta o contador para T0
        end
      else
        begin
          Tstep <= Tstep + 1; // Incrementa o contador
        end
    end

endmodule
