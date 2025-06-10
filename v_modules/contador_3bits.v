module contador_3bits(Clear, Clock, Tstep, Run, Resetn);

  /*
  Usado pela unidade de controle para saber em que etapa da instrução está.
   
  Ao receber Clear, volta para T0.
   
  Caso contrário, incrementa em cada borda de subida do clock.
  */

  input Clear, Clock, Run, Resetn;
  output reg [2:0] Tstep;
  reg Espera1ciclo_d = 0; // armazena o valor anterior de Espera1ciclo
  reg Resetn_d = 1;                   // armazena o valor anterior de Resetn
  reg Run_d = 0;                   // armazena o valor anterior de Run
  always @(posedge Clock)
    if (Clear && !Resetn) // se Clear for alto e Resetn for baixo, volta para T0
      begin
        Tstep <= 2'b0;
        Espera1ciclo_d <= 0; // atualiza Espera1ciclo_d para o próximo ciclo
      end
  /* else if (Run && !Run_d) // se Run for alto e Run_d for baixo, incrementa
    begin
      Tstep <= 2'b0;
      Run_d <= Run; // atualiza Run_d para o próximo ciclo
    end */
    /* else if (Espera1ciclo && !Espera1ciclo_d) // se Espera1ciclo for alto e Espera1ciclo_d for baixo, mantém Tstep
      begin
        Tstep <= Tstep;
        Espera1ciclo_d <= 1; // atualiza Espera1ciclo_d para o próximo ciclo
        $display("[%0t] linha 20 contador2bit Esperando um ciclo",$time);
      end */
    
    else if(Run)
      begin
        Tstep <= Tstep + 1'b1;
        Espera1ciclo_d <= 0; // atualiza Espera1ciclo_d para o próximo ciclo
      end
    else if (Resetn)
      begin
        // $display("[%0t] linha 20 contador2bit",$time);
        Tstep <= 2'b0; // Avaliar se coloca 11
      end
endmodule
