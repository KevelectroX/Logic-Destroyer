module antibounce 
#(parameter CYCLES = 1_000_000)
(
    input clk, in,
    output reg out = 1
);

    reg sync_0 = 1; 
    reg sync_1 = 1;
    reg [19:0] counter = 0;
    

    always @(posedge clk) 
    begin
        sync_0 <= in;
        sync_1 <= sync_0;

        if(sync_1 == out)
        begin
            counter <= 0;
        end    

        else
        begin
            counter <= counter + 1;

            if(counter == CYCLES - 1)
            begin
                out <= sync_1;
            end
        end
    end

endmodule