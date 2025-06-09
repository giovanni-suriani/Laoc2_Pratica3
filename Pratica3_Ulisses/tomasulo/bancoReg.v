module bancoReg (regLido1, regLido2, regEscr, dadoEscr, dado1, dado2, habEscr, clock, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7);

  input [2:0] regLido1, regLido2, regEscr; // 8 registradores
  input [15:0] dadoEscr;
  input habEscr, clock;
  output [15:0] dado1, dado2, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;
  
  reg [15:0] BR [7:0];
  
  assign reg0 = BR[0];
  assign reg1 = BR[1];
  assign reg2 = BR[2];
  assign reg3 = BR[3];
  assign reg4 = BR[4];
  assign reg5 = BR[5];
  assign reg6 = BR[6];
  assign reg7 = BR[7];
  
  integer i;
  
  initial begin

	for(i = 0; i < 8; i = i + 1) begin
		BR[i] = 0;
	end
	
  end
  
  always @(posedge clock) begin
    if(habEscr) begin
      BR[regEscr] = dadoEscr;
    end
  end
  
  assign dado1 = BR[regLido1];
  assign dado2 = BR[regLido2];
endmodule