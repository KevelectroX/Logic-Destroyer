module top
#(parameter NUM_ROUNDS = 5,
  parameter CLKS_PER_SECOND = 50_000_000)
(
    input clk, input_0, input_1, rst,
    input bt_rx,
    output o_red, o_blue, o_green, vsync, hsync,
    inout sda, scl,
    output bt_tx,
    output audio_out

);

    // <!-------- Registro de Estado  --------->
    // Parámetros de la máquina de estado, que fueran ocho es coincidencia xD
    localparam START = 3'b000;
    localparam SHOW_RULES = 3'b001;
    localparam SHOW_ROUND = 3'b010;
    localparam GENERATE_CONFIG = 3'b011;
    localparam SHOW_TOPOLOGY = 3'b100;
    localparam VERIFY = 3'b101;
    localparam SHOW_CORRECTION = 3'b110;
    localparam FINAL_SCREEN = 3'b111;



    // <!-------- Parametros de Conteo  --------->
    //  Dícese de los parámetros que sirven para contar
    localparam RULES_CYCLES = 20 * CLKS_PER_SECOND;
    localparam ROUND_CYCLES = 5 * CLKS_PER_SECOND;
    localparam CORRECT_CYCLES =  3 * CLKS_PER_SECOND;
    localparam CONFIG_CYCLES = 2;



    // <!-------- Registros  --------->
    //  Dícese de los registros principales del sistema
    reg [31:0] r_time_count = 0;    // Contador
    reg [2:0] r_SM_Main = 0;        // Registro de estado
    reg [3:0] inputs = 4'd0;        // Registro de entradas de 1 o 0
    reg [2:0] pos = 0;              // Registro de posición de la entrada
    reg [3:0] round = 0;            // Registro de Ronda
    reg [7:0] score = 0;            // Registro de puntaje
    reg r_input_0 = 0;              // Registro de ingreso de un 0
    reg r_input_1 = 0;              // Registro de ingreso de un 1
    reg previous_final = 0;



    // <!-------- Configuración de Ronda  --------->
    //  Configuración de cada ronda
    reg [2:0] num_outputs = 0;
    reg [3:0] expected_output = 0;
    reg [31:0] random_config = 0;
    wire [31:0] LFSR_data;
    //máscara para no cambiar el tamaño de bits
    wire [3:0] mask = (4'd1 << num_outputs) - 4'd1;
    wire [3:0] wrong = (inputs ^ expected_output) & mask;



    // <!-------- Lógica de Pulsación  --------->
    //  Dícese de la lógica de pulsación de un botón
    wire clean_0;
    wire clean_1;
    wire i0_b;
    wire i1_b;
    wire i0 = (r_input_0 & ~clean_0) || i0_b;
    wire i1 = (r_input_1 & ~clean_1) || i1_b;
    


    // <!-------- Lógica de Habilitación  --------->
    //  Funciona sencillamente para parar el LFSR
    wire enable = (r_SM_Main == START) || (r_SM_Main == SHOW_RULES)  || (r_SM_Main == SHOW_ROUND)
                  || (r_SM_Main == SHOW_TOPOLOGY);



    // <!-------- Variables de Sonido  --------->
    //  Dícese de los registros y cables relacionados al audio
    wire [5:0] note;
    wire playing;
    reg audio_start;
    reg music_start = 1;
    reg [2:0] sound;



    // <!-------- Variables de Video  --------->
    //  Dícese de los registros y cables relacionados al video
    wire [9:0] hcount, ycount;
    reg show_response = 0;

    // <!-------- Variables UART  --------->
    //  Dícese de los registros y cables relacionados al uart
    reg [7:0] uart_counter = 0;     // Byte del mensaje que se está enviando
    reg send_score = 0;             // Pulso para empezar a enviar el puntaje
    reg sending = 0;                // Hay un mensaje en curso
    reg [7:0] score_copy = 0;       // Puntaje guardado al empezar el envío
    reg tx_dv = 0;
    reg [7:0] tx_byte = 0;
    wire tx_active;
    wire tx_done;


    // Circuitos y conexiones para la primera topología, fue a mano xD
    wire i_i1 = random_config[7];
    wire i_i2 = random_config[6];
    wire i_i3 = random_config[5];
    wire rise = random_config[4];
    wire [2:0] circuit1 = random_config[15:13];
    wire [2:0] circuit2 = random_config[12:10];



    // <!-------- Linear Feedback Shift Register  --------->
    //  Registro de desplazamiento, simula el generador de números aleatorios :)
    LFSR #(.NUM_BITS(32), .DEFAULT_VALUE(32'b10010111001001101001010110101101)) random(
		.i_Clk(clk),
		.i_Enable(enable),
		.i_Seed_DV(1'b0),
		.i_Seed_Data(32'd0),
		.o_LFSR_Data(LFSR_data)
	);

    // <!-------- Anti rebote  --------->
    //  Evita rebotes indeseados de los botones, son 20ms maso
    antibounce #(.CYCLES(CLKS_PER_SECOND / 50)) btn_0(
        .clk(clk),
        .in(input_0),
        .out(clean_0)
    );

    antibounce #(.CYCLES(CLKS_PER_SECOND / 50)) btn_1(
        .clk(clk),
        .in(input_1),
        .out(clean_1)
    );


    // <!-------- Topologás "Virtuales"  --------->
    // Las topologías que existen a nivel de máquina, es decir, las que no se ven
    wire tp1_o1;
    topology_1 tp1(
        .i1(i_i1),
        .i2(i_i2),
        .i3(i_i3),
        .rise(rise),
        .o1(tp1_o1),
        .q_0(random_config[0]),
        .q_1(random_config[1]),
        .circuit1(circuit1),
        .circuit2(circuit2)
    );

    // Topología 2
    wire tp2_o1;
    topology_2 tp2(
        .random_config(random_config),
        .o1(tp2_o1)
    );

    // Topología 3
    wire tp3_o1;
    topology_3 tp3(
        .random_config(random_config),
        .o1(tp3_o1)
    );

    // Topología 4
    wire tp4_o1, tp4_o2;
    topology_4 tp4(
        .random_config(random_config),
        .o1(tp4_o1),
        .o2(tp4_o2)
    );

    // Topología 5
    wire tp5_o1, tp5_o2, tp5_o3;
    topology_5 tp5(
        .random_config(random_config),
        .o1(tp5_o1),
        .o2(tp5_o2),
        .o3(tp5_o3)
    );



    // <!-------- Módulos de Audio  --------->
    // Los módulos relacionados con el audio
    wire [5:0] note_music;
    wire music_enable;
    player #(.SEMI_CYCLES(CLKS_PER_SECOND/8), .SONG_CYCLES(CLKS_PER_SECOND*5/32)) music(
        .clk(clk),
        .rst(rst),
        .start(music_start),
        .enable(music_enable),
        .sound(3'd0),
        .note(note_music)
    );

    wire [5:0] note_bass;
    wire bass_enable;
    player #(.SEMI_CYCLES(CLKS_PER_SECOND/8), .SONG_CYCLES(CLKS_PER_SECOND*5/32), .FILE("song_bass.txt")) bass(
        .clk(clk),
        .rst(rst),
        .start(music_start),
        .enable(bass_enable),
        .sound(3'd0),
        .note(note_bass)
    );

    wire [5:0] note_effect;
    wire playing_effect;
    wire effect_enable;
    player #(.SEMI_CYCLES(CLKS_PER_SECOND/8), .SONG_CYCLES(CLKS_PER_SECOND*3/56)) effects(
        .clk(clk),
        .rst(rst),
        .start(audio_start),
        .enable(effect_enable),
        .sound(sound),
        .note(note_effect),
        .is_playing(playing_effect)
    );

    assign note = (playing_effect) ? note_effect : note_music;
    assign playing = (playing_effect) ? effect_enable : music_enable;

    audio audio(
        .clk(clk),
        .enable(playing),
        .rst(rst),
        .note(note),
        .sda(sda),
        .scl(scl),
        .wave(audio_out),
        .note_2(note_bass),
        .enable_2(bass_enable)
    );


    
    
    // <!-------- Módulos de Video  --------->
    // Los módulos relacionados con el video

    wire w_red, w_green, w_blue;
    vga_logic vga(
        .clk(clk),
        .i_red(w_red),
        .i_green(w_green),
        .i_blue(w_blue),
        .o_red(o_red),
        .o_green(o_green),
        .o_blue(o_blue),
        .hsync(hsync),
        .vsync(vsync),
        .o_hcount(hcount),
        .o_ycount(ycount)
    );

    reg [8:0]item;
    reg [10:0] text;

    tile_render tile_render1(
        .clk(clk),
        .item(item),
        .text(text),
        .hcount(hcount),
        .ycount(ycount),
        .o_red(w_red),
        .o_green(w_green),
        .o_blue(w_blue)
    );

    // <!-------- Módulos de Bluetooth --------->
    // Solo intancia el uart_rx para descrestar
    wire o_rx_dv;
    wire [7:0] o_rx_byte;

    uart_rx uart(
        .i_clock(clk),
        .i_RX_Serial(bt_rx),
        .o_RX_DV(o_rx_dv),
        .o_RX_Byte(o_rx_byte)
    );

    assign i0_b = o_rx_dv && (o_rx_byte == 8'h30);
    assign i1_b = o_rx_dv && (o_rx_byte == 8'h31);

    uart_tx uart_t(
        .i_Clock(clk),
        .i_Tx_DV(tx_dv),
        .i_Tx_Byte(tx_byte),
        .o_Tx_Active(tx_active),
        .o_Tx_Serial(bt_tx),
        .o_Tx_Done(tx_done)
    );

    // Manda "Puntaje: XX" y un salto de línea, un byte a la vez.
    // tx_dv se mantiene en 1 hasta que el transmisor lo toma (sube tx_active)
    always @(posedge clk)
    begin
        if(send_score)
        begin
            sending <= 1;
            uart_counter <= 0;
            score_copy <= score;
        end

        else if(sending)
        begin
            if(~tx_dv && ~tx_active)
            begin
                tx_dv <= 1;

                case(uart_counter)
                    8'd0 : tx_byte <= "P";
                    8'd1 : tx_byte <= "u";
                    8'd2 : tx_byte <= "n";
                    8'd3 : tx_byte <= "t";
                    8'd4 : tx_byte <= "a";
                    8'd5 : tx_byte <= "j";
                    8'd6 : tx_byte <= "e";
                    8'd7 : tx_byte <= ":";
                    8'd8 : tx_byte <= " ";
                    8'd9 : tx_byte <= 8'h30 + score_copy / 10;     // Decenas en ASCII
                    8'd10 : tx_byte <= 8'h30 + score_copy % 10;    // Unidades en ASCII
                    default : tx_byte <= 8'h0A;                    // Salto de línea
                endcase
            end

            else if(tx_dv && tx_active)
            begin
                tx_dv <= 0;

                if(uart_counter == 8'd11)
                    sending <= 0;
                else
                    uart_counter <= uart_counter + 1;
            end
        end
    end


    // <!-------- Topologías Visuales  --------->
    // grafica la topología en la pantalla, o bueno, le dice al módulo que graficar

    wire [8:0] tp1_item; 
    wire [10:0] tp1_text;
    topology_1_draw tp1_draw(
        .clk(clk),
        .random_config(random_config),
        .inputs(inputs),
        .pos(pos),
        .show_response(show_response),
        .o1(tp1_o1),
        .hcount(hcount),
        .ycount(ycount),
        .item(tp1_item),
        .text(tp1_text)
    );
    
    // Topología 2
    wire [8:0] tp2_item; 
    wire [10:0] tp2_text;
    topology_2_draw tp2_draw(
        .clk(clk),
        .random_config(random_config),
        .inputs(inputs),
        .pos(pos),
        .show_response(show_response),
        .o1(tp2_o1),
        .hcount(hcount),
        .ycount(ycount),
        .item(tp2_item),
        .text(tp2_text)
    );

    // Topología 3
    wire [8:0] tp3_item; 
    wire [10:0] tp3_text;
    topology_3_draw tp3_draw(
        .clk(clk),
        .random_config(random_config),
        .inputs(inputs),
        .pos(pos),
        .show_response(show_response),
        .o1(tp3_o1),
        .hcount(hcount),
        .ycount(ycount),
        .item(tp3_item),
        .text(tp3_text)
    );

    // Topología 4
    wire [8:0] tp4_item; 
    wire [10:0] tp4_text;
    topology_4_draw tp4_draw(
        .clk(clk),
        .random_config(random_config),
        .inputs(inputs),
        .pos(pos),
        .show_response(show_response),
        .o1(tp4_o1),
        .o2(tp4_o2),
        .hcount(hcount),
        .ycount(ycount),
        .item(tp4_item),
        .text(tp4_text)
    );

    // Topología 5
    wire [8:0] tp5_item; 
    wire [10:0] tp5_text;
    topology_5_draw tp5_draw(
        .clk(clk),
        .random_config(random_config),
        .inputs(inputs),
        .pos(pos),
        .show_response(show_response),
        .o1(tp5_o1),
        .o2(tp5_o2),
        .o3(tp5_o3),
        .hcount(hcount),
        .ycount(ycount),
        .item(tp5_item),
        .text(tp5_text)
    );


    // <!-------- Pantallas Visuales  --------->
    // grafica las distintas pantallas del juego como ronda, inicio, etc.

    wire [10:0] title_text;
    wire [8:0] title_item;
    title_draw title_draw_1(
        .clk(clk),
        .round(round),
        .hcount(hcount),
        .ycount(ycount),
        .text(title_text),
        .item(title_item),
        .rst(rst)
    );

    wire [10:0] rules_text;
    wire [8:0] rules_item;
    rules_draw rules_draw1(
        .clk(clk),
        .hcount(hcount),
        .ycount(ycount),
        .item(rules_item),
        .text(rules_text)
    );

    wire [10:0] round_text;
    round_draw round_draw1(
        .clk(clk),
        .round(round),
        .hcount(hcount),
        .ycount(ycount),
        .text(round_text)
    );

    wire [10:0] finish_text;
    finish_draw finish_draw1(
        .score(score),
        .hcount(hcount),
        .ycount(ycount),
        .text(finish_text)
    );



    // <!-------- COnfiguración para Siempre  --------->
    // Le dice quien debe ser dibujado
    always @(*) begin

        if(round == 0 && (r_SM_Main == SHOW_TOPOLOGY || r_SM_Main == SHOW_CORRECTION))
        begin
            item = tp1_item;
            text = tp1_text;
        end

        else if(round == 1 && (r_SM_Main == SHOW_TOPOLOGY || r_SM_Main == SHOW_CORRECTION))
        begin
            item = tp2_item;
            text = tp2_text;
        end

        else if(round == 2 && (r_SM_Main == SHOW_TOPOLOGY || r_SM_Main == SHOW_CORRECTION))
        begin
            item = tp3_item;
            text = tp3_text;
        end

        else if(round == 3 && (r_SM_Main == SHOW_TOPOLOGY || r_SM_Main == SHOW_CORRECTION))
        begin
            item = tp4_item;
            text = tp4_text;
        end

        else if(round == 4 && (r_SM_Main == SHOW_TOPOLOGY || r_SM_Main == SHOW_CORRECTION))
        begin
            item = tp5_item;
            text = tp5_text;
        end

        else if(r_SM_Main == SHOW_ROUND)
        begin
            item = 0;
            text = round_text;
        end

        else if(r_SM_Main == START)
        begin
            item = title_item;
            text = title_text;
        end


        else if(r_SM_Main == FINAL_SCREEN)
        begin
            item = 0;
            text = finish_text;
        end

        else if(r_SM_Main == SHOW_RULES)
        begin
            item = rules_item;
            text = rules_text;
        end

        else
        begin
            item = 0;
            text = 0;
        end
    end



    // <!-------- COnfiguración Secuencial  --------->
    // Maneja la máquina de estados y pues toda las salidas relacionadas xD
    always @(posedge clk) begin
        
        // Guarda entrada actual del botón para identificar un cambio
        r_input_0 <= clean_0;
        r_input_1 <= clean_1;

        // Reincia el pulso de audio xD
        audio_start <= 0;
        music_start <= 0;
        send_score <= 0;


        // Lógica de Reset
        if(~rst)
        begin
            audio_start <= 0; 
            music_start <= 1;
            r_SM_Main <= START;
            r_time_count <= 0;
            inputs <= 4'd0;
            pos <= 0;
            round <= 0;
            score <= 0;
            show_response <= 0;
            previous_final <= 0;
        end


        // Lógica de Estados
        else case(r_SM_Main)

            START : 
            begin
                
                previous_final <= 0;
                sound <= 0;
                r_time_count <= 0;
                round <= 0;
                score <= 0;
                

                // Lógica

                if(i0 == 1 || i1 == 1)
                    r_SM_Main <= SHOW_RULES; 
            end


            SHOW_RULES : 
            begin

                r_time_count <= r_time_count + 1;

                // Lógica

                if(i0 == 1 || i1 == 1 || r_time_count == RULES_CYCLES)
                begin
                    r_time_count <= 0;
                    r_SM_Main <= SHOW_ROUND;
                end

            end


            SHOW_ROUND :
            begin
                previous_final <= 0;
                r_time_count <= r_time_count + 1;
                inputs <= 4'd0;
                pos <= 0;

                if(r_time_count == ROUND_CYCLES)
                begin
                    r_time_count <= 0;
                    r_SM_Main <= GENERATE_CONFIG;
                end

            end

            GENERATE_CONFIG : 
            begin
                r_time_count <= r_time_count + 1;
                random_config <= LFSR_data;


                // Lógica de Salidas xD
                if(round == 0)
                begin
                    num_outputs <= 3'd1;
                    expected_output[0] <= tp1_o1;
                end

                else if(round == 1)
                begin
                    num_outputs <= 3'd1;
                    expected_output[0] <= tp2_o1;
                end

                else if(round == 2)
                begin
                    num_outputs <= 3'd1;
                    expected_output[0] <= tp3_o1;
                end

                else if(round == 3)
                begin
                    num_outputs <= 3'd2;
                    expected_output[0] <= tp4_o1;
                    expected_output[1] <= tp4_o2;
                end

                else if(round == 4)
                begin
                    num_outputs <= 3'd3;
                    expected_output[0] <= tp5_o1;
                    expected_output[1] <= tp5_o2;
                    expected_output[2] <= tp5_o3;
                end

                else r_SM_Main <= FINAL_SCREEN;


                if (r_time_count == CONFIG_CYCLES)
                begin
                    r_time_count <= 0; 
                    r_SM_Main <= SHOW_TOPOLOGY;
                end
            
            end

            SHOW_TOPOLOGY :
            begin

                if(i1 == 1 & i0 == 0)
                begin
                    inputs[pos] <= 1;
                    pos <= pos + 1;
                end


                if(i1 == 0 & i0 == 1)
                begin
                    inputs[pos] <= 0;
                    pos <= pos + 1;
                end

                if(num_outputs == pos)
                    r_SM_Main <= VERIFY; 

            end


            VERIFY :
            begin
                score <= score + num_outputs*(round+1) - wrong[3]*(round+1) 
                        - wrong[2]*(round+1) - wrong[1]*(round+1) - wrong[0]*(round+1);
                

                if(|wrong)
                begin
                    sound <= 2;
                    audio_start <= 1;
                    r_SM_Main <= SHOW_CORRECTION; 
                    expected_output <= 0; 
                end

                else 
                begin
                    sound <= 1;
                    audio_start <= 1;
                    expected_output <= 0;

                    if(round == NUM_ROUNDS - 1)
                        r_SM_Main <= FINAL_SCREEN;

                    else
                    begin
                       r_SM_Main <= SHOW_CORRECTION; 
                    end
                end
            end



            SHOW_CORRECTION :
            begin
                show_response <= 1; 
                audio_start <= 0;
                r_time_count <= r_time_count + 1;
                
                // Lógica


                if(r_time_count == CORRECT_CYCLES)
                begin
                    show_response <= 0; 
                    r_time_count <= 0;
 
                    if(round == NUM_ROUNDS - 1)
                        r_SM_Main <= FINAL_SCREEN;

                    else
                    begin
                        round     <= round + 1;
                        r_SM_Main <= SHOW_ROUND;
                    end
                end
            end
 


            FINAL_SCREEN :
            begin

                if(~previous_final)
                begin
                    previous_final <= 1;
                    send_score <= 1;
                end

                music_start <= 0;
                audio_start <= 0;
                if(i1)                      
                begin
                    round     <= 0;
                    score     <= 0;
                    r_SM_Main <= SHOW_ROUND;
                end
 
                else if(i0)
                begin          
                    music_start <= 1;     
                    r_SM_Main <= START;
                end

            end
 

            default : r_SM_Main <= START;
        endcase


    end


endmodule