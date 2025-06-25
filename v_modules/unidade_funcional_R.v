module unidade_funcional_R(A, B, Ufop, Q); 
// Talvez crirar um sinal para indicar se comeca ou nao a execucao, quem envia eh a estacao de reserva
  input [15:0] A, B;
  input [2:0] Ufop; // 2 bits para selecionar a operação da ULA
  output reg [15:0] Q; // Saída da ULA
  always @(A or B or Ufop)
    begin
      case (Ufop)
        3'b000: // Adição
          Q <= A + B;
        3'b001: // Subtração
          Q <= A - B;
        3'b010: // SLT
          Q <= (A < B) ? 16'd1 : 16'd0; // Set Less Than
        3'b011: // CMP
          Q <= (A == B) ? 16'd1 : 16'd0; // Compare
        3'b100: // Soma 4
          Q <= B + 16'd4; // Adição de 4
        3'b101: // Subtrai 4
          Q <= B - 16'd4; // Subtração de 4
      endcase
    end
endmodule
