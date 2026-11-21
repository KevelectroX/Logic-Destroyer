module gate_draw(
    input clk,
    input [2:0] tile,
    input [2:0] color,
    input [4:0] hpos,
    input [3:0] ypos,
    input [9:0] hcount, ycount,

    output reg r_red, r_green, r_blue
);

    wire data;

    tile_rom_2input rom(
        .clk(clk),
        .address({tile, ycount[4:0], hcount[4:0]}),
        .data(data)
    );


    always @(*) 
    begin
        if(hpos == hcount[9:5] && ypos == ycount[8:5] && data)
        begin
            r_red = color[0];
            r_green = color[1];
            r_blue = color[2];
        end

        else
        begin
            r_red = 0;
            r_green = 0;
            r_blue = 0;
        end

    end



endmodule