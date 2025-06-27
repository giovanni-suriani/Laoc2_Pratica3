module CDB_arbiter (
    input Clock,
    input Reset,
    output reg [2:0]  Qi_CDB,
    output reg [15:0] Qi_CDB_data
  );

  always @(posedge Clock or posedge Reset)
    if (Reset)
      begin
        Qi_CDB <= 3'b000;
        Qi_CDB_data <= 16'b0;
      end
    else
      begin
      end

endmodule
