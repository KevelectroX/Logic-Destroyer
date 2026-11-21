module block_2input
(
	input wire i1, i2, rise, q, 
	input wire [2:0] circuit,
	output reg o
);

	wire o1, o2, o3, o4, o5, o6, o7, o8;
	
	
	
	and_gate block_1(
				.a(i1),
				.b(i2),
				.c(o1)
				);
	
	
	or_gate block_2(
				.a(i1),
				.b(i2),
				.c(o2)
				);
				

	nand_gate block_3(
				.a(i1),
				.b(i2),
				.c(o3)
				);
	
	
	nor_gate block_4(
				.a(i1),
				.b(i2),
				.c(o4)
				);
				
				
	xor_gate block_5(
				.a(i1),
				.b(i2),
				.c(o5)
				);
				
				
	xnor_gate block_6(
				.a(i1),
				.b(i2),
				.c(o6)
				);
				
	semi_sum block_7(
				.a(i1),
				.b(i2),
				.s(o7)
				);
				
	jk_flipflop block_8(
				.j(i1),
				.k(i2),
				.q(q),
				.rise(rise),
				.q_next(o8)
				);
	

	always @(*) 
	begin

		case (circuit)
		
			4'd0 : o = o1;
			
			4'd1 : o = o2;
			
			4'd2 : o = o3;
			
			4'd3 : o = o4;
			
			4'd4 : o = o5;
			
			4'd5 : o = o6;
			
			4'd6 : o = o7;
			
			4'd7 : o = o8;

			default : o = 0;
				
		endcase
	end
	
	

endmodule