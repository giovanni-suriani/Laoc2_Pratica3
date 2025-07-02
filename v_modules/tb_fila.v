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
  reg Pop_R;
  reg Pop_I;



  fila_de_instrucoes uut(
                       .Clock                (Clock                ),
                       .Reset                (Reset                ),
                       .Pop                  (Pop                  ),
                       .Pop_R                (Pop_R                ),
                       .Pop_I                (Pop_I                ),
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
      Pop   = 0;
      Pop_R = 0;
      Pop_I = 0;
      @(posedge Clock);
      Reset = 0; // Desativa o reset
      @(posedge Clock);
      Pop = 1; // Ativa o despacho de instrucao

      #400;
      $display("[%0t] Ativando despacho",$time);

    end


endmodule
