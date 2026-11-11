module topology1(
    input wire i1, i2, i3, rise, clk, enable,
    output wire o1, q_0
);

    wire io_0, q_1;

    block_2input #(.SEED(4'b0111)) block1(
        .i1(i1),
        .i2(i2),
        .rise(rise),
        .clk(clk),
        .circuit(4'd7),
        .enable(enable),
        .o(io_0),
        .q(q_0)
    );

    block_2input #(.SEED(4'b0101)) block2(
        .i1(io_0),
        .i2(i3),
        .rise(rise),
        .clk(clk),
        .circuit(4'd0),
        .enable(enable),
        .o(o1),
        .q(q_1)
    );



endmodule