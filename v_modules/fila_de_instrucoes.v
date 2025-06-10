module fila_de_instrucoes(        input Clock,
                                      input Reset,
                                      output[15:0] Instrucao
                             );
    reg Contador1bit;
    reg [3:0] PC ; // 16 instrucoes possiveis
    reg [15:0] data;

    memoram u_memoram(
                .address (PC ),
                .clock   (Clock   ),
                .data    (16'b0    ),
                .wren    (1'b0    ),  // Read only
                .q       (Instrucao)
            );

    always @(posedge Clock)
    begin
        if (Reset)
        begin
            PC <= 4'b0000;        // Reset PC to 0
            Contador1bit <= 1'b0; // Reset Contador1bit
        end
        else
        begin
          Contador1bit <= Contador1bit + 1;
            if (Contador1bit)
            begin
                PC <= PC + 1; // Increment PC apos pegar com certeza a instrucao
            end
        end
    end

endmodule
