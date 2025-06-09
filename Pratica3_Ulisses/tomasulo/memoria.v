module memoria(input clock, input [7:0] A, input [15:0] data, input W, input [2:0] dest_in, input [3:0] Qi_in, input nova, input [1:0] opcode_in, output [15:0] out, output [2:0] dest_out, output [3:0] Qi_out, output reg V_pronto, output [1:0] opcode_out);
	
	mem mem1(A, clock, data, W, out);
	
	assign Qi_out = Qi_in;
	assign dest_out = dest_in;
	assign opcode_out = opcode_in;
	
	always @(posedge clock) begin
		V_pronto = 0;
		if(nova == 1) begin
			V_pronto = 1;
		end
	end
	
endmodule