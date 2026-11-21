module topology_1_draw(
    input [31:0] random_config,
    input [3:0] inputs,
    input [2:0] pos,
    input show_response,
    input [9:0] hcount, ycount,
    input o1,

    output reg [8:0] item,       // El tile render se encargará xD
    output reg [10:0] text
);


    localparam GATE = 2'd1;         
    localparam LINE = 2'd2;
    localparam ONE = 7'd64;
    localparam ZERO = 7'd63;        


    // Tiles de línea
    localparam LINE_H = 4'd0;
    localparam LINE_V = 4'd1;
    localparam CORNER_LD = 4'd3;
    localparam CORNER_RU = 4'd4;


    // Colores {azul, verde, rojo}
    localparam WHITE  = 3'b111;
    localparam YELLOW = 3'b011;     // Valor a deducir o conexión entre compuertas
    localparam GREEN  = 3'b010;     // Cable en 1
    localparam RED    = 3'b001;     // Cable en 0



    wire [3:0] tile_g1 = {1'b0, random_config[15:13]};
    wire [3:0] tile_g2 = {1'b0, random_config[12:10]};

    // Colores de los cables
    wire [2:0] c_i1 = random_config[7] ? GREEN : RED;
    wire [2:0] c_i2 = random_config[6] ? GREEN : RED;
    wire [2:0] c_i3 = random_config[5] ? GREEN : RED;
    wire [2:0] c_o1 = show_response ? (o1 ? GREEN : RED) : YELLOW;

    // Posiciones
    wire [4:0] gx = hcount[9:5];
    wire [3:0] gy = ycount[8:5];
    wire [5:0] lx = hcount[9:4];
    wire [4:0] ly = ycount[8:4];

    
    always @(*)
    begin
        item = 0;
        text = 0;

        // Compuertas
        if(gx == 9 && gy == 6) item = {GATE, tile_g1, WHITE};
        if(gx == 11 && gy == 8) item = {GATE, tile_g2, WHITE};

        // Cables
        if(lx >= 14 && lx <= 17 && ly == 12) item = {LINE, LINE_H, c_i1};
        if(lx == 20 && ly == 12) item = {LINE, LINE_H, YELLOW};
        if(lx == 21 && ly == 12) item = {LINE, CORNER_LD, YELLOW};
        if(lx >= 14 && lx <= 17 && ly == 13) item = {LINE, LINE_H, c_i2};
        if(lx == 21 && ly >= 13 && ly <= 15) item = {LINE, LINE_V, YELLOW};
        if(lx == 21 && ly == 16) item = {LINE, CORNER_RU, YELLOW};
        if(lx >= 24 && lx <= 27 && ly == 16) item = {LINE, LINE_H, c_o1};
        if(lx >= 14 && lx <= 21 && ly == 17) item = {LINE, LINE_H, c_i3};

        if(gx == 14 && gy == 8 && pos > 0) text = {1'b1, (inputs[0]) ? ONE : ZERO, WHITE};
    end

    
endmodule