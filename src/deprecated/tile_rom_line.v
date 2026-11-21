module tile_rom_line(
    input clk,
    input [10:0] address,   // {numero de tile, fila, columna}
 
    output reg data
);
 
    reg rom [0:1535];       // 6 tiles de 16x16, un bit por píxel
 
    initial $readmemb("line_tiles.txt", rom);
 
    always @(posedge clk)
        data <= rom[address];
 
endmodule