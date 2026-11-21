module topology_5(
    input [31:0] random_config,    
    output wire o1, o2, o3
);

    // Reparto de la configuración
    wire i1 = random_config[0];
    wire i2 = random_config[1];
    wire i3 = random_config[2];
    wire i4 = random_config[3];
    wire i5 = random_config[4];
    wire rise = random_config[5];

    wire w_g1, w_g2, w_g3, w_g5;

    block_2input block1(
        .i1(i1),
        .i2(i2),
        .rise(rise),
        .q(random_config[9]),
        .circuit({1'b0, random_config[8:6]}),
        .o(w_g1)
    );

    block_1input block2(
        .i(i3),
        .rise(rise),
        .q(random_config[12]),
        .circuit(random_config[11:10]),
        .o(w_g2)
    );

    block_2input block3(
        .i1(i4),
        .i2(i5),
        .rise(rise),
        .q(random_config[16]),
        .circuit({1'b0, random_config[15:13]}),
        .o(w_g3)
    );

    block_2input block4(
        .i1(w_g1),
        .i2(w_g2),
        .rise(rise),
        .q(random_config[20]),
        .circuit({1'b0, random_config[19:17]}),
        .o(o1)
    );

    block_2input block5(
        .i1(w_g2),
        .i2(w_g3),
        .rise(rise),
        .q(random_config[24]),
        .circuit({1'b0, random_config[23:21]}),
        .o(w_g5)
    );

    block_1input block6(
        .i(w_g3),
        .rise(rise),
        .q(random_config[27]),
        .circuit(random_config[26:25]),
        .o(o2)
    );

    block_2input block7(
        .i1(w_g5),
        .i2(w_g1),
        .rise(rise),
        .q(random_config[31]),
        .circuit({1'b0, random_config[30:28]}),
        .o(o3)
    );


endmodule
