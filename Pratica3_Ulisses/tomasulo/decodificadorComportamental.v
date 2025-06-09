module decodificadorComportamental(SW,HEX0);

	input [3:0]SW;
	output reg [0:6]HEX0;

	always@(*)
	begin

		case(SW)						//  abcdefg 
			4'b0000 : HEX0[0:6] = 7'b0000001; // 0
			4'b0001 : HEX0[0:6] = 7'b1001111; // 1
			4'b0010 : HEX0[0:6] = 7'b0010010; // 2
			4'b0011 : HEX0[0:6] = 7'b0000110; // 3
			4'b0100 : HEX0[0:6] = 7'b1001100; // 4
			4'b0101 : HEX0[0:6] = 7'b0100100; // 5
			4'b0110 : HEX0[0:6] = 7'b0100000; // 6
			4'b0111 : HEX0[0:6] = 7'b0001111; // 7
			4'b1000 : HEX0[0:6] = 7'b0000000; // 8
			4'b1001 : HEX0[0:6] = 7'b0000100; // 9
			default : HEX0[0:6] = 7'b1111111; // 10+
		endcase
	end

endmodule