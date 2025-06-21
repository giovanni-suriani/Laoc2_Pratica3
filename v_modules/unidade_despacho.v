module unidade_despacho (
        Clock,
        Reset,
        Instrucao_Despachada, // Instrucao que sera despachada
        Busy_R1,
        Busy_R2,
        );
  input Clock;
  input Reset;
  input [15:0] Instrucao_Despachada;  // Instrucao que sera despachada
 // Sinais das estacoes de reserva
 Busy
  output reg Estacao_Reserva_Destino; // Estacao de reserva destino para a instrucao despachada
  
endmodule