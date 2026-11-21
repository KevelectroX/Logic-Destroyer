module block_1input 
(
    input wire i, rise, q,
	input wire [1:0] circuit,
	output reg o
);

    wire o1, o2, o3, o4;
	


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
        .q(q),
        .rise(rise),
        .q_next(o3)
    );

    t_flipflop block_4(
        .t(i),
        .q(q),
        .rise(rise),
        .q_next(o4)
    );


    always @(*)
    begin

        case(circuit)

            2'd0 : o = o1;

            2'd1 : o = o2;

            2'd2 : o = o3;

            2'd3 : o = o4;

            default : o = 0;

        endcase

    end // always @


endmodule