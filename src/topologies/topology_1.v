module topology_1(
    input wire i1, i2, i3, rise, q_0, q_1,
    input [2:0] circuit1, circuit2,
    output wire o1
);

    wire io_0;


    block_2input block1(
        .i1(i1),
        .i2(i2),
        .rise(rise),
        .circuit(circuit1),
        .o(io_0),
        .q(q_0)
    );

    block_2input block2(
        .i1(io_0),
        .i2(i3),
        .rise(rise),
        .circuit(circuit2),
        .o(o1),
        .q(q_1)
    );



endmodule