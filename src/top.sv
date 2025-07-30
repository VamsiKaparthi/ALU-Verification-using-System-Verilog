`include "interface.sv"
`include "pkg.sv"
`include "design.sv"
module top();
        //importing package
        import pkg ::*;

        //declaring global signals
        bit clk, rst, cen;

        //clk
        initial begin

                forever #5 clk = ~clk;
        end

        //Reset initially
        initial begin
                @(posedge clk);
                rst = 1;
                @(posedge clk);
                rst = 0;
                cen = 1;
        end

        //interface
        alu_if inf(clk, rst, cen);

        //dut
        ALU_DESIGN dut(.INP_VALID(inf.inp_valid), .OPA(inf.opa), .OPB(inf.opb), .CIN(inf.cin), .CLK(clk), .RST(rst), .CMD(inf.cmd), .CE(cen), .MODE(inf.mode), .COUT(inf.cout), .OFLOW(inf.oflow), .RES(inf.res), .G(inf.g), .E(inf.e), .L(inf.l), .ERR(inf.err));
        //test instation
        test t1 = new(inf);
        test_sl t2 = new(inf);
        test_sa t3 = new(inf);
        test_tl t4 = new(inf);
        test_ta t5 = new(inf);
        test_regression t6 = new(inf);
        //call test methods
        initial begin
                t6.run();
                //t5.run();
                //t1.run();
                $finish;
        end
endmodule
