module player 
#(parameter SEMI_CYCLES = 6_250_000,    // Unidad de tiempo semicorchea a 120 bpm
  parameter SONG_CYCLES = 6_250_000,    // Unidad de tiempo de la canción
  parameter FILE = "song.txt")
(
    input clk, rst,
    input start,
    input [2:0] sound,      // 0 canción, 1 acierto, 2 error

    output reg [5:0] note,
    output is_playing,
    output enable
);


localparam DO = 6'd12;
localparam DO_S = 6'd13;
localparam RE = 6'd14;
localparam MI = 6'd16;
localparam SOL = 6'd19;
localparam SILENCE = 6'd63;

reg [31:0] r_time_count = 0;
reg [11:0] step = 0;
reg [2:0] r_sound = 0;      // Sonido guardado al llegar start
reg playing = 0;

reg [3:0] duration = 1;     // Duración del paso en semicorcheas
reg last = 1;               // Último paso del sonido
reg tie = 0;                // Ligadura: el paso se une al siguiente sin silencio

// Canción: una fila por paso, {last, tie, duration, note}
reg [11:0] song [0:4095];
reg [11:0] song_row;

initial $readmemh(FILE, song);

assign is_playing = playing;

always @(posedge clk)
    song_row <= song[step];


// Cada paso termina con un silencio corto, para que dos notas iguales seguidas no se peguen
wire [31:0] unit = (r_sound == 0) ? SONG_CYCLES : SEMI_CYCLES;
wire [31:0] step_cycles = duration * unit;
wire gap = !tie && (r_time_count >= step_cycles - unit / 8);

assign enable = playing && !gap && (note != SILENCE);



always @(posedge clk)
begin
    if(r_sound == 0)
        {last, tie, duration, note} <= song_row;

    else
    begin
        tie <= 0;

        case ({r_sound, step})
        {3'd1, 12'd0} : begin note <= SILENCE;  duration <= 4'd4; last <= 0; end     // Silencio, negra
        {3'd1, 12'd1} : begin note <= DO;  duration <= 4'd2; last <= 0; end     // DO, corchea
        {3'd1, 12'd2} : begin note <= MI; duration <= 4'd2; last <= 0; end      // MI, corchea
        {3'd1, 12'd3} : begin note <= SOL; duration <= 4'd2; last <= 0; end     // SOL, corchea   
        {3'd1, 12'd4} : begin note <= SILENCE; duration <= 4'd4; last <= 1; end     // silencio, negra
            
            
        {3'd2, 12'd0} : begin note <= SILENCE;  duration <= 4'd4; last <= 0; end     // Silencio, negra
        {3'd2, 12'd1} : begin note <= RE;  duration <= 4'd2; last <= 0; end     // RE, corchea
        {3'd2, 12'd2} : begin note <= DO_S;  duration <= 4'd2; last <= 0; end     // DO#, corchea
        {3'd2, 12'd3} : begin note <= DO;  duration <= 4'd2; last <= 0; end     // DO, corchea
        {3'd2, 12'd4} : begin note <= SILENCE; duration <= 4'd4; last <= 1; end     // Silencio, negra

    
        default: begin note <= SILENCE; duration <= 4'd1; last <= 1; end
        endcase
    end
end


always @(posedge clk)
begin
    if(~rst)
    begin
        playing <= 0;
        r_time_count <= 0;
        step <= 0; 
    end

    else if(start)
    begin
        r_sound <= sound;
        playing <= 1;
        r_time_count <= 0;
        step <= 0;
    end

    else if(playing)
    begin
        r_time_count <= r_time_count + 1;

        if(r_time_count == step_cycles - 1)
        begin
            r_time_count <= 0;

            if(last)
                playing <= 0;
            else
                step <= step + 1;
        end
    end

end



endmodule