module tune_generator #(parameter M)
(
    input clk, rst, timer, enable, 
    input [31:0] increment,
    output [11:0] data_out
);

    

    reg [M-1:0] fase = 0;

    always @(posedge clk, negedge rst) 
    begin
        if(~rst)
            fase <= 0;

        else
        begin
            if(timer)
            begin
                fase <= fase + increment;
            end
        end

    end

    assign data_out = (fase[M-1] && enable) ? 12'hFFF : 12'h000;

endmodule