module topology_4_draw(
    input clk,
    input [31:0] random_config,
    input [3:0] inputs,
    input [2:0] pos,     
    input show_response,            
    input o1, o2,
    input [9:0] hcount, ycount,

    output reg [8:0] item,           // El render se encargará xD 
    output reg [10:0] text
);

    // Tipo de elemento
    localparam GATE = 2'd1;         
    localparam LINE = 2'd2;   
    localparam ONE = 7'd64;
    localparam ZERO = 7'd63;          
    localparam Q_LEFT = 7'd117;     // "Q" y la mitad izquierda del "="
    localparam Q_0 = 7'd118;        // Mitad derecha del "=" y el 0 (119 con el 1)
    localparam RISE  = 4'd12;       // Flanco de bajada (13 el de subida)
    localparam CLK = 7'd116;        // Texto "CLK" en un solo glifo

    // Tiles de línea
    localparam LINE_H = 4'd0;
    localparam LINE_V = 4'd1;
    localparam CORNER_RD = 4'd2;
    localparam CORNER_LD = 4'd3;
    localparam CORNER_RU = 4'd4;
    localparam CORNER_LU = 4'd5;
    localparam TEE_D = 4'd7;

    localparam GSTEP_TOP = 4'd11;   // Escalón que baja de la fila del cable a media altura
    localparam GSTEP_BOT = 4'd12;   // Mitad de abajo de ese escalón

    // Tiles de media altura: el cable va entre dos celdas, a la altura de la salida centrada
    localparam HALF = 2'd3;
    localparam HLINE_TOP = 4'd0;
    localparam HLINE_BOT = 4'd1;
    localparam HSTUB_L_TOP = 4'd2;
    localparam HSTUB_L_BOT = 4'd3;
    localparam HSTEP_UP = 4'd8;
    localparam HCORNER_LU = 4'd4;
    localparam HCORNER_LD = 4'd5;
    localparam HSTEP_DOWN = 4'd9;
    localparam HTEE_D_TOP = 4'd12;
    localparam HTEE_D_BOT = 4'd13;

    // Colores {azul, verde, rojo}
    localparam WHITE  = 3'b111;
    localparam YELLOW = 3'b011;     
    localparam GREEN  = 3'b010;     
    localparam RED    = 3'b001;     
    localparam CYAN   = 3'b110;     // Reloj

    localparam SEMI_HALF_SECOND = 50_000_000 / 4; // Valor de agonización


    // Variables Agonizantes
    reg twinkle = 0;
    reg [23:0] counter = 0;

    
    wire rise = random_config[5];

    wire [3:0] tile_g1 = {2'b10, random_config[7:6]};
    wire [3:0] tile_g2 = {1'b0, random_config[11:9]};
    wire [3:0] tile_g3 = {1'b0, random_config[15:13]};
    wire [3:0] tile_g4 = {1'b0, random_config[19:17]};
    wire [3:0] tile_g5 = {2'b10, random_config[22:21]};
    wire [3:0] tile_g6 = {1'b0, random_config[26:24]};

    wire g1_flipflop = (random_config[7:6] >= 2'd2);     // D o T
    wire g2_flipflop = (random_config[11:9] == 3'd7);
    wire g3_flipflop = (random_config[15:13] == 3'd7);
    wire g4_flipflop = (random_config[19:17] == 3'd7);
    wire g5_flipflop = (random_config[22:21] >= 2'd2);     // D o T
    wire g6_flipflop = (random_config[26:24] == 3'd7);

    
    wire [2:0] c_i1 = random_config[0] ? GREEN : RED;
    wire [2:0] c_i2 = random_config[1] ? GREEN : RED;
    wire [2:0] c_i3 = random_config[2] ? GREEN : RED;
    wire [2:0] c_i4 = random_config[3] ? GREEN : RED;
    wire [2:0] c_i5 = random_config[4] ? GREEN : RED;
    wire [2:0] c_o1 = show_response ? (o1 ? GREEN : RED) : YELLOW;
    wire [2:0] c_o2 = show_response ? (o2 ? GREEN : RED) : YELLOW;

    wire [4:0] gx = hcount[9:5];    
    wire [3:0] gy = ycount[8:5];
    wire [5:0] lx = hcount[9:4];    
    wire [4:0] ly = ycount[8:4];


    always @(*)
    begin
        item = 0;
        text = 0;

        // Compuertas
        if(gx == 6 && gy == 4) item = {GATE, tile_g1, WHITE};
        if(gx == 6 && gy == 6) item = {GATE, tile_g2, WHITE};
        if(gx == 6 && gy == 9) item = {GATE, tile_g3, WHITE};
        if(gx == 10 && gy == 5) item = {GATE, tile_g4, WHITE};
        if(gx == 13 && gy == 5) item = {GATE, tile_g5, WHITE};
        if(gx == 13 && gy == 9) item = {GATE, tile_g6, WHITE};

        // Cables
        if(lx >= 8 && lx <= 11 && ly == 12) item = {LINE, LINE_H, c_i2};
        if(lx >= 8 && lx <= 11 && ly == 13) item = {LINE, LINE_H, c_i3};
        if(lx >= 8 && lx <= 11 && ly == 18) item = {LINE, LINE_H, c_i4};
        if(lx >= 8 && lx <= 11 && ly == 19) item = {LINE, LINE_H, c_i5};
        if(lx == 17 && ly == 10) item = {LINE, CORNER_RU, YELLOW};
        if(lx >= 18 && lx <= 19 && ly == 10) item = {LINE, LINE_H, YELLOW};
        if(lx == 15 && ly == 11) item = {LINE, CORNER_RD, YELLOW};
        if(lx >= 16 && lx <= 19 && ly == 11) item = {LINE, LINE_H, YELLOW};
        if(lx == 23 && ly >= 12 && ly <= 17) item = {LINE, LINE_V, YELLOW};
        if(lx == 23 && ly == 18) item = {LINE, CORNER_RU, YELLOW};
        if(lx >= 24 && lx <= 25 && ly == 18) item = {LINE, LINE_H, YELLOW};
        if(lx >= 16 && lx <= 25 && ly == 19) item = {LINE, LINE_H, YELLOW};

        // Entrada de la compuerta 1: arriba si es flip-flop, centrada si no
        if(g1_flipflop)
        begin
            if(lx >= 8 && lx <= 11 && ly == 8) item = {LINE, LINE_H, c_i1};
        end
        else
        begin
            if(lx >= 8 && lx <= 11 && ly == 8) item = {HALF, HLINE_TOP, c_i1};
            if(lx >= 8 && lx <= 11 && ly == 9) item = {HALF, HLINE_BOT, c_i1};
        end

        // Salida de la compuerta 1: arriba si es flip-flop, centrada si no
        if(g1_flipflop)
        begin
            if(lx >= 14 && lx <= 16 && ly == 8) item = {LINE, LINE_H, YELLOW};
            if(lx == 17 && ly == 8) item = {LINE, CORNER_LD, YELLOW};
            if(lx == 17 && ly == 9) item = {LINE, LINE_V, YELLOW};
        end
        else
        begin
            if(lx >= 14 && lx <= 16 && ly == 8) item = {HALF, HLINE_TOP, YELLOW};
            if(lx >= 14 && lx <= 16 && ly == 9) item = {HALF, HLINE_BOT, YELLOW};
            if(lx == 17 && ly == 8) item = {HALF, HSTUB_L_TOP, YELLOW};
            if(lx == 17 && ly == 9) item = {HALF, HCORNER_LD, YELLOW};
        end

        // Salida de la compuerta 2: arriba si es flip-flop, centrada si no
        if(g2_flipflop)
        begin
            if(lx == 14 && ly == 12) item = {LINE, LINE_H, YELLOW};
            if(lx == 15 && ly == 12) item = {LINE, CORNER_LU, YELLOW};
        end
        else
        begin
            if(lx == 14 && ly == 12) item = {HALF, HLINE_TOP, YELLOW};
            if(lx == 14 && ly == 13) item = {HALF, HLINE_BOT, YELLOW};
            if(lx == 15 && ly == 12) item = {HALF, HCORNER_LU, YELLOW};
            if(lx == 15 && ly == 13) item = {HALF, HSTUB_L_BOT, YELLOW};
        end

        // Salida de la compuerta 3: arriba si es flip-flop, centrada si no
        if(g3_flipflop)
        begin
            if(lx == 14 && ly == 18) item = {LINE, LINE_H, YELLOW};
            if(lx == 15 && ly == 18) item = {LINE, CORNER_LD, YELLOW};
            if(lx == 15 && ly == 19) item = {LINE, CORNER_RU, YELLOW};
        end
        else
        begin
            if(lx == 14 && ly == 18) item = {HALF, HLINE_TOP, YELLOW};
            if(lx == 14 && ly == 19) item = {HALF, HLINE_BOT, YELLOW};
            if(lx == 15 && ly == 18) item = {HALF, HSTUB_L_TOP, YELLOW};
            if(lx == 15 && ly == 19) item = {HALF, HSTEP_DOWN, YELLOW};
        end

        // Salida de la compuerta 4: arriba si es flip-flop, centrada si no (con la bifurcación hacia abajo)
        if(g4_flipflop)
        begin
            if(lx == 22 && ly == 10) item = {LINE, LINE_H, YELLOW};
            if(lx == 23 && ly == 10) item = {LINE, TEE_D, YELLOW};
            if(lx == 23 && ly == 11) item = {LINE, LINE_V, YELLOW};
        end
        else
        begin
            if(lx == 22 && ly == 10) item = {HALF, HLINE_TOP, YELLOW};
            if(lx == 22 && ly == 11) item = {HALF, HLINE_BOT, YELLOW};
            if(lx == 23 && ly == 10) item = {HALF, HTEE_D_TOP, YELLOW};
            if(lx == 23 && ly == 11) item = {HALF, HTEE_D_BOT, YELLOW};
        end

        // De la compuerta 4 a la 5: cada extremo puede estar arriba (flip-flop) o centrado
        if(g4_flipflop && g5_flipflop)
        begin
            if(lx >= 24 && lx <= 25 && ly == 10) item = {LINE, LINE_H, YELLOW};
        end
        else if(g4_flipflop)
        begin
            if(lx == 24 && ly == 10) item = {LINE, GSTEP_TOP, YELLOW};
            if(lx == 24 && ly == 11) item = {LINE, GSTEP_BOT, YELLOW};
            if(lx == 25 && ly == 10) item = {HALF, HLINE_TOP, YELLOW};
            if(lx == 25 && ly == 11) item = {HALF, HLINE_BOT, YELLOW};
        end
        else if(g5_flipflop)
        begin
            if(lx == 24 && ly == 10) item = {HALF, HSTEP_UP, YELLOW};
            if(lx == 24 && ly == 11) item = {HALF, HSTUB_L_BOT, YELLOW};
            if(lx == 25 && ly == 10) item = {LINE, LINE_H, YELLOW};
        end
        else
        begin
            if(lx >= 24 && lx <= 25 && ly == 10) item = {HALF, HLINE_TOP, YELLOW};
            if(lx >= 24 && lx <= 25 && ly == 11) item = {HALF, HLINE_BOT, YELLOW};
        end

        // Salida de la compuerta 5: arriba si es flip-flop, centrada si no
        if(g5_flipflop)
        begin
            if(lx >= 28 && lx <= 31 && ly == 10) item = {LINE, LINE_H, c_o1};
        end
        else
        begin
            if(lx >= 28 && lx <= 31 && ly == 10) item = {HALF, HLINE_TOP, c_o1};
            if(lx >= 28 && lx <= 31 && ly == 11) item = {HALF, HLINE_BOT, c_o1};
        end

        // Salida de la compuerta 6: arriba si es flip-flop, centrada si no
        if(g6_flipflop)
        begin
            if(lx >= 28 && lx <= 31 && ly == 18) item = {LINE, LINE_H, c_o2};
        end
        else
        begin
            if(lx >= 28 && lx <= 31 && ly == 18) item = {HALF, HLINE_TOP, c_o2};
            if(lx >= 28 && lx <= 31 && ly == 19) item = {HALF, HLINE_BOT, c_o2};
        end

        // Memoria
        if(lx == 12 && ly == 10 && g1_flipflop) text = {1'b0, Q_LEFT, WHITE};
        if(lx == 13 && ly == 10 && g1_flipflop) text = {1'b0, Q_0 + random_config[8], WHITE};
        if(lx == 12 && ly == 14 && g2_flipflop) text = {1'b0, Q_LEFT, WHITE};
        if(lx == 13 && ly == 14 && g2_flipflop) text = {1'b0, Q_0 + random_config[12], WHITE};
        if(lx == 12 && ly == 20 && g3_flipflop) text = {1'b0, Q_LEFT, WHITE};
        if(lx == 13 && ly == 20 && g3_flipflop) text = {1'b0, Q_0 + random_config[16], WHITE};
        if(lx == 20 && ly == 12 && g4_flipflop) text = {1'b0, Q_LEFT, WHITE};
        if(lx == 21 && ly == 12 && g4_flipflop) text = {1'b0, Q_0 + random_config[20], WHITE};
        if(lx == 26 && ly == 12 && g5_flipflop) text = {1'b0, Q_LEFT, WHITE};
        if(lx == 27 && ly == 12 && g5_flipflop) text = {1'b0, Q_0 + random_config[23], WHITE};
        if(lx == 26 && ly == 20 && g6_flipflop) text = {1'b0, Q_LEFT, WHITE};
        if(lx == 27 && ly == 20 && g6_flipflop) text = {1'b0, Q_0 + random_config[27], WHITE};

        // Entrada
        if(gx == 16 && gy == 5 && pos > 0) 
        begin

            if(~inputs[0] == o1 && twinkle && show_response) text = {1'b1, (inputs[0]) ? ONE : ZERO, WHITE};
            else if(~show_response || inputs[0] == o1) text = {1'b1, (inputs[0]) ? ONE : ZERO, WHITE};

        end

        if(gx == 16 && gy == 9 && pos > 1) 
        begin

            if(~inputs[1] == o2 && twinkle && show_response) text = {1'b1, (inputs[1]) ? ONE : ZERO, WHITE};
            else if(~show_response || inputs[1] == o2) text = {1'b1, (inputs[1]) ? ONE : ZERO, WHITE};

        end

        // Flanco
        if(gx == 17 && gy == 2) item = {GATE, RISE + rise, CYAN};
        if(gx == 16 && gy == 2) text = {1'b1, CLK, WHITE};
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
