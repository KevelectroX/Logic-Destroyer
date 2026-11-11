module block_2input #(parameter SEED)

(
	input wire i1, i2, rise, clk, enable, //enable en 0 apaga el LFSR
	input wire [3:0] circuit,
	output reg o, q
);

	wire o1, o2, o3, o4, o5, o6, o7, o8;
	
	wire [3:0] q_temp;
	
	LFSR #(.NUM_BITS(4), .DEFAULT_VALUE(SEED)) random(
		.i_Clk(clk),
		.i_Enable(enable),
		.i_Seed_DV(1'b0),
		.i_Seed_Data(4'd0),
		.o_LFSR_Data(q_temp)
	);
	
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
				.q(q_temp[0]),
				.rise(rise),
				.q_next(o8)
				);
	

	always @(*) 
	begin

		q = 0;

		case (circuit)
		
			4'd0 : o = o1;
			
			4'd1 : o = o2;
			
			4'd2 : o = o3;
			
			4'd3 : o = o4;
			
			4'd4 : o = o5;
			
			4'd5 : o = o6;
			
			4'd6 : o = o7;
			
			4'd7 : 
			begin
				o = o8;
				q = q_temp[0];
			end

			default : o = 0;
				
		endcase
	end
	
	

endmodule