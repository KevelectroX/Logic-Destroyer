module timer(
    input clk, rst,
    output reg o
);

localparam CYCLES = 50_000_000 / 10_000;
reg [13:0] counter = 0;

always @(posedge clk, negedge rst)
begin

    if (~rst)
    begin
        o <= 0;
        counter <= 0;
    end

    else
    begin
        if(counter == CYCLES)
        begin
            o <= 1;
            counter <= 0;
        end

        else
        begin
            o <= 0;
            counter <= counter + 1;
        end
    end
end

endmodule