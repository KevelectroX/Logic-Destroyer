module line_draw(
    input clk,
    input [2:0] tile,
    input [5:0] hpos, hend,     // Columnas de inicio y fin del tramo (casillas de 16 px)
    input [4:0] ypos, yend,     // Filas de inicio y fin del tramo
    input [9:0] hcount, ycount,

    output reg r_red, r_green, r_blue
);

    wire data;

    tile_rom_line rom(
        .clk(clk),
        .address({tile, ycount[3:0], hcount[3:0]}),
        .data(data)
    );

    
    wire in_range = (hcount[9:4] >= hpos) && (hcount[9:4] <= hend)
                 && (ycount[8:4] >= ypos) && (ycount[8:4] <= yend);


    always @(*) 
    begin
        if(in_range && data)
        begin
            r_red = 1;
            r_green = 1;
            r_blue = 1;
        end

        else
        begin
            r_red = 0;
            r_green = 0;
            r_blue = 0;
        end

    end



endmodule