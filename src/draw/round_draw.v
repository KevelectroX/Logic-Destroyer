module round_draw(
    input clk,
    input [3:0] round,
    input [9:0] hcount, ycount,

    output reg [10:0] text
);


    // Colores {azul, verde, rojo}
    localparam WHITE  = 3'b111;
    localparam BLUE = 3'b100;     
    localparam GREEN  = 3'b010;     
    localparam RED    = 3'b001;  
    
    localparam SEMI_HALF_SECOND = 50_000_000 / 4;

    reg twinkle = 0;
    reg [23:0] counter = 0;

    // Posiciones
    wire [4:0] gx = hcount[9:5];
    wire [3:0] gy = ycount[8:5];

    always @(*)
    begin
        text = 0;

        // Letras
        if(gx == 7 && gy == 7 && twinkle) text = {1'b1, 7'd44, RED};
        if(gx == 8 && gy == 7 && twinkle) text = {1'b1, 7'd41, GREEN};
        if(gx == 9 && gy == 7 && twinkle) text = {1'b1, 7'd40, BLUE};
        if(gx == 10 && gy == 7 && twinkle) text = {1'b1, 7'd30, WHITE};
        if(gx == 11 && gy == 7 && twinkle) text = {1'b1, 7'd27, RED};

        // Número
        if(gx == 13 && gy == 7 && twinkle) text = {1'b1, 7'd64 + round, GREEN};

    end

    always @(posedge clk)
    begin
        counter <= counter + 1;

        if (counter == SEMI_HALF_SECOND - 1)
        begin
            counter <= 0;
            twinkle <= ~ twinkle;
        end
    end

endmodule