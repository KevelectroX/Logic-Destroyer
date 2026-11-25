module audio(
    input clk, enable, rst,
    input [5:0] note, 
 
    inout sda, scl,
    output wave
);
 
    localparam ADDRESS = 7'b1100000;
 
    wire [31:0] o_increment;
    wire o_timer;
    wire [11:0] data;
    wire ready;
 
    assign wave = data[11];
    reg i2c_enable = 0;
 
    timer timer_1(
        .clk(clk),
        .rst(rst),
        .o(o_timer)
    );
 
    i2c protocol(
        .clk(clk),
        .rst(rst),
        .address(ADDRESS),
        .data_in(data),
        .enable(i2c_enable),
        .rw(1'b0),
        .ready(ready),
        .i2c_sda(sda),
        .i2c_scl(scl)
    );
 
    tune_generator #(.M(20)) tune_gen(
        .clk(clk),
        .rst(rst),
        .timer(o_timer),
        .enable(enable),
        .increment(o_increment),
        .data_out(data)
    );
 
    tunes tunes_1(
        .note(note),
        .increment(o_increment)
    );
 
    always @(posedge clk, negedge rst) 
    begin
        if(~rst)
            i2c_enable <= 0;
 
        if(o_timer)
            i2c_enable <= 1;
 
        if(~ready)
            i2c_enable <= 0;
    end
 
 
endmodule