module topology_3_draw(
    input clk,
    input [31:0] random_config,
    input [3:0] inputs,
    input [2:0] pos,     
    input show_response,            
    input o1,
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


    wire rise = random_config[4];

    wire [3:0] tile_g1 = {1'b0, random_config[7:5]};
    wire [3:0] tile_g2 = {1'b0, random_config[11:9]};
    wire [3:0] tile_g3 = {1'b0, random_config[15:13]};
    wire [3:0] tile_g4 = {2'b10, random_config[18:17]};

    wire g1_flipflop = (random_config[7:5] == 3'd7);
    wire g2_flipflop = (random_config[11:9] == 3'd7);
    wire g3_flipflop = (random_config[15:13] == 3'd7);
    wire g4_flipflop = (random_config[18:17] >= 2'd2);     // D o T

    
    wire [2:0] c_i1 = random_config[0] ? GREEN : RED;
    wire [2:0] c_i2 = random_config[1] ? GREEN : RED;
    wire [2:0] c_i3 = random_config[2] ? GREEN : RED;
    wire [2:0] c_i4 = random_config[3] ? GREEN : RED;
    wire [2:0] c_o1 = show_response ? (o1 ? GREEN : RED) : YELLOW;

    wire [4:0] gx = hcount[9:5];    
    wire [3:0] gy = ycount[8:5];
    wire [5:0] lx = hcount[9:4];    
    wire [4:0] ly = ycount[8:4];


    always @(*)
    begin
        item = 0;
        text = 0;

        // Compuertas
        if(gx == 7 && gy == 6) item = {GATE, tile_g1, WHITE};
        if(gx == 7 && gy == 9) item = {GATE, tile_g2, WHITE};
        if(gx == 10 && gy == 7) item = {GATE, tile_g3, WHITE};
        if(gx == 12 && gy == 7) item = {GATE, tile_g4, WHITE};

        // Cables
        if(lx >= 10 && lx <= 13 && ly == 12) item = {LINE, LINE_H, c_i1};
        if(lx >= 10 && lx <= 13 && ly == 13) item = {LINE, LINE_H, c_i2};
        if(lx >= 10 && lx <= 13 && ly == 18) item = {LINE, LINE_H, c_i3};
        if(lx >= 10 && lx <= 13 && ly == 19) item = {LINE, LINE_H, c_i4};
        if(lx == 18 && ly == 14) item = {LINE, CORNER_RU, YELLOW};
        if(lx == 19 && ly == 14) item = {LINE, LINE_H, YELLOW};
        if(lx == 17 && ly >= 16 && ly <= 17) item = {LINE, LINE_V, YELLOW};
        if(lx == 17 && ly == 15) item = {LINE, CORNER_RD, YELLOW};
        if(lx >= 18 && lx <= 19 && ly == 15) item = {LINE, LINE_H, YELLOW};

        // Salida de la compuerta 1: arriba si es flip-flop, centrada si no
        if(g1_flipflop)
        begin
            if(lx >= 16 && lx <= 17 && ly == 12) item = {LINE, LINE_H, YELLOW};
            if(lx == 18 && ly == 12) item = {LINE, CORNER_LD, YELLOW};
            if(lx == 18 && ly == 13) item = {LINE, LINE_V, YELLOW};
        end
        else
        begin
            if(lx >= 16 && lx <= 17 && ly == 12) item = {HALF, HLINE_TOP, YELLOW};
            if(lx >= 16 && lx <= 17 && ly == 13) item = {HALF, HLINE_BOT, YELLOW};
            if(lx == 18 && ly == 12) item = {HALF, HSTUB_L_TOP, YELLOW};
            if(lx == 18 && ly == 13) item = {HALF, HCORNER_LD, YELLOW};
        end

        // Salida de la compuerta 2: arriba si es flip-flop, centrada si no
        if(g2_flipflop)
        begin
            if(lx == 16 && ly == 18) item = {LINE, LINE_H, YELLOW};
            if(lx == 17 && ly == 18) item = {LINE, CORNER_LU, YELLOW};
        end
        else
        begin
            if(lx == 16 && ly == 18) item = {HALF, HLINE_TOP, YELLOW};
            if(lx == 16 && ly == 19) item = {HALF, HLINE_BOT, YELLOW};
            if(lx == 17 && ly == 18) item = {HALF, HCORNER_LU, YELLOW};
            if(lx == 17 && ly == 19) item = {HALF, HSTUB_L_BOT, YELLOW};
        end

        // De la compuerta 3 a la 4: cada extremo puede estar arriba (flip-flop) o centrado
        if(g3_flipflop && g4_flipflop)
        begin
            if(lx >= 22 && lx <= 23 && ly == 14) item = {LINE, LINE_H, YELLOW};
        end
        else if(g3_flipflop)
        begin
            if(lx == 22 && ly == 14) item = {LINE, GSTEP_TOP, YELLOW};
            if(lx == 22 && ly == 15) item = {LINE, GSTEP_BOT, YELLOW};
            if(lx == 23 && ly == 14) item = {HALF, HLINE_TOP, YELLOW};
            if(lx == 23 && ly == 15) item = {HALF, HLINE_BOT, YELLOW};
        end
        else if(g4_flipflop)
        begin
            if(lx == 22 && ly == 14) item = {HALF, HSTEP_UP, YELLOW};
            if(lx == 22 && ly == 15) item = {HALF, HSTUB_L_BOT, YELLOW};
            if(lx == 23 && ly == 14) item = {LINE, LINE_H, YELLOW};
        end
        else
        begin
            if(lx >= 22 && lx <= 23 && ly == 14) item = {HALF, HLINE_TOP, YELLOW};
            if(lx >= 22 && lx <= 23 && ly == 15) item = {HALF, HLINE_BOT, YELLOW};
        end

        // Salida de la compuerta 4: arriba si es flip-flop, centrada si no
        if(g4_flipflop)
        begin
            if(lx >= 26 && lx <= 29 && ly == 14) item = {LINE, LINE_H, c_o1};
        end
        else
        begin
            if(lx >= 26 && lx <= 29 && ly == 14) item = {HALF, HLINE_TOP, c_o1};
            if(lx >= 26 && lx <= 29 && ly == 15) item = {HALF, HLINE_BOT, c_o1};
        end

        // Memoria
        if(lx == 14 && ly == 14 && g1_flipflop) text = {1'b0, Q_LEFT, WHITE};
        if(lx == 15 && ly == 14 && g1_flipflop) text = {1'b0, Q_0 + random_config[8], WHITE};
        if(lx == 14 && ly == 20 && g2_flipflop) text = {1'b0, Q_LEFT, WHITE};
        if(lx == 15 && ly == 20 && g2_flipflop) text = {1'b0, Q_0 + random_config[12], WHITE};
        if(lx == 20 && ly == 16 && g3_flipflop) text = {1'b0, Q_LEFT, WHITE};
        if(lx == 21 && ly == 16 && g3_flipflop) text = {1'b0, Q_0 + random_config[16], WHITE};
        if(lx == 24 && ly == 16 && g4_flipflop) text = {1'b0, Q_LEFT, WHITE};
        if(lx == 25 && ly == 16 && g4_flipflop) text = {1'b0, Q_0 + random_config[19], WHITE};

        // Entrada
        if(gx == 15 && gy == 7 && pos > 0)
        begin

            if(~inputs[0] == o1 && twinkle && show_response) text = {1'b1, (inputs[0]) ? ONE : ZERO, WHITE};
            else if(~show_response || inputs[0] == o1) text = {1'b1, (inputs[0]) ? ONE : ZERO, WHITE};

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
