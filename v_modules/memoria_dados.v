module memoria_dados (
        input wire Reset,               // Sinal de reset
        input wire Clock,               // clock
        input wire wren,                // write enable
        input wire [3:0] Address,       // endereco (4 bits para 16 posicoes)
        input wire [15:0] Din,          // dado de entrada
        output reg [15:0] Q             // dado de saida
    );
    // Memoria com 16 posicoes de 16 bits
    reg [15:0] mem [15:0];
    integer i;

    // Escrita sincrona
    always @(posedge Clock)
    begin
        if (Reset)
        begin
            // Inicializa todas as posicoes da memoria com zero
            for (i = 0; i < 16; i = i + 1) begin
                mem[i] <= 16'd7; // Atribuicao nao bloqueante para sincrono
            end
        end
        // Escrita
        if (wren)
        begin
            mem[Address] <= Din; // Escreve o dado na posicao especificada
            Q <= Din; // Atualiza a saida com o dado escrito
        end
        // Leitura
        else if (!wren)
        begin
            Q <= mem[Address]; // Le o dado da posicao especificada
        end
    end

endmodule
