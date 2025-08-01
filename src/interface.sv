`include "define.svh"
interface alu_if(input bit clk, input bit rst, input bit cen);
        //inputs
        logic [W - 1 : 0] opa, opb;
        logic cin, mode;
        logic [3:0] cmd;
        logic [1:0] inp_valid;
        //outputs
        logic [W + 1 : 0] res;
        logic oflow, cout, g, l, e, err;

        clocking drv_cb@(posedge clk);
                default input #0 output #0;
                output opa, opb, cin, mode, cmd, inp_valid;
        endclocking

        clocking mon_cb@(posedge clk);
                input res, oflow, cout, g, l, e, err;
        endclocking

        clocking ref_cb@(posedge clk);
                //only for synchronization purposes
        endclocking

        //assertions
        //Check if all inputs are valid on cen -> high
        property valid_ip;
                @(posedge clk)
                disable iff(rst) cen |=> not($isunknown({opa, opb, cin, mode, cmd, inp_valid}));
        endproperty
        assert property(valid_ip)begin
                $info("Valid Inputs Pass");
        end
        else begin
                $error("Valid Inputs Fail");
        end

        //Check 16 cycle error condition
        property loop_err;
                @(posedge clk)
                disable iff(rst)(cen && (inp_valid == 1 || inp_valid == 2)) |-> (inp_valid ==3)[*16] |=> err;
        endproperty
        assert property(loop_err)begin
                $info("Loop error condition Pass");
        end
        else begin
                $info("Loop error condition Fail");
        end

        //Rotate error
        property rotate_err;
                @(posedge clk)
                disable iff(rst)(cen && inp_valid == 3 && mode == 0 && (cmd == 12 || cmd == 13) && opb[7:4] > 0) |=> err;
        endproperty
        assert property(rotate_err)begin
                $info("Rotate Error Condition Pass");
        end
        else begin
                $info("Rotate Error Condition Fail");
        end

        //Cen stable
        property stable_cen;
                @(posedge clk) cen |=> $stable(cen);
        endproperty
        assert property(stable_cen)begin
                $info("Stable Cen Pass");
        end
        else begin
                $info("Stable Cen Fail");
        end

        //Check if asserting reset is making outputs z
        property rst_check;
                @(posedge clk)
                rst |-> (res === 9'bzzzzzzz && cout === 1'bz && oflow === 1'bz && e === 1'bz && g === 1'bz && l === 1'bz && err === 1'bz );
        endproperty
        assert property(rst_check)begin
                $info("Reset Check Pass");
        end
        else begin
                $info("Reset Check Fail");
        end
endinterface
