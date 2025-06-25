`timescale 1ps/1ps
module tb_fila;

  // Sinais de controle
  reg Clock;
  reg Reset;
  reg Wren;
  reg [3:0] Address;
  reg [15:0] Din;
  wire [15:0] Q;
  wire Full;
  wire Empty;
  wire [15:0] Instrucao_Despachada;
  reg Pop;



  fila_de_instrucoes uut(
                       .Clock                (Clock                ),
                       .Reset                (Reset                ),
                       .Pop                  (Pop                  ),
                       .Instrucao_Despachada (Instrucao_Despachada ),
                       .Full                 (Full                 ),
                       .Empty                (Empty                )
                     );


  // Gerador de clock
  always
    begin
      #50 Clock = ~Clock; // Clock com periodo de 10 ps
    end

  initial
    begin
      // Inicializacao dos sinais
      Clock = 0;
      Reset = 1;

      #150;
      Reset = 0; // Desativa o reset

      #400;
      $display("[%0t] Ativando despacho",$time);
      Pop = 1; // Ativa o despacho de instrucao

    end


endmodule
