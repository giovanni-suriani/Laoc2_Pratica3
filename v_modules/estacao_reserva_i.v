module estacao_reserva_i(
        input Clock,
        input [15:0] Instrucao_in,
        input Reset
    );

    reg [15:0] Instrucoes [2:0];
    integer i;

    always @(posedge Clock)
    begin
        if (Reset)
        begin
            for (i = 0; i < 16; i = i + 1) // declare antes o i
                begin
                    
                end
        end

    end

endmodule
