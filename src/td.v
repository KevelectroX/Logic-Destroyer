`timescale 1ns/1ps
module td;
    reg i1, i2, i3, rise, clk;
    wire o1, q_0;

    // Comando para listar
    // find . -name "*.v" | sed 's|^\./||' | sort > files.f

    topology1 uut(.i1(i1), .i2(i2), .i3(i3), .rise(rise), .clk(clk), .o1(o1), .q_0(q_0));

    always #10 clk = ~clk;        // 50 MHz

    initial begin
        $dumpfile("sim.vcd");     // archivo de formas de onda
        $dumpvars(0, td);         // qué señales guardar
        clk = 0; rise = 1;
        
        i1 = 1;
        i2 = 1;
        i3 = 1;

        #200 $finish;
    end
endmodule