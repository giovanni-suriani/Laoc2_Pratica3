module registrador (
        Qi,
        Qi_CDB,
        CDB,
        Rin,
        Clock,
        Reset,
        Q);
    // Modulo que representa um registrador de 16 bits que quando habilitado
    // armazena o valor Rin na entrada R. O valor armazenado é lido na

    // inputs

    /* The number of the reservation station that contains the operation whose
    result should be stored into this register. If the value of Qi is blank (or 0), no
    currently active instruction is computing a result destined for this register,
    meaning that the value is simply the register contents */

    input [1:0] Qi; // numero da reserva que contem a operacao cujo resultado deve ser armazenado neste registrador
    input [1:0] Qi_CDB;
    input [15:0] CDB;
    input Rin, Clock, Reset;

    // outputs
    output reg [15:0] Q; // valor armazenado

    always @(negedge Clock)
        if (Qi == Qi_CDB) // se Rin for alto e Reset for baixo, armazena R
            Q <= CDB; // armazena o valor de Qi_data no registrador Q
        else if (Reset)
            Q <= 16'd1;
endmodule
