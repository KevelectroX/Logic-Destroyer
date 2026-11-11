module block_1input #(parameter SEED)

(
    input wire i, rise, clk, enable, //enable en 0 apaga el LFSR
	input wire [1:0] circuit,
	output reg o, q
);

    wire o1, o2, o3, o4;
	
	wire [3:0] q_temp;
	
	LFSR #(.NUM_BITS(4), .DEFAULT_VALUE(SEED)) random(
		.i_Clk(clk),
		.i_Enable(enable),
		.i_Seed_DV(1'b0),
		.i_Seed_Data(4'd0),
		.o_LFSR_Data(q_temp)
	);


    not_gate block_1(
        .a(i),
        .b(o1)
    );

    buf_gate block_2(
        .a(i),
        .b(o2)
    );

    d_flipflop block_3(
        .d(i),
        .q(q_temp[0]),
        .rise(rise),
        .q_next(o3)
    );

    t_flipflop block_4(
        .t(i),
        .q(q_temp[0]),
        .rise(rise),
        .q_next(o4)
    );


    always @(*)
    begin

        q = 0;

        case(circuit)

            2'd0 : o = o1;

            2'd1 : o = o2;

            2'd2 :
            begin 
                o = o3;
                q = q_temp[0];
            end

            2'd3 :
            begin
                o = o4;
                q = q_temp[0];
            end

            default : o = 0;

        endcase

    end // always @


endmodule