module tunes(
    input [5:0] note,
    output reg [31:0] increment
);
 
// Frecuencias en Hz. _S es sostenido; 0 es la octava grave y 2 la aguda.
localparam DO0 = 131;
localparam DO_S0 = 139;
localparam RE0 = 147;
localparam RE_S0 = 156;
localparam MI0 = 165;
localparam FA0 = 175;
localparam FA_S0 = 185;
localparam SOL0 = 196;
localparam SOL_S0 = 208;
localparam LA0 = 220;
localparam LA_S0 = 233;
localparam SI0 = 247;
 
localparam DO = 262;
localparam DO_S = 277;
localparam RE = 294;
localparam RE_S = 311;
localparam MI = 330;
localparam FA = 349;
localparam FA_S = 370;
localparam SOL = 392;
localparam SOL_S = 415;
localparam LA = 440;
localparam LA_S = 466;
localparam SI = 494;
 
localparam DO2 = 523;
localparam DO_S2 = 554;
localparam RE2 = 587;
localparam RE_S2 = 622;
localparam MI2 = 659;
localparam FA2 = 698;
localparam FA_S2 = 740;
localparam SOL2 = 784;
localparam SOL_S2 = 831;
localparam LA2 = 880;
localparam LA_S2 = 932;
localparam SI2 = 988;
 
localparam M = 20;
 
 
// La nota es el número de semitonos desde DO0: 12 es DO y 24 es DO2
always @(*)
begin
 
    case (note)
 
    6'd0:  increment = DO0    * 2**M/10_000;
    6'd1:  increment = DO_S0  * 2**M/10_000;
    6'd2:  increment = RE0    * 2**M/10_000;
    6'd3:  increment = RE_S0  * 2**M/10_000;
    6'd4:  increment = MI0    * 2**M/10_000;
    6'd5:  increment = FA0    * 2**M/10_000;
    6'd6:  increment = FA_S0  * 2**M/10_000;
    6'd7:  increment = SOL0   * 2**M/10_000;
    6'd8:  increment = SOL_S0 * 2**M/10_000;
    6'd9:  increment = LA0    * 2**M/10_000;
    6'd10: increment = LA_S0  * 2**M/10_000;
    6'd11: increment = SI0    * 2**M/10_000;
 
    6'd12: increment = DO     * 2**M/10_000;
    6'd13: increment = DO_S   * 2**M/10_000;
    6'd14: increment = RE     * 2**M/10_000;
    6'd15: increment = RE_S   * 2**M/10_000;
    6'd16: increment = MI     * 2**M/10_000;
    6'd17: increment = FA     * 2**M/10_000;
    6'd18: increment = FA_S   * 2**M/10_000;
    6'd19: increment = SOL    * 2**M/10_000;
    6'd20: increment = SOL_S  * 2**M/10_000;
    6'd21: increment = LA     * 2**M/10_000;
    6'd22: increment = LA_S   * 2**M/10_000;
    6'd23: increment = SI     * 2**M/10_000;
 
    6'd24: increment = DO2    * 2**M/10_000;
    6'd25: increment = DO_S2  * 2**M/10_000;
    6'd26: increment = RE2    * 2**M/10_000;
    6'd27: increment = RE_S2  * 2**M/10_000;
    6'd28: increment = MI2    * 2**M/10_000;
    6'd29: increment = FA2    * 2**M/10_000;
    6'd30: increment = FA_S2  * 2**M/10_000;
    6'd31: increment = SOL2   * 2**M/10_000;
    6'd32: increment = SOL_S2 * 2**M/10_000;
    6'd33: increment = LA2    * 2**M/10_000;
    6'd34: increment = LA_S2  * 2**M/10_000;
    6'd35: increment = SI2    * 2**M/10_000;
 
    default : increment = 0;    // No hay fase
 
    endcase
 
end
 
endmodule
