module topology_2(
    input [31:0] random_config, 
    output wire o1
);

    // Reparto de la configuración
    wire i1 = random_config[0];
    wire i2 = random_config[1];
    wire i3 = random_config[2];
    wire rise = random_config[3];

    wire w_g1, w_g2;

    block_2input block1(
        .i1(i1),
        .i2(i2),
        .rise(rise),
        .q(random_config[7]),
        .circuit({1'b0, random_config[6:4]}),
        .o(w_g1)
    );

    block_1input block2(
        .i(i3),
        .rise(rise),
        .q(random_config[10]),
        .circuit(random_config[9:8]),
        .o(w_g2)
    );

    block_2input block3(
        .i1(w_g1),
        .i2(w_g2),
        .rise(rise),
        .q(random_config[14]),
        .circuit({1'b0, random_config[13:11]}),
        .o(o1)
    );


endmodule
