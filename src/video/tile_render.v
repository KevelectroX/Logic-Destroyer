
module tile_render(
    input clk,
    input [8:0] item,               // {tipo, tile, color} del elemento que hay en la posición del barrido
    input [10:0] text,              // {doble, carácter, color} del texto en esa posición; carácter 0 es sin texto
    input [9:0] hcount, ycount,

    output o_red, o_green, o_blue
);

    // Tipo de elemento
    localparam GATE = 2'd1;         
    localparam LINE = 2'd2;         

    wire [1:0] kind = item[8:7];
    wire [3:0] tile = item[6:3];
    wire [2:0] color = item[2:0];

    wire big = text[10];            
    wire [6:0] char = text[9:3];

    reg gate_rom [0:16383];         
    reg line_rom [0:4095];          
    reg font_rom [0:32767];         
    reg gate_data, line_data, font_data;
    reg [2:0] text_color;

    initial $readmemb("tiles.txt", gate_rom);
    initial $readmemb("line_tiles.txt", line_rom);
    initial $readmemb("font.txt", font_rom);

   
    always @(posedge clk)
        
    begin
        gate_data <= gate_rom[{tile, ycount[4:0], hcount[4:0]}];
        line_data <= line_rom[{tile, ycount[3:0], hcount[3:0]}];

        if(big)
            font_data <= font_rom[{char, ycount[4:1], hcount[4:1]}];
        else
            font_data <= font_rom[{char, ycount[3:0], hcount[3:0]}];

        text_color <= text[2:0];    
    end


    wire pixel = (kind == GATE && gate_data) || (kind == LINE && line_data);


    assign o_red = font_data ? text_color[0] : (pixel && color[0]);
    assign o_green = font_data ? text_color[1] : (pixel && color[1]);
    assign o_blue = font_data ? text_color[2] : (pixel && color[2]);

endmodule
