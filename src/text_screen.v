
module text_screen
#(parameter SCREENS = 4)            // Número de pantallas en screens.txt
(
    input clk,
    input [2:0] screen,             
    input [2:0] color,              
    input [55:0] fields,            
    input [9:0] hcount, ycount,

    output [10:0] text              // {doble, carácter, color} para tile_render
);


    reg [7:0] screen_rom [0:SCREENS*1200-1];
    reg [7:0] square;
    reg visible;

    initial $readmemh("screens.txt", screen_rom);


    wire last_column = (hcount == 799);
    wire [9:0] next_x = last_column ? 10'd0 : hcount + 10'd1;
    wire [9:0] next_y = !last_column ? ycount : (ycount == 524) ? 10'd0 : ycount + 10'd1;

    wire [5:0] column = next_x[9:4];
    wire [4:0] row = next_y[8:4];
    wire [13:0] address = screen * 1200 + row * 40 + column;

    always @(posedge clk)
    begin
        square <= screen_rom[address];
        visible <= (next_x < 640) && (next_y < 480);
    end


    wire is_field = (square[6:3] == 4'd3);
    wire [6:0] char = is_field ? fields[square[2:0] * 7 +: 7] : square[6:0];

    assign text = visible ? {square[7], char, color} : 11'd0;

endmodule
