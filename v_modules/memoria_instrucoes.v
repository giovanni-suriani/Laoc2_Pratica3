module memoria_instrucoes (
        input wire Reset,               // Sinal de reset
        input wire Clock,               // clock
        input wire Wren,                // write enable
        input wire [3:0] Address,       // endereco (4 bits para 16 posicoes)
        input wire [15:0] Din,          // dado de entrada
        output reg [15:0] Q             // dado de saida
    );
/* 
 0000 = ADD
 0001 = SUB
*/

    // Memoria com 16 posicoes de 16 bits
    reg [15:0] mem [15:0];
    integer i;

    // Escrita sincrona
    always @(posedge Clock)
    begin
        if (Reset)
        begin
            // Inicializa todas as posicoes de memoria
            for (i = 0; i < 16; i = i + 1) begin
                if (i == 0) // Inicializa a posicao 0 com a instrucao ADD
                    mem[i] <= 16'b0000_001_010_011_000; // ADD R1 R2 R3
                else if (i == 1) // Inicializa a posicao 1 com a instrucao SUB
                    mem[i] <= 16'b0001_001_010_011_000; // SUB R1 R2 R3
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
