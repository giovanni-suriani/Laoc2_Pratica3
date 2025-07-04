module CDB_arbiter (
    input Clock,
    input Reset,
    input Write_Enable_CDB_LOAD1,
    input Write_Enable_CDB_LOAD2,
    input Done_ADD1, // Sinal de finalização da operação da unidade funcional ADD1
    input Done_ADD2, // Sinal de finalização da operação da unidade funcional ADD2
    input Done_LOAD1,
    input Done_LOAD2,
    input[15:0] Q_ADD1,    // Dado da unidade funcional ADD1
    input[15:0] Q_ADD2,    // Dado da unidade funcional ADD2
    input[15:0] Q_LOAD1,   // Dado da unidade funcional LOAD1
    input[15:0] Q_LOAD2,   // Dado da unidade funcional LOAD
    output reg [2:0]  Qi_CDB,
    output reg [15:0] Qi_CDB_data
  );

  parameter  FREE_REGISTER     = 3'd0,    // Registrador livre, sem estacao de reserva
             RES_STATION_ADD1  = 3'd1,    // Estacao de reserva R2
             RES_STATION_ADD2  = 3'd2,    // Estacao de reserva R2
             RES_STATION_LOAD1 = 3'd3,    // Estacao de reserva R2
             RES_STATION_LOAD2 = 3'd4;    // Estacao de reserva R2

  // always @(posedge Done_ADD1 or posedge Done_ADD2 or posedge Done_LOAD1 or posedge Write_Enable_CDB_LOAD2 or posedge Write_Enable_CDB_LOAD1 or posedge Done_LOAD2 or posedge Reset)
  always @(Reset or Done_LOAD1)
    if (Reset)
      begin
        Qi_CDB <= 3'd0;
        Qi_CDB_data <= 16'b0;
      end
    else
      begin
        if (Done_ADD1)
          begin
            Qi_CDB      <= RES_STATION_ADD1; // Atribui o valor da estacao de reserva ADD1
            Qi_CDB_data <= Q_ADD1; // Atribui o dado da unidade funcional ADD1
          end
        else if (Done_ADD2)
          begin
            Qi_CDB      <= RES_STATION_ADD2; // Atribui o valor da estacao de reserva ADD2
            Qi_CDB_data <= Q_ADD2; // Atribui o dado da unidade funcional ADD2
          end
        else if (Done_LOAD1 && Write_Enable_CDB_LOAD1) 
          begin
            Qi_CDB      <= RES_STATION_LOAD1;
            Qi_CDB_data <= Q_LOAD1; // Atribui o dado da unidade funcional LOAD1
          end
        else if (Done_LOAD2 && Write_Enable_CDB_LOAD2)
          begin
            Qi_CDB      <= RES_STATION_LOAD2;
            Qi_CDB_data <= Q_LOAD2; // Atribui o dado da unidade funcional LOAD2
          end
      end

endmodule
