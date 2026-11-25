
module rules_draw(
    input clk,
    input [9:0] hcount, ycount,

    output reg [8:0] item,
    output reg [10:0] text
);

    localparam GATE = 2'd1;
    localparam LINE = 2'd2;
    localparam LINE_H = 4'd0;
    localparam JK = 4'd7;           
    localparam RISE = 4'd13;        
    localparam ONE = 7'd64;
    localparam ZERO = 7'd63;
    localparam CLK = 7'd116;        

    // Colores {azul, verde, rojo}
    localparam WHITE  = 3'b111;
    localparam GREEN  = 3'b010;
    localparam RED    = 3'b001;
    localparam CYAN   = 3'b110;
    localparam RGB    = 3'b000;     
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

        // Título, con efecto RGB
        if(gx == 1 && gy == 1) text = {1'b1, 7'd44, RGB};     // R
        if(gx == 2 && gy == 1) text = {1'b1, 7'd31, RGB};     // E
        if(gx == 3 && gy == 1) text = {1'b1, 7'd33, RGB};     // G
        if(gx == 4 && gy == 1) text = {1'b1, 7'd38, RGB};     // L
        if(gx == 5 && gy == 1) text = {1'b1, 7'd27, RGB};     // A
        if(gx == 6 && gy == 1) text = {1'b1, 7'd45, RGB};     // S

        // Bienvenida
        if(lx == 2 && ly == 6) text = {1'b0, 7'd28, WHITE};     // B
        if(lx == 3 && ly == 6) text = {1'b0, 7'd9, WHITE};      // i
        if(lx == 4 && ly == 6) text = {1'b0, 7'd5, WHITE};      // e
        if(lx == 5 && ly == 6) text = {1'b0, 7'd14, WHITE};     // n
        if(lx == 6 && ly == 6) text = {1'b0, 7'd22, WHITE};     // v
        if(lx == 7 && ly == 6) text = {1'b0, 7'd5, WHITE};      // e
        if(lx == 8 && ly == 6) text = {1'b0, 7'd14, WHITE};     // n
        if(lx == 9 && ly == 6) text = {1'b0, 7'd9, WHITE};      // i
        if(lx == 10 && ly == 6) text = {1'b0, 7'd4, WHITE};     // d
        if(lx == 11 && ly == 6) text = {1'b0, 7'd15, WHITE};     // o

        // Colores de los cables
        if(lx == 2 && ly == 9) text = {1'b0, 7'd38, WHITE};     // L
        if(lx == 3 && ly == 9) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 4 && ly == 9) text = {1'b0, 7'd19, WHITE};     // s
        if(lx == 6 && ly == 9) text = {1'b0, 7'd3, WHITE};      // c
        if(lx == 7 && ly == 9) text = {1'b0, 7'd1, WHITE};      // a
        if(lx == 8 && ly == 9) text = {1'b0, 7'd2, WHITE};      // b
        if(lx == 9 && ly == 9) text = {1'b0, 7'd12, WHITE};     // l
        if(lx == 10 && ly == 9) text = {1'b0, 7'd5, WHITE};     // e
        if(lx == 11 && ly == 9) text = {1'b0, 7'd19, WHITE};     // s
        if(lx == 13 && ly == 9) text = {1'b0, 7'd18, WHITE};     // r
        if(lx == 14 && ly == 9) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 15 && ly == 9) text = {1'b0, 7'd10, WHITE};     // j
        if(lx == 16 && ly == 9) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 17 && ly == 9) text = {1'b0, 7'd19, WHITE};     // s
        if(lx == 19 && ly == 9) text = {1'b0, 7'd19, WHITE};     // s
        if(lx == 20 && ly == 9) text = {1'b0, 7'd9, WHITE};     // i
        if(lx == 21 && ly == 9) text = {1'b0, 7'd7, WHITE};     // g
        if(lx == 22 && ly == 9) text = {1'b0, 7'd14, WHITE};     // n
        if(lx == 23 && ly == 9) text = {1'b0, 7'd9, WHITE};     // i
        if(lx == 24 && ly == 9) text = {1'b0, 7'd6, WHITE};     // f
        if(lx == 25 && ly == 9) text = {1'b0, 7'd9, WHITE};     // i
        if(lx == 26 && ly == 9) text = {1'b0, 7'd3, WHITE};     // c
        if(lx == 27 && ly == 9) text = {1'b0, 7'd1, WHITE};     // a
        if(lx == 28 && ly == 9) text = {1'b0, 7'd14, WHITE};     // n
        if(lx == 30 && ly == 9) text = {1'b0, 7'd3, WHITE};     // c
        if(lx == 31 && ly == 9) text = {1'b0, 7'd5, WHITE};     // e
        if(lx == 32 && ly == 9) text = {1'b0, 7'd18, WHITE};     // r
        if(lx == 33 && ly == 9) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 34 && ly == 9) text = {1'b0, 7'd19, WHITE};     // s

        if(lx == 2 && ly == 10) text = {1'b0, 7'd25, WHITE};     // y
        if(lx == 4 && ly == 10) text = {1'b0, 7'd12, WHITE};     // l
        if(lx == 5 && ly == 10) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 6 && ly == 10) text = {1'b0, 7'd19, WHITE};     // s
        if(lx == 8 && ly == 10) text = {1'b0, 7'd22, WHITE};     // v
        if(lx == 9 && ly == 10) text = {1'b0, 7'd5, WHITE};      // e
        if(lx == 10 && ly == 10) text = {1'b0, 7'd18, WHITE};     // r
        if(lx == 11 && ly == 10) text = {1'b0, 7'd4, WHITE};     // d
        if(lx == 12 && ly == 10) text = {1'b0, 7'd5, WHITE};     // e
        if(lx == 13 && ly == 10) text = {1'b0, 7'd19, WHITE};     // s
        if(lx == 15 && ly == 10) text = {1'b0, 7'd21, WHITE};     // u
        if(lx == 16 && ly == 10) text = {1'b0, 7'd14, WHITE};     // n
        if(lx == 17 && ly == 10) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 18 && ly == 10) text = {1'b0, 7'd19, WHITE};     // s
        if(lx == 19 && ly == 10) text = {1'b0, 7'd74, WHITE};     // .

        // Dibujo: un cable rojo con su 0 y uno verde con su 1
        if(lx >= 4 && lx <= 7 && ly == 12) item = {LINE, LINE_H, RED};
        if(lx == 9 && ly == 12) text = {1'b0, ZERO, RED};
        if(lx >= 14 && lx <= 17 && ly == 12) item = {LINE, LINE_H, GREEN};
        if(lx == 19 && ly == 12) text = {1'b0, ONE, GREEN};

        // Flip-flop JK de ejemplo, delante de su texto
        if(gx == 1 && gy == 7) item = {GATE, JK, WHITE};

        // Flip-flops
        if(lx == 7 && ly == 14) text = {1'b0, 7'd46, WHITE};     // T
        if(lx == 8 && ly == 14) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 9 && ly == 14) text = {1'b0, 7'd4, WHITE};      // d
        if(lx == 10 && ly == 14) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 11 && ly == 14) text = {1'b0, 7'd19, WHITE};     // s
        if(lx == 13 && ly == 14) text = {1'b0, 7'd12, WHITE};     // l
        if(lx == 14 && ly == 14) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 15 && ly == 14) text = {1'b0, 7'd19, WHITE};     // s
        if(lx == 17 && ly == 14) text = {1'b0, 7'd6, WHITE};     // f
        if(lx == 18 && ly == 14) text = {1'b0, 7'd12, WHITE};     // l
        if(lx == 19 && ly == 14) text = {1'b0, 7'd9, WHITE};     // i
        if(lx == 20 && ly == 14) text = {1'b0, 7'd16, WHITE};     // p
        if(lx == 22 && ly == 14) text = {1'b0, 7'd6, WHITE};     // f
        if(lx == 23 && ly == 14) text = {1'b0, 7'd12, WHITE};     // l
        if(lx == 24 && ly == 14) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 25 && ly == 14) text = {1'b0, 7'd16, WHITE};     // p
        if(lx == 26 && ly == 14) text = {1'b0, 7'd19, WHITE};     // s
        if(lx == 28 && ly == 14) text = {1'b0, 7'd6, WHITE};     // f
        if(lx == 29 && ly == 14) text = {1'b0, 7'd21, WHITE};     // u
        if(lx == 30 && ly == 14) text = {1'b0, 7'd14, WHITE};     // n
        if(lx == 31 && ly == 14) text = {1'b0, 7'd3, WHITE};     // c
        if(lx == 32 && ly == 14) text = {1'b0, 7'd9, WHITE};     // i
        if(lx == 33 && ly == 14) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 34 && ly == 14) text = {1'b0, 7'd14, WHITE};     // n
        if(lx == 35 && ly == 14) text = {1'b0, 7'd1, WHITE};     // a
        if(lx == 36 && ly == 14) text = {1'b0, 7'd14, WHITE};     // n

        if(lx == 7 && ly == 15) text = {1'b0, 7'd16, WHITE};     // p
        if(lx == 8 && ly == 15) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 9 && ly == 15) text = {1'b0, 7'd18, WHITE};     // r
        if(lx == 11 && ly == 15) text = {1'b0, 7'd6, WHITE};     // f
        if(lx == 12 && ly == 15) text = {1'b0, 7'd12, WHITE};     // l
        if(lx == 13 && ly == 15) text = {1'b0, 7'd1, WHITE};     // a
        if(lx == 14 && ly == 15) text = {1'b0, 7'd14, WHITE};     // n
        if(lx == 15 && ly == 15) text = {1'b0, 7'd3, WHITE};     // c
        if(lx == 16 && ly == 15) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 18 && ly == 15) text = {1'b0, 7'd4, WHITE};     // d
        if(lx == 19 && ly == 15) text = {1'b0, 7'd5, WHITE};     // e
        if(lx == 21 && ly == 15) text = {1'b0, 7'd19, WHITE};     // s
        if(lx == 22 && ly == 15) text = {1'b0, 7'd21, WHITE};     // u
        if(lx == 23 && ly == 15) text = {1'b0, 7'd2, WHITE};     // b
        if(lx == 24 && ly == 15) text = {1'b0, 7'd9, WHITE};     // i
        if(lx == 25 && ly == 15) text = {1'b0, 7'd4, WHITE};     // d
        if(lx == 26 && ly == 15) text = {1'b0, 7'd1, WHITE};     // a
        if(lx == 27 && ly == 15) text = {1'b0, 7'd74, WHITE};     // .

        // Reloj como aparece en las topologías, delante de su texto
        if(gx == 1 && gy == 9) text = {1'b1, CLK, WHITE};
        if(gx == 2 && gy == 9) item = {GATE, RISE, CYAN};

        // Reloj
        if(lx == 7 && ly == 18) text = {1'b0, 7'd31, WHITE};     // E
        if(lx == 8 && ly == 18) text = {1'b0, 7'd14, WHITE};     // n
        if(lx == 10 && ly == 18) text = {1'b0, 7'd3, WHITE};     // c
        if(lx == 11 && ly == 18) text = {1'b0, 7'd1, WHITE};     // a
        if(lx == 12 && ly == 18) text = {1'b0, 7'd4, WHITE};     // d
        if(lx == 13 && ly == 18) text = {1'b0, 7'd1, WHITE};     // a
        if(lx == 15 && ly == 18) text = {1'b0, 7'd18, WHITE};     // r
        if(lx == 16 && ly == 18) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 17 && ly == 18) text = {1'b0, 7'd14, WHITE};     // n
        if(lx == 18 && ly == 18) text = {1'b0, 7'd4, WHITE};     // d
        if(lx == 19 && ly == 18) text = {1'b0, 7'd1, WHITE};     // a
        if(lx == 21 && ly == 18) text = {1'b0, 7'd5, WHITE};     // e
        if(lx == 22 && ly == 18) text = {1'b0, 7'd12, WHITE};     // l
        if(lx == 24 && ly == 18) text = {1'b0, 7'd6, WHITE};     // f
        if(lx == 25 && ly == 18) text = {1'b0, 7'd12, WHITE};     // l
        if(lx == 26 && ly == 18) text = {1'b0, 7'd1, WHITE};     // a
        if(lx == 27 && ly == 18) text = {1'b0, 7'd14, WHITE};     // n
        if(lx == 28 && ly == 18) text = {1'b0, 7'd3, WHITE};     // c
        if(lx == 29 && ly == 18) text = {1'b0, 7'd15, WHITE};     // o

        if(lx == 7 && ly == 19) text = {1'b0, 7'd19, WHITE};     // s
        if(lx == 8 && ly == 19) text = {1'b0, 7'd5, WHITE};      // e
        if(lx == 10 && ly == 19) text = {1'b0, 7'd9, WHITE};     // i
        if(lx == 11 && ly == 19) text = {1'b0, 7'd14, WHITE};     // n
        if(lx == 12 && ly == 19) text = {1'b0, 7'd4, WHITE};     // d
        if(lx == 13 && ly == 19) text = {1'b0, 7'd9, WHITE};     // i
        if(lx == 14 && ly == 19) text = {1'b0, 7'd3, WHITE};     // c
        if(lx == 15 && ly == 19) text = {1'b0, 7'd1, WHITE};     // a
        if(lx == 17 && ly == 19) text = {1'b0, 7'd3, WHITE};     // c
        if(lx == 18 && ly == 19) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 19 && ly == 19) text = {1'b0, 7'd14, WHITE};     // n
        if(lx == 21 && ly == 19) text = {1'b0, 7'd5, WHITE};     // e
        if(lx == 22 && ly == 19) text = {1'b0, 7'd12, WHITE};     // l
        if(lx == 24 && ly == 19) text = {1'b0, 7'd18, WHITE};     // r
        if(lx == 25 && ly == 19) text = {1'b0, 7'd5, WHITE};     // e
        if(lx == 26 && ly == 19) text = {1'b0, 7'd12, WHITE};     // l
        if(lx == 27 && ly == 19) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 28 && ly == 19) text = {1'b0, 7'd10, WHITE};     // j
        if(lx == 29 && ly == 19) text = {1'b0, 7'd74, WHITE};     // .

        // Cero de ejemplo que titila, delante de su texto
        if(gx == 1 && gy == 11 && twinkle) text = {1'b1, ZERO, WHITE};

        // Respuesta incorrecta
        if(lx == 7 && ly == 22) text = {1'b0, 7'd45, WHITE};     // S
        if(lx == 8 && ly == 22) text = {1'b0, 7'd9, WHITE};      // i
        if(lx == 10 && ly == 22) text = {1'b0, 7'd12, WHITE};     // l
        if(lx == 11 && ly == 22) text = {1'b0, 7'd1, WHITE};     // a
        if(lx == 13 && ly == 22) text = {1'b0, 7'd19, WHITE};     // s
        if(lx == 14 && ly == 22) text = {1'b0, 7'd1, WHITE};     // a
        if(lx == 15 && ly == 22) text = {1'b0, 7'd12, WHITE};     // l
        if(lx == 16 && ly == 22) text = {1'b0, 7'd9, WHITE};     // i
        if(lx == 17 && ly == 22) text = {1'b0, 7'd4, WHITE};     // d
        if(lx == 18 && ly == 22) text = {1'b0, 7'd1, WHITE};     // a
        if(lx == 20 && ly == 22) text = {1'b0, 7'd20, WHITE};     // t
        if(lx == 21 && ly == 22) text = {1'b0, 7'd9, WHITE};     // i
        if(lx == 22 && ly == 22) text = {1'b0, 7'd20, WHITE};     // t
        if(lx == 23 && ly == 22) text = {1'b0, 7'd9, WHITE};     // i
        if(lx == 24 && ly == 22) text = {1'b0, 7'd12, WHITE};     // l
        if(lx == 25 && ly == 22) text = {1'b0, 7'd1, WHITE};     // a
        if(lx == 27 && ly == 22) text = {1'b0, 7'd5, WHITE};     // e
        if(lx == 28 && ly == 22) text = {1'b0, 7'd19, WHITE};     // s
        if(lx == 30 && ly == 22) text = {1'b0, 7'd16, WHITE};     // p
        if(lx == 31 && ly == 22) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 32 && ly == 22) text = {1'b0, 7'd18, WHITE};     // r
        if(lx == 33 && ly == 22) text = {1'b0, 7'd17, WHITE};     // q
        if(lx == 34 && ly == 22) text = {1'b0, 7'd21, WHITE};     // u
        if(lx == 35 && ly == 22) text = {1'b0, 7'd5, WHITE};     // e

        if(lx == 7 && ly == 23) text = {1'b0, 7'd5, WHITE};      // e
        if(lx == 8 && ly == 23) text = {1'b0, 7'd19, WHITE};     // s
        if(lx == 10 && ly == 23) text = {1'b0, 7'd9, WHITE};     // i
        if(lx == 11 && ly == 23) text = {1'b0, 7'd14, WHITE};     // n
        if(lx == 12 && ly == 23) text = {1'b0, 7'd3, WHITE};     // c
        if(lx == 13 && ly == 23) text = {1'b0, 7'd15, WHITE};     // o
        if(lx == 14 && ly == 23) text = {1'b0, 7'd18, WHITE};     // r
        if(lx == 15 && ly == 23) text = {1'b0, 7'd18, WHITE};     // r
        if(lx == 16 && ly == 23) text = {1'b0, 7'd5, WHITE};     // e
        if(lx == 17 && ly == 23) text = {1'b0, 7'd3, WHITE};     // c
        if(lx == 18 && ly == 23) text = {1'b0, 7'd20, WHITE};     // t
        if(lx == 19 && ly == 23) text = {1'b0, 7'd1, WHITE};     // a
        if(lx == 20 && ly == 23) text = {1'b0, 7'd74, WHITE};     // .

    end

    // Parpadeo del cero, igual que en round_draw
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