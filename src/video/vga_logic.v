module vga_logic(
    input clk,
    input i_red, i_green, i_blue,

    output reg o_red, o_green, o_blue,  //Señales de colores
    output reg hsync, vsync, // Señales de sincronización
    output [9:0] o_hcount, o_ycount // Contadores de posición

);


    
    reg [9:0] hcount = 0;
    reg [9:0] ycount = 0;
    reg [2:0] color;
    
    reg clk_25MHz = 0;

    assign o_hcount = hcount;
    assign o_ycount = ycount;




    always @(posedge clk)
    begin
        if(clk_25MHz)
        begin
            
            color[0] = i_red;
            color[1] = i_green;
            color[2] = i_blue;

            if(hcount == 799)
            begin
                hcount = 0;

                if(ycount == 524)
                begin
                    ycount = 0;

                end else begin
                    ycount = ycount + 1;
                end

            end else begin
                hcount = hcount + 1;
            end
            
            // Sincronización vertical
            if(ycount >= 490 && ycount < 492) begin
                vsync = 0;

            end else begin
                vsync = 1;
            end
            
            // Sincronización horizontal
            if(hcount >= 656 && hcount < 752) begin
                hsync = 0;

            end else begin
                hsync = 1;
            end
            
            // Asignación de colores
            if(hcount < 640 && ycount < 480) begin
                o_red = color[0];
                o_green = color[1];
                o_blue = color[2];

            end else begin
                o_red = 1'b0;
                o_green = 1'b0;
                o_blue = 1'b0;
            end
        
        end

        clk_25MHz = ~clk_25MHz;
    end

endmodule