module topology_3(
    input [31:0] random_config,
    output wire o1
);

    // Reparto de la configuración
    wire i1 = random_config[0];
    wire i2 = random_config[1];
    wire i3 = random_config[2];
    wire i4 = random_config[3];
    wire rise = random_config[4];

    wire w_g1, w_g2, w_g3;

    block_2input block1(
        .i1(i1),
        .i2(i2),
        .rise(rise),
        .q(random_config[8]),
        .circuit(random_config[7:5]),
        .o(w_g1)
    );

    block_2input block2(
        .i1(i3),
        .i2(i4),
        .rise(rise),
        .q(random_config[12]),
        .circuit(random_config[11:9]),
        .o(w_g2)
    );

    block_2input block3(
        .i1(w_g1),
        .i2(w_g2),
        .rise(rise),
        .q(random_config[16]),
        .circuit(random_config[15:13]),
        .o(w_g3)
    );

    block_1input block4(
        .i(w_g3),
        .rise(rise),
        .q(random_config[19]),
        .circuit(random_config[18:17]),
        .o(o1)
    );


endmodule
