module finish_draw(
    input [7:0] score,
    input [9:0] hcount, ycount,

    output reg [10:0] text
);


    // Colores {azul, verde, rojo}
    localparam WHITE  = 3'b111;
    localparam BLUE   = 3'b100;     
    localparam GREEN  = 3'b010;     
    localparam RED    = 3'b001;
    localparam CYAN   = 3'b110;

    localparam ZERO = 7'd63;
    
    wire [3:0] units = score % 10;
    wire [3:0] tens = score / 10; 


    // Posiciones
    wire [4:0] gx = hcount[9:5];
    wire [3:0] gy = ycount[8:5];
    wire [5:0] lx = hcount[9:4];
    wire [4:0] ly = ycount[8:4];

    always @(*)
    begin
        text = 0;



        // Letras
        if(gx == 8 && gy == 6) text = {1'b1, 7'd33, 3'b000};      //G
        if(gx == 9 && gy == 6) text = {1'b1, 7'd27, 3'b000};      //A
        if(gx == 10 && gy == 6) text = {1'b1, 7'd39, 3'b000};     //M
        if(gx == 11 && gy == 6) text = {1'b1, 7'd31, 3'b000};     //E

        if(gx == 8 && gy == 7) text = {1'b1, 7'd41, 3'b000};       //O
        if(gx == 9 && gy == 7) text = {1'b1, 7'd48, 3'b000};       //V
        if(gx == 10 && gy == 7) text = {1'b1, 7'd31, 3'b000};      //E
        if(gx == 11 && gy == 7) text = {1'b1, 7'd44, 3'b000};      //R

        
        if(lx == 15 && ly == 18) text = {1'b0, 7'd42, CYAN};    //P
        if(lx == 16 && ly == 18) text = {1'b0, 7'd21, CYAN};    //u
        if(lx == 17 && ly == 18) text = {1'b0, 7'd14, CYAN};    //n
        if(lx == 18 && ly == 18) text = {1'b0, 7'd20, CYAN};    //t
        if(lx == 19 && ly == 18) text = {1'b0, 7'd1, CYAN};     //a
        if(lx == 20 && ly == 18) text = {1'b0, 7'd10, CYAN};    //j
        if(lx == 21 && ly == 18) text = {1'b0, 7'd5, CYAN};     //e
        if(lx == 22 && ly == 18) text = {1'b0, 7'd77, CYAN};    //:


        // Número
        if(lx == 23 && ly == 18) text = {1'b0, ZERO + tens, WHITE};
        if(lx == 24 && ly == 18) text = {1'b0, ZERO + units, WHITE};

        //Pulsa CERO
        if(lx == 5 && ly == 22) text = {1'b0, 7'd42, WHITE};    //P
        if(lx == 6 && ly == 22) text = {1'b0, 7'd21, WHITE};    //u
        if(lx == 7 && ly == 22) text = {1'b0, 7'd12, WHITE};    //l
        if(lx == 8 && ly == 22) text = {1'b0, 7'd19, WHITE};    //s
        if(lx == 9 && ly == 22) text = {1'b0, 7'd1, WHITE};     //a
        if(lx == 11 && ly == 22) text = {1'b0, ZERO, RED};      //0

        if(lx == 3 && ly == 23) text = {1'b0, 7'd16, WHITE};    //p
        if(lx == 4 && ly == 23) text = {1'b0, 7'd1, WHITE};     //a
        if(lx == 5 && ly == 23) text = {1'b0, 7'd18, WHITE};    //r
        if(lx == 6 && ly == 23) text = {1'b0, 7'd1, WHITE};     //a
        if(lx == 8 && ly == 23) text = {1'b0, 7'd22, WHITE};    //v
        if(lx == 9 && ly == 23) text = {1'b0, 7'd15, WHITE};    //o
        if(lx == 10 && ly == 23) text = {1'b0, 7'd12, WHITE};   //l
        if(lx == 11 && ly == 23) text = {1'b0, 7'd22, WHITE};   //v
        if(lx == 12 && ly == 23) text = {1'b0, 7'd5, WHITE};    //e
        if(lx == 13 && ly == 23) text = {1'b0, 7'd18, WHITE};   //r


        // Pulsa uno
        if(lx == 28 && ly == 22) text = {1'b0, 7'd42, WHITE};           //P
        if(lx == 29 && ly == 22) text = {1'b0, 7'd21, WHITE};           //u
        if(lx == 30 && ly == 22) text = {1'b0, 7'd12, WHITE};           //l
        if(lx == 31 && ly == 22) text = {1'b0, 7'd19, WHITE};           //s
        if(lx == 32 && ly == 22) text = {1'b0, 7'd1, WHITE};            //a
        if(lx == 34 && ly == 22) text = {1'b0, ZERO + 7'd1, GREEN};     //1

        if(lx == 27 && ly == 23) text = {1'b0, 7'd16, WHITE};   //p
        if(lx == 28 && ly == 23) text = {1'b0, 7'd1, WHITE};    //a
        if(lx == 29 && ly == 23) text = {1'b0, 7'd18, WHITE};   //r
        if(lx == 30 && ly == 23) text = {1'b0, 7'd1, WHITE};    //a
        if(lx == 32 && ly == 23) text = {1'b0, 7'd10, WHITE};   //j
        if(lx == 33 && ly == 23) text = {1'b0, 7'd21, WHITE};   //u
        if(lx == 34 && ly == 23) text = {1'b0, 7'd7, WHITE};    //g
        if(lx == 35 && ly == 23) text = {1'b0, 7'd1, WHITE};    //a
        if(lx == 36 && ly == 23) text = {1'b0, 7'd18, WHITE};   //r

    end


endmodule