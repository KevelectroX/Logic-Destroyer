module tile_render(
    input clk,
    input [8:0] item,               // {tipo, tile, color} del elemento que hay en la posición del barrido
    input [10:0] text,              // {doble, carácter, color} del texto en esa posición; carácter 0 es sin texto
    input [9:0] hcount, ycount,

    output o_red, o_green, o_blue
);

    // Tipo de elemento
    localparam GATE = 2'd1;         // Tile de 32x32
    localparam LINE = 2'd2;         // Tile de 16x16
    localparam HALF = 2'd3;         // Tile de 16x16 de cable a media altura (segunda página de cables)

    wire [1:0] kind = item[8:7];
    wire [3:0] tile = item[6:3];
    wire [2:0] color = item[2:0];

    wire big = text[10];            // Letra al doble: ocupa 32x32
    wire [6:0] char = text[9:3];

    reg gate_rom [0:16383];         // 16 tiles de 32x32, un bit por píxel
    reg line_rom [0:8191];          // 32 tiles de 16x16: 16 de LINE y 16 de HALF
    reg font_rom [0:32767];         // 128 caracteres de 16x16
    reg gate_data, line_data, font_data;
    reg [2:0] text_color;

    // Efecto RGB: el color 000 (negro, que no sirve para texto) dibuja la letra dos veces,
    // corrida un píxel de la tipografía a cada lado: una copia en rojo y otra en cian
    wire rgb = (text[2:0] == 3'b000);
    wire [3:0] fx = big ? hcount[4:1] : hcount[3:0];    // Columna dentro del glifo
    wire [3:0] fy = big ? ycount[4:1] : ycount[3:0];    // Fila dentro del glifo
    reg font_right;                 // Glifo leído un píxel a la izquierda (copia corrida a la derecha)
    reg edge_left, edge_right;      // La copia se sale de la celda
    reg rgb_on;

    initial $readmemb("tiles.txt", gate_rom);
    initial $readmemb("line_tiles.txt", line_rom);
    initial $readmemb("font.txt", font_rom);


    always @(posedge clk)
    begin
        gate_data <= gate_rom[{tile, ycount[4:0], hcount[4:0]}];
        line_data <= line_rom[{kind[0], tile, ycount[3:0], hcount[3:0]}]; // kind[0]: 0 LINE, 1 HALF
    end
            

    // Al doble, cada píxel de la letra se repite 2x2: se usan los bits de arriba de la posición (fx, fy).
    // Con el efecto RGB esta lectura toma la copia corrida a la izquierda.
    always @(posedge clk)
    begin
        font_data <= font_rom[{char, fy, rgb ? fx + 4'd1 : fx}];
        edge_left <= rgb && (fx == 4'd15);      // La copia se sale de la celda
        text_color <= text[2:0];    // Viaja junto con el dato de la letra
    end

    // Segunda lectura de la tipografía, solo para el efecto RGB: copia corrida a la derecha
    always @(posedge clk)
    begin
        font_right <= font_rom[{char, fy, fx - 4'd1}];
        edge_right <= (fx == 4'd0);
        rgb_on <= rgb;
    end

    wire red_copy = rgb_on && font_data && !edge_left;
    wire cyan_copy = rgb_on && font_right && !edge_right;
    wire normal_text = !rgb_on && font_data;


    wire pixel = (kind == GATE && gate_data) || ((kind == LINE || kind == HALF) && line_data);

    // El texto va encima; donde la letra no tiene trazo se ve lo de abajo.
    // Con el efecto RGB, donde las dos copias coinciden se ve blanco.
    assign o_red = normal_text ? text_color[0] : (red_copy || cyan_copy) ? red_copy : (pixel && color[0]);
    assign o_green = normal_text ? text_color[1] : (red_copy || cyan_copy) ? cyan_copy : (pixel && color[1]);
    assign o_blue = normal_text ? text_color[2] : (red_copy || cyan_copy) ? cyan_copy : (pixel && color[2]);

endmodule