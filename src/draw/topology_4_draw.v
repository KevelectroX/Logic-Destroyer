module topology_4_draw(
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

    // Tiles de línea
    localparam LINE_H = 4'd0;
    localparam LINE_V = 4'd1;
    localparam CORNER_RD = 4'd2;
    localparam CORNER_LD = 4'd3;
    localparam CORNER_RU = 4'd4;
    localparam CORNER_LU = 4'd5;
    localparam TEE_D = 4'd7;

    // Colores {azul, verde, rojo}
    localparam WHITE  = 3'b111;
    localparam YELLOW = 3'b011;     
    localparam GREEN  = 3'b010;     
    localparam RED    = 3'b001;     

    
    wire [3:0] tile_g1 = {2'b10, random_config[7:6]};
    wire [3:0] tile_g2 = {1'b0, random_config[11:9]};
    wire [3:0] tile_g3 = {1'b0, random_config[15:13]};
    wire [3:0] tile_g4 = {1'b0, random_config[19:17]};
    wire [3:0] tile_g5 = {2'b10, random_config[22:21]};
    wire [3:0] tile_g6 = {1'b0, random_config[26:24]};

    
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
        if(lx >= 8 && lx <= 11 && ly == 8) item = {LINE, LINE_H, c_i1};
        if(lx >= 14 && lx <= 16 && ly == 8) item = {LINE, LINE_H, YELLOW};
        if(lx == 17 && ly == 8) item = {LINE, CORNER_LD, YELLOW};
        if(lx == 17 && ly == 9) item = {LINE, LINE_V, YELLOW};
        if(lx == 17 && ly == 10) item = {LINE, CORNER_RU, YELLOW};
        if(lx >= 18 && lx <= 19 && ly == 10) item = {LINE, LINE_H, YELLOW};
        if(lx == 22 && ly == 10) item = {LINE, LINE_H, YELLOW};
        if(lx == 23 && ly == 10) item = {LINE, TEE_D, YELLOW};
        if(lx >= 24 && lx <= 25 && ly == 10) item = {LINE, LINE_H, YELLOW};
        if(lx >= 28 && lx <= 31 && ly == 10) item = {LINE, LINE_H, c_o1};
        if(lx == 15 && ly == 11) item = {LINE, CORNER_RD, YELLOW};
        if(lx >= 16 && lx <= 19 && ly == 11) item = {LINE, LINE_H, YELLOW};
        if(lx == 23 && ly >= 11 && ly <= 17) item = {LINE, LINE_V, YELLOW};
        if(lx >= 8 && lx <= 11 && ly == 12) item = {LINE, LINE_H, c_i2};
        if(lx == 14 && ly == 12) item = {LINE, LINE_H, YELLOW};
        if(lx == 15 && ly == 12) item = {LINE, CORNER_LU, YELLOW};
        if(lx >= 8 && lx <= 11 && ly == 13) item = {LINE, LINE_H, c_i3};
        if(lx >= 8 && lx <= 11 && ly == 18) item = {LINE, LINE_H, c_i4};
        if(lx == 14 && ly == 18) item = {LINE, LINE_H, YELLOW};
        if(lx == 15 && ly == 18) item = {LINE, CORNER_LD, YELLOW};
        if(lx == 23 && ly == 18) item = {LINE, CORNER_RU, YELLOW};
        if(lx >= 24 && lx <= 25 && ly == 18) item = {LINE, LINE_H, YELLOW};
        if(lx >= 28 && lx <= 31 && ly == 18) item = {LINE, LINE_H, c_o2};
        if(lx >= 8 && lx <= 11 && ly == 19) item = {LINE, LINE_H, c_i5};
        if(lx == 15 && ly == 19) item = {LINE, CORNER_RU, YELLOW};
        if(lx >= 16 && lx <= 25 && ly == 19) item = {LINE, LINE_H, YELLOW};

        // Entrada
        if(gx == 16 && gy == 5 && pos > 0) text = {1'b1, (inputs[0]) ? ONE : ZERO, WHITE};
        if(gx == 16 && gy == 9 && pos > 1) text = {1'b1, (inputs[1]) ? ONE : ZERO, WHITE};
    end


endmodule
