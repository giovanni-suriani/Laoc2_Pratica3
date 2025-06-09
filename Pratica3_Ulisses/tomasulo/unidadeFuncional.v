module unidadeFuncional(input clock, input nova, input [1:0] opcode, input [15:0] Vj, input [15:0] Vk, input [2:0] dest_in, input [3:0] Qi_in, 
								output reg [15:0] Vi, output reg V_pronto, output reg UF_atoa, output reg [2:0] dest_out, output reg [3:0] Qi_out);
	
	reg [1:0] cont;
	
	initial begin 
		cont = 2'b00;
	end
	
	always @(posedge clock) begin
	
		// estagio 00 -> espera sinal nova para iniciar o contador 
		// estagio 01 a 10 -> realizando a contagem 
		// estagio 11 -> realiza a operacao e passa os valores para os sinais de saida e volta para o estagio 00
		
	
		if(cont == 2'b00) begin
			V_pronto = 0;
			UF_atoa = 1;
			if(nova == 1) begin
				cont = 2'b01;
				UF_atoa = 0;
			end
		end else if(cont < 2'b11) begin
			UF_atoa = 0;
			cont = cont + 1;
			V_pronto = 0;
		end else if (cont == 2'b11) begin
			
			if(!(opcode == 2'b01))
				Vi = Vj + Vk;
			else
				Vi = Vj - Vk;

			dest_out <= dest_in;
			Qi_out = Qi_in;
			
			cont = 2'b00;
			
			V_pronto = 1;
			UF_atoa = 1;
		end
	end
	
endmodule