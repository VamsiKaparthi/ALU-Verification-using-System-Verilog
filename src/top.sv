`include "interface.sv"
`include "pkg.sv"
module top();
        //importing package
        import pkg ::*;

        //declaring global signals
        bit clk, rst, cen;

        //clk
        initial begin
                cen = 1;
                forever #5 clk = ~clk;
        end

        //Reset initially
        initial begin
                @(posedge clk);
                rst = 1;
                @(posedge clk);
                rst = 0;
        end

        //interface
        alu_if inf(clk, rst, cen);

        //dut

        //test instation
        test t1 = new(inf);
        //call test methods
        initial begin
                t1.run();
                $finish;
        end
endmodule
