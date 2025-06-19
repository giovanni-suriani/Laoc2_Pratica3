module fila_de_instrucoes(
        input Clock,
        input Reset,
        input Pop,                      // Sinal externo para despachar instrucao
        output reg [15:0] Instrucao_Despachada,
        output reg Full,
        output reg Empty
    );

    // FIFO interna
    reg [15:0] Fila [15:0];                // 16 instrucoes de 16 bits
    reg [3:0] head;                        // leitura
    reg [3:0] tail;                        // escrita
    reg [4:0] count;                       // numero de elementos

    // PC para buscar na memoria
    reg [3:0] PC;
    wire [15:0] Data;                      // saida da memoria (instrucao buscada)

    // Memoria de instrucoes externa
    memoria_instrucoes u_memoria_instrucoes(
                           .Reset   (Reset),
                           .Clock   (Clock),
                           .wren    (1'b0),
                           .Address ({12'b0, PC}),
                           .Din     (16'b0),
                           .Q       (Data)
                       );

    always @(posedge Clock or posedge Reset) begin
        if (Reset)
        begin
            head <= 0;
            tail <= 0;
            count <= 0;
            PC <= 0;
            Instrucao_Despachada <= 0;
            Full <= 0;
            Empty <= 1;
        end
        else
        begin
            // Busca automatica enquanto FIFO nao esta cheia
            if (count < 16)
            begin
                Fila[tail] <= Data;
                tail <= tail + 1;
                count <= count + 1;
                PC <= PC + 1;
            end

            // Despacho externo
            if (Pop && count > 0)
            begin
                Instrucao_Despachada <= Fila[head];
                head <= head + 1;
                count <= count - 1;
            end

            // Flags
            Full <= (count == 16);
            Empty <= (count == 0);
        end
    end

endmodule
