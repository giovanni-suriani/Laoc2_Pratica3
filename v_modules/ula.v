module ula(A, BusWires, Ulaop, Q);
  input [15:0] A, BusWires;
  input [2:0] Ulaop; // 2 bits para selecionar a operação da ULA
  output reg [15:0] Q; // Saída da ULA
  always @(A or BusWires or Ulaop)
    begin
      case (Ulaop)
        3'b000: // Adição
          Q <= A + BusWires;
        3'b001: // Subtração
          Q <= A - BusWires;
        3'b010: // SLT
          Q <= (A < BusWires) ? 16'd1 : 16'd0; // Set Less Than
        3'b011: // CMP
          Q <= (A == BusWires) ? 16'd1 : 16'd0; // Compare
        3'b100: // Soma 4
          Q <= BusWires + 16'd4; // Adição de 4
        3'b101: // Subtrai 4
          Q <= BusWires - 16'd4; // Subtração de 4
      endcase
    end
endmodule
