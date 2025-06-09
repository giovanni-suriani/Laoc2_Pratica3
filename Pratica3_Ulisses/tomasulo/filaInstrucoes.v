// SR_R_cheia (estacao de reserva do tipo R cheia)
// SR_I_cheia (estacao de reserva do tipo I cheia)

// Tipo R: [ op(2 bits) | Ri(3 bits) | Rj (3 bits) | Rk (3 bits) ] total: 11 bits
// Tipo I: [ op(2 bits) | Ri(3 bits) | Rk (3 bits) | im (8 bits) ] total: 16 bits

/*
Op:
00 -> soma
01 -> sub
10 -> load
11 -> store
*/

module filaInstrucoes(input clock, input SR_R_cheia, input SR_I_cheia, output reg [15:0] instrucao_out, output reg nv_inst, output reg [2:0] endr_Vj, output reg [2:0] endr_Vk);
	reg [15:0] instrucoes [63:0];
	reg [5:0] PC;
	
	initial begin
		PC <= 1'b0;
		nv_inst = 0;
		instrucoes[0] = 16'b1000011100000001;
		instrucoes[1] = 16'b1000111100000011;
		instrucoes[2] = 16'b0000000100100000;
		
		instrucoes[3] = 16'b0001001000000000;
		instrucoes[4] = 16'b0101001000100000;
		instrucoes[5] = 16'b1101011100000000;
		instrucoes[6] = 16'b1001111100000000;
		
		instrucoes[7] = 16'b0010000000100000;
		instrucoes[8] = 16'b0010100000100000;
		instrucoes[9] = 16'b0011000000100000;
		instrucoes[10] = 16'b0011100000100000;
		
		instrucoes[11] = 16'b0010000000100000;
		instrucoes[12] = 16'b0010100000100000;
		instrucoes[13] = 16'b0011000000100000;
		instrucoes[14] = 16'b0011100000100000;
		
	end
	
	always @(posedge clock) begin 
		if(!(SR_R_cheia && instrucoes[PC][15:14] <= 2'b01) && !(SR_I_cheia && instrucoes[PC][15:14] >= 2'b10)) begin
			instrucao_out = instrucoes[PC];
			
			if(instrucoes[PC][15:14] <= 2'b01 && !SR_R_cheia) begin
				endr_Vj = instrucoes[PC][10:8];
				endr_Vk = instrucoes[PC][7:5];
			end else if(instrucoes[PC][15:14] >= 2'b10 && !SR_I_cheia) begin
				endr_Vk = instrucoes[PC][10:8];
				endr_Vj = instrucoes[PC][13:11];
			end
			
			PC = PC + 1;
			nv_inst = 1;
		end else begin
			if(nv_inst)
				PC = PC - 2;
			nv_inst = 0;
		end
	end
endmodule