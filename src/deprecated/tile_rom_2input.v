module tile_rom_2input(
    input clk,
    input [12:0] address,   // {numero de tile, fila, columna}
 
    output reg data
);
 
    reg rom [0:8191];       // 8 tiles de 32x32, un bit por píxel
 
    initial $readmemb("tiles.txt", rom);
 
    always @(posedge clk)
        data <= rom[address];
 
endmodule