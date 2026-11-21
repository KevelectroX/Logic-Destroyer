module i2c(
    input clk,
    input rst,
    input [6:0] address,    // dirección I2C
    input [11:0] data_in,      // datos a enviar
    input enable,           // señal de encendido
    input rw,               // 1 para lectura, 0 para escritura

    output reg [11:0] data_out, // datos recibidos 
    output reg ready,         // indica si el controlador está listo para transmitir

    inout wire i2c_sda,
    inout wire i2c_scl

);


    localparam IDLE       = 4'b0000;      // Espera la señal de enable
    localparam START      = 4'b0001;      // Envía la condición de inicio
    localparam ADDRESS    = 4'b0010;      // Envía la dirección i2c y el bit de lectura o escritura 
    localparam READ_ACK   = 4'b0011;      // Lee el bit de reconocimiento del esclavo
    localparam WRITE_DATA = 4'b0100;      // Escribe información al esclavo
    localparam WRITE_ACK  = 4'b0101;      // Envía el bit de reconocimiento al esclavo
    localparam READ_DATA  = 4'b0110;      // Leer datos del esclavo
    localparam READ_ACK2  = 4'b0111;      // Leer el bit de reconocimiento después de la lectura de datos
    localparam STOP       = 4'b1000;      // Envía la condición de stop xD
    localparam STOP_PREP  = 4'b1001;      // Baja SDA con SCL bajo, para preparar el stop

    localparam CYCLES = 50_000_000 / 400_000 / 2 + 1; // CLK entre la frecuencia de operación entre 2


    wire i2c_scl_enable;

    reg write_enable;
    reg sda_out;

    reg [31:0] r_time = 0;
    reg i2c_clk = 0;

    reg [3:0] state;
    reg [2:0] counter;
    reg second_byte = 0;
    reg [7:0] saved_address;
    reg [11:0] saved_data;

    assign i2c_scl_enable = !((state == IDLE) || (state == START) || (state == STOP));
    assign i2c_scl = i2c_scl_enable ? i2c_clk : 1'b1;
    assign i2c_sda = write_enable ? sda_out : 1'bz;


    always @(*) 
    begin
        if((rst == 1) && (state == IDLE))
            ready = 1;
        
        else
            ready = 0;
    end


    always @(posedge clk)
    begin

        if(r_time == (CYCLES - 1))
        begin
            i2c_clk <= ~i2c_clk;
            r_time <= 0;
        end 
        
        else
            r_time <= r_time + 1;
    end


    always @(negedge i2c_clk, negedge rst) 
    begin

        if(rst == 0)
        begin
            write_enable <= 1;
            sda_out <= 1;           
        end

        else
        begin

        case(state)


            START : 
            begin
                write_enable <= 1;
                sda_out <= 0;       //Condición de inicio
            end


            ADDRESS : 
            begin
                sda_out <= saved_address[counter]; // Envía los bits de dirección
            end


            READ_ACK :
            begin
                write_enable <= 0;
            end


            WRITE_DATA :
            begin
                write_enable <= 1;

                if (second_byte)
                    sda_out <= saved_data[counter];

                else
                begin
                    if(counter > 3)
                        sda_out <= 0;  //Condiciones de Fast Mode
                    else
                        sda_out <= saved_data[counter+8];  // Envía los bits de datos
                end
            end


            WRITE_ACK :
            begin
                write_enable <= 1;      // Reconocemos la información recibida
                sda_out <= 0;
            end


            READ_DATA :
            begin
                write_enable <= 0;  // Libera SDA para leer los datos del esclavo
            end
            
            READ_ACK2 :
            begin
                write_enable <= 0;
            end


            STOP_PREP :
            begin
                write_enable <= 1;
                sda_out <= 0;   // SDA baja aquí con SCL todavía bajo
            end


            STOP :
            begin
                write_enable <= 1;
                sda_out <= 1;   // Condición de stop xD
            end

            default : 
            begin
                write_enable <= 1;
                sda_out <= 1; 
            end

        endcase
        end
    end



    always @(posedge i2c_clk, negedge rst)
    begin
        if(rst == 0)
        begin
            state <= IDLE;
            second_byte <= 0;
        end

        else 
        begin

            case(state)
            
            IDLE :
            begin
                if(enable)
                begin
                    state <= START;
                    saved_address <= {address, rw};
                    saved_data <= data_in;
                end
            end


            START :
            begin

                counter <= 3'd7;
                state <= ADDRESS;
            end


            ADDRESS :
            begin
                if(counter == 0) 
                    state <= READ_ACK;
                
                else
                    counter <= counter - 1;

            end


            READ_ACK :
            begin
                if(i2c_sda == 0)
                begin
                    counter <= 3'd7;

                    if(saved_address[0] == 0)
                        state <= WRITE_DATA;
                    
                    else
                        state <= READ_DATA;
                end

                else
                    state <= STOP_PREP;
            end


            WRITE_DATA :
            begin
                if(counter == 0)
                    state <= READ_ACK2;

                else counter <= counter - 1;
            end


            READ_DATA :
            begin

                if(second_byte == 0)
                    data_out[counter+8] <= i2c_sda;

                else
                    data_out[counter+4] <= i2c_sda;

                if(counter == 0)
                    state <= WRITE_ACK;
                
                else
                    counter <= counter - 1;
            end

            

            READ_ACK2 :
            begin
                if (i2c_sda == 0 && second_byte == 0)
                begin
                    counter <= 3'd7;
                    second_byte <= 1; 
                    state <= WRITE_DATA;
                end
                
                else
                    state <= STOP_PREP;
            end
             
            STOP_PREP :
            begin
                state <= STOP;
            end


            STOP :
            begin
                second_byte <= 0;
                state <= IDLE;
            end

            default : state <= IDLE;
            endcase

        end
        
    end







endmodule