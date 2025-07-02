module memoria_instrucoes (
    input wire Reset,               // Sinal de reset
    input wire Clock,               // clock
    input wire Wren,                // write enable
    input wire [3:0] Address,       // endereco (4 bits para 16 posicoes)
    input wire [15:0] Din,          // dado de entrada
    output reg [15:0] Q             // dado de saida
  );
  /*
   001 = ADD
   010 = SUB
  */

  parameter NOP = 16'd0; // NOP (No Operation) - 0000
  parameter ADD = 3'd2;
  parameter SUB = 3'd3;

  parameter R0 = 3'd0; // Registrador R0
  parameter R1 = 3'd1; // Registrador R1
  parameter R2 = 3'd2; // Registrador R2
  parameter R3 = 3'd3; // Registrador R3


  // Memoria com 16 posicoes de 16 bits
  reg [15:0] mem [15:0];
  integer i;

  // Escrita sincrona
  always @(posedge Clock)
    begin
      if (Reset)
        begin
          // Inicializa todas as posicoes de memoria
          /* for (i = 0; i < 16; i = i + 1)
            begin
              if (i == 0) // Inicializa a posicao 0 com a instrucao ADD R0 R1 R2
                mem[i] <= 16'd1;
              else if (i == 1) // Inicializa a posicao 1 com a instrucao SUB R0 R1 R2
                mem[i] <= 16'd2;
              else if (i == 2) // Inicializa a posicao 2com a instrucao ADD R0 R1 R2
                mem[i] <= 16'd3;
              else if (i == 3)
                mem[i] <= 16'd4;
              else if (i == 4)
                mem[i] <= 16'd5;
              else if (i == 5)
                mem[i] <= 16'd6;
              else if (i == 6)
                mem[i] <= {SUB, R0, R1, R2, 4'b0};
              // mem[i] <= NOP; // NOP
              else
                mem[i] <= 16'b0; // Atribuicao nao bloqueante para sincrono
            end */
          /* for (i = 0; i < 16; i = i + 1)
            begin
              if (i == 0) // Inicializa a posicao 0 com a instrucao ADD R0 R1 R2
                mem[i] <= {ADD, R0, R1, R2, 4'b0};
              else if (i == 1) // Inicializa a posicao 1 com a instrucao SUB R0 R1 R2
                mem[i] <= {SUB, R0, R1, R2, 4'b0};
              else if (i == 2) // Inicializa a posicao 2com a instrucao ADD R0 R1 R2
              mem[i] <= {ADD, R0, R1, R2, 4'd1};
              else if (i == 3)
              mem[i] <= {SUB, R0, R1, R2, 4'd2};
              else if (i == 4)
                mem[i] <= {ADD, R0, R1, R2, 4'b0};
              else if (i == 5)
                mem[i] <= {ADD, R0, R1, R2, 4'b0};
              else if (i == 6)
                mem[i] <= {ADD, R0, R1, R2, 4'b0};
              // mem[i] <= NOP; // NOP
              else
                mem[i] <= 16'b0; // Atribuicao nao bloqueante para sincrono
            end */
          for (i = 0; i < 16; i = i + 1)
            begin
              if (i == 0) // Inicializa a posicao 0 com a instrucao ADD R0 R1 R2
                mem[i] <= {ADD, R0, R1, R2, 4'b0};
              else if (i == 1) // Inicializa a posicao 1 com a instrucao SUB R0 R1 R2
                mem[i] <= {SUB, R0, R1, R2, 4'b0};
              else if (i == 2) // Inicializa a posicao 2com a instrucao ADD R0 R1 R2
              mem[i] <= {ADD, R0, R1, R2, 4'd1};
              else if (i == 3)
              mem[i] <= {SUB, R0, R1, R2, 4'd2};
              else if (i == 4)
                mem[i] <= {ADD, R0, R1, R2, 4'b0};
              else if (i == 5)
                mem[i] <= {ADD, R0, R1, R2, 4'b0};
              else if (i == 6)
                mem[i] <= {ADD, R0, R1, R2, 4'b0};
              // mem[i] <= NOP; // NOP
              else
                mem[i] <= 16'b0; // Atribuicao nao bloqueante para sincrono
            end
        end
      // Escrita
      if (Wren)
        begin
          mem[Address] <= Din; // Escreve o dado na posicao especificada
          Q <= Din; // Atualiza a saida com o dado escrito
        end
      // Leitura
      else if (!Wren)
        begin
          Q <= mem[Address]; // Le o dado da posicao especificada
        end
    end

endmodule
