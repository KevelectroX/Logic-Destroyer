module title_draw(
    input clk,
    input [3:0] round,
    input rst,
    input [9:0] hcount, ycount,

    output reg [10:0] text,
    output reg [8:0] item
);

    localparam GATE = 2'd1;
    localparam XNOR = 4'd5;
    localparam SEMI_SUM = 4'd6;


    // Colores {azul, verde, rojo}
    localparam WHITE  = 3'b111;
    localparam RGB = 3'b000;
    
    localparam SEMI_HALF_SECOND = 50_000_000 / 4;

    reg twinkle = 0;
    reg [23:0] counter = 0;

    // Posiciones
    wire [4:0] gx = hcount[9:5];
    wire [3:0] gy = ycount[8:5];
    wire [5:0] lx = hcount[9:4];
    wire [4:0] ly = ycount[8:4];

    always @(*)
    begin
        item = 0;
        text = 0;

        // Compuertas a los lados
        if(gx == 2 && gy == 5) item = {GATE, XNOR, WHITE};
        if(gx == 16 && gy == 5) item = {GATE, SEMI_SUM, WHITE};

        // Logic
        if(gx == 7 && gy == 4) text = {1'b1, 7'd38, RGB};               // L
        if(gx == 8 && gy == 4) text = {1'b1, 7'd15 + 7'd26, RGB};       // o
        if(gx == 9 && gy == 4) text = {1'b1, 7'd7 + 7'd26, RGB};        // g
        if(gx == 10 && gy == 4) text = {1'b1, 7'd9 + 7'd26, RGB};       // i
        if(gx == 11 && gy == 4) text = {1'b1, 7'd3 + 7'd26, RGB};       // c

        // Destroyer
        if(gx == 5 && gy == 6) text = {1'b1, 7'd30, RGB};               // D
        if(gx == 6 && gy == 6) text = {1'b1, 7'd5 + 7'd26, RGB};        // e
        if(gx == 7 && gy == 6) text = {1'b1, 7'd19 + 7'd26, RGB};       // s
        if(gx == 8 && gy == 6) text = {1'b1, 7'd20 + 7'd26, RGB};       // t
        if(gx == 9 && gy == 6) text = {1'b1, 7'd18 + 7'd26, RGB};       // r
        if(gx == 10 && gy == 6) text = {1'b1, 7'd15 + 7'd26, RGB};      // o
        if(gx == 11 && gy == 6) text = {1'b1, 7'd25 + 7'd26, RGB};      // y
        if(gx == 12 && gy == 6) text = {1'b1, 7'd5 + 7'd26, RGB};       // e
        if(gx == 13 && gy == 6) text = {1'b1, 7'd18 + 7'd26, RGB};      // r

        
        // Créditos: glifos 79-84 (primera línea) y 85-90 (segunda), en grande
        if(gx >= 7 && gx <= 12 && gy == 13) text = {1'b1, 7'd79 + (gx - 5'd7), WHITE};
        if(gx >= 7 && gx <= 12 && gy == 14) text = {1'b1, 7'd85 + (gx - 5'd7), WHITE};

        // Presiona 1 o 0
        if(twinkle && rst)
        begin
            if(lx == 13 && ly == 20) text = {1'b0, 7'd42, WHITE};    // P
            if(lx == 14 && ly == 20) text = {1'b0, 7'd18, WHITE};    // r
            if(lx == 15 && ly == 20) text = {1'b0, 7'd5, WHITE};     // e
            if(lx == 16 && ly == 20) text = {1'b0, 7'd19, WHITE};    // s
            if(lx == 17 && ly == 20) text = {1'b0, 7'd9, WHITE};     // i
            if(lx == 18 && ly == 20) text = {1'b0, 7'd15, WHITE};    // o
            if(lx == 19 && ly == 20) text = {1'b0, 7'd14, WHITE};    // n
            if(lx == 20 && ly == 20) text = {1'b0, 7'd1, WHITE};     // a
            if(lx == 22 && ly == 20) text = {1'b0, 7'd63, WHITE};    // 0
            if(lx == 24 && ly == 20) text = {1'b0, 7'd15, WHITE};    // o
            if(lx == 26 && ly == 20) text = {1'b0, 7'd64, WHITE};    // 1
        end

        if(~rst)
        begin
            if(lx == 14 && ly == 20) text = {1'b0, 7'd44, WHITE};    // R
            if(lx == 15 && ly == 20) text = {1'b0, 7'd5, WHITE};     // e
            if(lx == 16 && ly == 20) text = {1'b0, 7'd9, WHITE};     // i
            if(lx == 17 && ly == 20) text = {1'b0, 7'd14, WHITE};    // n
            if(lx == 18 && ly == 20) text = {1'b0, 7'd9, WHITE};     // i
            if(lx == 19 && ly == 20) text = {1'b0, 7'd3, WHITE};     // c
            if(lx == 20 && ly == 20) text = {1'b0, 7'd9, WHITE};     // i
            if(lx == 21 && ly == 20) text = {1'b0, 7'd1, WHITE};     // a
            if(lx == 22 && ly == 20) text = {1'b0, 7'd14, WHITE};    // n
            if(lx == 23 && ly == 20) text = {1'b0, 7'd4, WHITE};     // d
            if(lx == 24 && ly == 20) text = {1'b0, 7'd15, WHITE};    // o
        end
    end

    always @(posedge clk)
    begin
        counter <= counter + 1;

        if (counter == SEMI_HALF_SECOND - 1)
        begin
            counter <= 0;
            twinkle <= ~ twinkle;
        end
    end

endmodule