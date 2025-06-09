module CDBArbiter(input clock, input [15:0] in_mem, input[2:0] dest_mem, input [3:0] Qi_mem, input V_mem_pronto, input [15:0] in_R, input[2:0] dest_R, input [3:0] Qi_R, input V_R_pronto, input [1:0] opcode,
						output reg [15:0] out, output reg [2:0] dest_out, output reg [3:0] Qi_out, output reg habEscr, output reg nv_adt);
	reg [15:0] data [7:0];
	reg [2:0] dest [7:0];
	reg [3:0] Qi [7:0];
	reg busy [7:0];

	integer i, j;

	initial begin
		for(i = 0; i < 8; i = i + 1) begin
			busy[i] = 0;
		end
	end

	always @(posedge clock) begin
		begin: for1
			for(i = 0; i < 8; i = i + 1) begin
				if(!busy[i]) begin
					if(V_mem_pronto && opcode === 2'b10) begin 
						busy[i] = 1;
						data[i] = in_mem;
						dest[i] = dest_mem;
						Qi[i] = Qi_mem;
					end
					disable for1;
				end
			end
		end
		
		begin: for2
			for(i = 0; i < 8; i = i + 1) begin
				if(!busy[i]) begin
					if(V_R_pronto) begin 
						busy[i] = 1;
						data[i] = in_R;
						dest[i] = dest_R;
						Qi[i] = Qi_R;
					end
					disable for2;
				end
			end
		end

		if(busy[0]) begin
			out = data[0];
			dest_out = dest[0];
			Qi_out = Qi[0];
			habEscr = 1;

			for(j = 0; j < 7; j = j + 1) begin
				data[j] = data[j+1];
				dest[j] = dest[j+1];
				Qi[j] = Qi[j+1];
				busy[j] = busy[j+1];
			end

			busy[7] = 0;

			nv_adt = 1;
		end else begin
			habEscr = 0;
			nv_adt = 0;
		end
	end
endmodule