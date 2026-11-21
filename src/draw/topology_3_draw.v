module topology_3_draw(
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

    // Tiles de línea
    localparam LINE_H = 4'd0;
    localparam LINE_V = 4'd1;
    localparam CORNER_RD = 4'd2;
    localparam CORNER_LD = 4'd3;
    localparam CORNER_RU = 4'd4;
    localparam CORNER_LU = 4'd5;

    // Colores {azul, verde, rojo}
    localparam WHITE  = 3'b111;
    localparam YELLOW = 3'b011;     
    localparam GREEN  = 3'b010;     
    localparam RED    = 3'b001;     


    wire [3:0] tile_g1 = {1'b0, random_config[7:5]};
    wire [3:0] tile_g2 = {1'b0, random_config[11:9]};
    wire [3:0] tile_g3 = {1'b0, random_config[15:13]};
    wire [3:0] tile_g4 = {2'b10, random_config[18:17]};

    
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
        if(lx >= 16 && lx <= 17 && ly == 12) item = {LINE, LINE_H, YELLOW};
        if(lx == 18 && ly == 12) item = {LINE, CORNER_LD, YELLOW};
        if(lx >= 10 && lx <= 13 && ly == 13) item = {LINE, LINE_H, c_i2};
        if(lx == 18 && ly == 13) item = {LINE, LINE_V, YELLOW};
        if(lx == 18 && ly == 14) item = {LINE, CORNER_RU, YELLOW};
        if(lx == 19 && ly == 14) item = {LINE, LINE_H, YELLOW};
        if(lx >= 22 && lx <= 23 && ly == 14) item = {LINE, LINE_H, YELLOW};
        if(lx >= 26 && lx <= 29 && ly == 14) item = {LINE, LINE_H, c_o1};
        if(lx == 17 && ly == 15) item = {LINE, CORNER_RD, YELLOW};
        if(lx >= 18 && lx <= 19 && ly == 15) item = {LINE, LINE_H, YELLOW};
        if(lx == 17 && ly >= 16 && ly <= 17) item = {LINE, LINE_V, YELLOW};
        if(lx >= 10 && lx <= 13 && ly == 18) item = {LINE, LINE_H, c_i3};
        if(lx == 16 && ly == 18) item = {LINE, LINE_H, YELLOW};
        if(lx == 17 && ly == 18) item = {LINE, CORNER_LU, YELLOW};
        if(lx >= 10 && lx <= 13 && ly == 19) item = {LINE, LINE_H, c_i4};

        // Entrada
        if(gx == 15 && gy == 7 && pos > 0) text = {1'b1, (inputs[0]) ? ONE : ZERO, WHITE};

    end


endmodule
