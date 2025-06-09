module tomasulo(input [0:0] KEY, output [6:0] HEX0, output [6:0] HEX1, output [6:0] HEX2, output [6:0] HEX3, output [6:0] HEX4, output [6:0] HEX5, output [6:0] HEX6, output [6:0] HEX7);

	wire clock;
	assign clock = KEY[0];

	wire SR_R_cheia, SR_I_cheia, nova_R, nova_I, UF_R_atoa, UF_I_atoa, W_mem, V_mem_pronto, V_R_pronto, V_I_pronto, habEscr, nv_adt, nova_mem, nv_inst;
	wire [15:0] instrucao, Vj, Vk, Vj_R, Vk_R, Vj_I, Vk_I, adt_V_R_CDB, adt_V_I, data_mem, in_mem, adt_V, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;
	wire [1:0] opcode_mem_out, opcode_mem, opcode_I, opcode_R;
	wire [2:0] endr_Vj, endr_Vk, dest_R, dest_I, dest_mem, dest_mem_CDB, dest_R_CDB, dest_I_CDB, dest_CDB;
	wire [3:0] Qi_R, Qi_I, Qi_mem, adt_Q_mem, adt_Q_R_CDB, adt_Q_I, adt_Q;
	wire [7:0] A;

	filaInstrucoes FI (.clock(clock), .SR_R_cheia(SR_R_cheia), .SR_I_cheia(SR_I_cheia), .instrucao_out(instrucao), .nv_inst(nv_inst), .endr_Vj(endr_Vj), .endr_Vk(endr_Vk));

	bancoReg BR(.clock(clock), .regLido1(endr_Vj), .regLido2(endr_Vk), .regEscr(dest_CDB), .dadoEscr(adt_V), .dado1(Vj), .dado2(Vk), .habEscr(habEscr), 
					.reg0(reg0), .reg1(reg1), .reg2(reg2), .reg3(reg3), .reg4(reg4), .reg5(reg5), .reg6(reg6), .reg7(reg7));

	estacaoReserva SR (clock, instrucao, Vj, Vk, V_R_pronto, adt_Q_R_CDB,
							adt_Q, adt_V, dest_CDB, nv_adt, nv_inst, endr_Vj, endr_Vk,
							adt_V_I, V_I_pronto, adt_Q_I,
							V_mem_pronto, adt_Q_mem,
							SR_R_cheia, SR_I_cheia, opcode_mem, opcode_I, opcode_R,
							Vj_R, Vk_R, dest_R, Qi_R, nova_R,
							Vj_I, Vk_I, dest_I, Qi_I, nova_I,
							A, data_mem, W_mem, dest_mem, Qi_mem, nova_mem);

	unidadeFuncional UF_R (.clock(clock), .nova(nova_R), .opcode(opcode_R), .Vj(Vj_R), .Vk(Vk_R), .dest_in(dest_R), .Qi_in(Qi_R), 
								.Vi(adt_V_R_CDB), .UF_atoa(UF_R_atoa), .V_pronto(V_R_pronto), .dest_out(dest_R_CDB), .Qi_out(adt_Q_R_CDB));

	unidadeFuncional UF_I (.clock(clock), .nova(nova_I), .opcode(opcode_I), .Vj(Vj_I), .Vk(Vk_I), .dest_in(dest_I), .Qi_in(Qi_I), 
								.Vi(adt_V_I), .UF_atoa(UF_I_atoa), .V_pronto(V_I_pronto), .dest_out(dest_I_CDB), .Qi_out(adt_Q_I));

	memoria memDado (.clock(clock), .A(A), .data(data_mem), .W(W_mem), .dest_in(dest_mem), .Qi_in(Qi_mem), .nova(nova_mem), .opcode_in(opcode_mem), .out(in_mem), .dest_out(dest_mem_CDB), .Qi_out(adt_Q_mem), .V_pronto(V_mem_pronto), .opcode_out(opcode_mem_out));

	CDBArbiter CDB (.clock(clock), .in_mem(in_mem), .dest_mem(dest_mem_CDB), .Qi_mem(adt_Q_mem), .V_mem_pronto(V_mem_pronto), .in_R(adt_V_R_CDB), .dest_R(dest_R_CDB), .Qi_R(adt_Q_R_CDB), .V_R_pronto(V_R_pronto), .opcode(opcode_mem_out),
						.out(adt_V), .dest_out(dest_CDB), .Qi_out(adt_Q), .habEscr(habEscr), .nv_adt(nv_adt));

	decodificadorComportamental d0(reg0%10 , HEX0);
	decodificadorComportamental d1(reg1%10 , HEX1);
	decodificadorComportamental d2(reg2%10 , HEX2);
	decodificadorComportamental d3(reg3%10 , HEX3);
	decodificadorComportamental d4(reg4%10 , HEX4);
	decodificadorComportamental d5(reg5%10 , HEX5);
	decodificadorComportamental d6(reg6%10 , HEX6);
	decodificadorComportamental d7(reg7%10 , HEX7);

endmodule