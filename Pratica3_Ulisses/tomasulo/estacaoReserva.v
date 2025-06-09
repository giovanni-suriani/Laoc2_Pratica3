module estacaoReserva(input clock, input [15:0] instrucao_in, input [15:0] Vj_in, input [15:0] Vk_in, input V_R_pronto, input [3:0] adt_Q_R,
								input [3:0] adt_Q_in, input [15:0] adt_V_in, input [2:0] adt_dest_in, input nv_adt, input nv_inst, input [2:0] endr_Vj, input [2:0] endr_Vk,
								input [15:0] adt_V_I, input V_I_pronto, input [3:0] adt_Q_I,
								input V_mem_pronto, input [3:0] adt_Q_mem,
								output reg SR_R_cheia, output reg SR_I_cheia, output reg [1:0] opcode_mem, output reg [1:0] opcode_I, output reg [1:0] opcode_R,
								output reg [15:0] Vj_R_out, output reg [15:0] Vk_R_out, output reg [2:0] dest_R_out, output reg [3:0] Qi_R_out, output reg nova_R,
								output reg [15:0] Vj_I_out, output reg [15:0] Vk_I_out, output reg [2:0] dest_I_out, output reg [3:0] Qi_I_out, output reg nova_I,
								output reg [7:0] A_out, output reg [15:0] data_out, output reg W_mem, output reg [2:0] dest_mem_out, output reg [3:0] Qi_mem_out, output reg nova_mem);

	reg busy [9:0];
	reg [1:0] opcode [9:0];
	reg [15:0] Vj [9:0];
	reg [15:0] Vk [9:0];
	reg [3:0] Qj [9:0]; // 10 possiveis valores para as tags (5 de add/sub e 5 de load/store)
	reg [3:0] Qk [9:0];
	reg [7:0] I [9:0];
	reg [7:0] A [9:0];
	reg [2:0] dest [9:0];
	reg [3:0] OE [9:0]; // ordem de entrada de 1 a 10
	reg enc_UF [9:0];
	reg enc_mem [9:0];

	reg [2:0] cont_R, cont_I;
	reg UF_R_atoa, UF_I_atoa;

	integer i, j, k, l;

	initial begin 
		for(i = 0; i < 10; i = i + 1) begin 
			busy[i] = 0;
			OE[i] = i + 1;
			cont_R = 0;
			cont_I = 0;
			UF_R_atoa = 1;
			UF_I_atoa = 1;
		end
		
		nova_R = 0;
		nova_I = 0;
		W_mem = 0;
	end

	always @(posedge clock) begin 

		// verifica se as estacoes de reserva estao cheias
		for(i = 0; i < 10; i = i + 1) begin
			if(busy[i]) begin 
				if(opcode[i] === 2'b00 || opcode[i] === 2'b01) begin // tipo R
					cont_R = cont_R + 1;
				end else if(opcode[i] === 2'b10 || opcode[i] === 2'b11) begin // tipo I
					cont_I = cont_I + 1;
				end
			end
		end

		if(cont_R >= 5)
			SR_R_cheia = 1'b1;
		else
			SR_R_cheia = 1'b0;

		if(cont_I >= 5)
			SR_I_cheia = 1'b1;
		else
			SR_I_cheia = 1'b0;

		cont_R = 0;
		cont_I = 0;

		begin: for1 // coloca nova instrucao na SR
			for(i = 0; i < 10; i = i + 1) begin
				if(!busy[i] && ((instrucao_in[15:14] <= 2'b01 && !SR_R_cheia) || (instrucao_in[15:14] >= 2'b10 && !SR_I_cheia)) && nv_inst) begin // se a posicao i estiver vazia e umas das duas estacoes estiverem vazias

					// atualiza OE
					for(j = 0; j < 10; j = j + 1) begin
						if(j != i && OE[j] < OE[i])
							OE[j] = OE[j] + 1;
					end
					OE[i] = 1;

					busy[i] = 1;
					enc_UF[i] = 0;
					enc_mem[i] = 0;
					opcode[i] = instrucao_in[15:14];
					dest[i] = instrucao_in[13:11];

					if(instrucao_in[15:14] >= 2'b10 && !SR_I_cheia) begin
						I[i] = instrucao_in[7:0];
					end

					for(j = 10; j >= 1; j = j - 1) begin // do menos recente para o mais recente
						begin: forOE1
							for(k = 0; k < 10; k = k + 1) begin // : forj

								if(OE[k] == j) begin // encontrou a j-esima instrucao a entrar na SR

									if(k != i && busy[k]) begin

										if(dest[k] == endr_Vj) begin
											Qj[i] = k;
										end

										if(dest[k] == endr_Vk) begin
											Qk[i] = k;
										end 

									end

									disable forOE1;
								end

							end
						end
					end
					
					if(adt_dest_in == endr_Vj) begin
						Qj[i] = adt_Q_in;
					end else if(Qj[i] === 4'bX) begin // se nao encontrar em nenhum dest de nenhuma SR coloca em Vj o valor vindo do BR
						Vj[i] = Vj_in;
					end

					if(adt_dest_in == endr_Vk) begin
						Qk[i] = adt_Q_in;
					end else if(Qk[i] === 4'bX) begin // se nao encontrar em nenhum dest de nenhuma SR coloca em Vk o valor vindo do BR
						Vk[i] = Vk_in;
					end

					disable for1;
				end
			end
		end
		
		for(i = 0; i < 10; i = i + 1) begin
			if(V_I_pronto) begin
				UF_I_atoa = 1;
			end
			
			if(V_R_pronto) begin
				UF_R_atoa = 1;
			end
			
			
			if(V_R_pronto && i == adt_Q_R) begin
				busy[i] = 0;
				enc_UF[i] = 0;
				enc_mem[i] = 0;
			end
			
			if(V_I_pronto && i == adt_Q_I) begin
				A[i] = adt_V_I;
				I[i] = 8'bXXXXXXXX;
			end
			
			if(V_mem_pronto && i == adt_Q_mem) begin 
				busy[i] = 0;
				enc_UF[i] = 0;
				enc_mem[i] = 0;
			end
		end

		if(nv_adt == 1) begin // adiantamento (substituir o adt_Q_in por adt_V_in se existir adt_Q_in na SR)
			for(l = 0; l < 10; l = l + 1) begin
				if(busy[l]) begin
					if(Qj[l] == adt_Q_in) begin // procura em Qj
						Qj[l] = 4'bXXXX;
						Vj[l] = adt_V_in;
					end
					
					if(Qk[l] == adt_Q_in) begin // procura em Qj
						Qk[l] = 4'bXXXX;
						Vk[l] = adt_V_in;
					end
				end
			end
		end 
		
		begin: forOE2
			for(j = 10; j >= 1; j = j - 1) begin // do menos recente para o mais recente
				for(k = 0; k < 10; k = k + 1) begin // : forj

					if(OE[k] == j) begin // encontrou a j-esima instrucao a entrar na SR

						if(busy[k] && Qj[k] === 4'bXXXX && Qk[k] === 4'bXXXX && opcode[k] <= 2'b01 && UF_R_atoa && !enc_UF[k]) begin // manda instrucao do tipo R para a UF_R
							if(1) begin
								UF_R_atoa = 0;
								enc_UF[k] = 1;
								Vj_R_out = Vj[k];
								Vk_R_out = Vk[k];
								dest_R_out = dest[k];
								Qi_R_out = k;
								opcode_R = opcode[k];
								nova_R = 1;
							end
							disable forOE2;
						end else begin
							nova_R = 0;
						end
						
					end
				end
			end
		end

		begin: forOE3
			for(j = 10; j >= 1; j = j - 1) begin // do menos recente para o mais recente
				for(k = 0; k < 10; k = k + 1) begin // : forj
				
					if(OE[k] == j) begin // encontrou a j-esima instrucao a entrar na SR
					
						if(busy[k] && Qk[k] === 4'bXXXX && I[k] !== 8'bXXXXXXXX && opcode[k] >= 2'b10 && UF_I_atoa && !enc_UF[k]) begin // manda instrucao do tipo I para a UF_I
							if(1) begin
								UF_I_atoa = 0;
								enc_UF[k] = 1;
								Vj_I_out = Vk[k];
								Vk_I_out = I[k];
								dest_I_out = dest[k];
								Qi_I_out = k;
								opcode_I = opcode[k];
								nova_I = 1;
							end
							disable forOE3;
						end else begin
							nova_I = 0;
						end
							
					end
				end
			end
		end

		begin: forOE4
			for(j = 10; j >= 1; j = j - 1) begin // do menos recente para o mais recente
				for(k = 0; k < 10; k = k + 1) begin // : forj
				
					if(OE[k] == j) begin // encontrou a j-esima instrucao a entrar na SR
					
						if(busy[k] && enc_UF[k] && opcode[k] >= 2'b10) begin
							
							if(I[k] === 8'bXXXXXXXX && !enc_mem[k] && ((opcode[k] === 2'b10) || (opcode[k] === 2'b11 && Qj[k] === 4'bXXXX))) begin // manda instrucao do tipo I com endereco ja calculado para a mem
								A_out = A[k];
								data_out = Vj[k];
								dest_mem_out = dest[k];
								Qi_mem_out = k;
								opcode_mem = opcode[k];
								if(opcode[k] === 2'b10) begin
									W_mem = 0;
									enc_mem[k] = 1;
								end else if(opcode[k] === 2'b11) begin
									W_mem = 1;
								end
								nova_mem = 1;
							end else begin
								nova_mem = 0;
							end
							
							disable forOE4;
						end else 
							nova_mem = 0;

					end
				end
			end
		end
	end
endmodule