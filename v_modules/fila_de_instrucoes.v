module fila_de_instrucoes(
        input Clock,
        input Reset,
        input Pop,                      // Sinal externo para despachar instrucao
        output reg [15:0] Instrucao_Despachada,
        output reg Full,
        output reg Empty
    );
    parameter sem_valor = 16'b0; // Valor padrao para instrucao sem valor

    // FIFO interna
    reg [15:0] Fila [15:0];                // 16 instrucoes de 16 bits
    reg [3:0] head;                        // leitura
    reg [3:0] tail;                        // escrita
    reg [4:0] count;                       // numero de elementos

    // PC para buscar na memoria
    reg [3:0] PC;
    wire [15:0] Mem_data;                      // saida da memoria (instrucao buscada)
    reg preenche = 0;                     // Sinal para indicar que a FIFO esta sendo preenchida

    // Memoria de instrucoes externa
    memoria_instrucoes u_memoria_instrucoes(
                           .Reset   (Reset),
                           .Clock   (Clock),
                           .Wren    (1'b0),
                           .Address (PC),//    .Address ({12'b0, PC}),
                           .Din     (16'b0),
                           .Q       (Mem_data)
                       );

    always @(negedge Clock or posedge Reset) begin
        if (Reset) // Reset sem preencher a FIFO, Passivel de dar merda na fpga
        begin
            head <= 0;
            tail <= 0;
            count <= 0;
            PC <= 0;
            Instrucao_Despachada <= 0;
            Full <= 0;
            Empty <= 1;
            preenche <= 1;
        end
       
        // if (Reset && !preenche) // Reset sem preencher a FIFO, Passivel de dar merda na fpga
        // begin
        //     head <= 0;
        //     tail <= 0;
        //     count <= 0;
        //     PC <= 0;
        //     Instrucao_Despachada <= 0;
        //     Full <= 0;
        //     Empty <= 1;
        //     preenche <= 1;
        // end
        // else if (Reset && preenche)
        // begin
        //     // Comeca a preencher a FIFO com as instrucoes da memoria
        //     Fila[tail] = Mem_data;
        //     tail = tail + 1;
        //     count <= count + 1;
        //     PC <= PC + 1;
        // end
        else
        begin
            // Busca automatica enquanto FIFO nao esta cheia
            if (count < 16)
            begin
                Fila[tail] <= Mem_data;
                // $display("[%0t] Tail inserido %0d",$time, tail);
                $display("[%0t] Linha 71 fila instrucoes Instrucao %0d inserida na fila: %b",$time, tail, Mem_data);
                tail = tail + 1;
                count <= count + 1;
                PC <= PC + 1;
            end

            // Despacho externo
            if (Pop && count > 0)
            begin
                Instrucao_Despachada = Fila[head];
                Fila[head] = sem_valor; // Joga a instrucao buscada na
                head <= head + 1;
                count <= count - 1;
            end

            // Flags
            Full <= (count == 16);
            Empty <= (count == 0);
        end
    end

endmodule
