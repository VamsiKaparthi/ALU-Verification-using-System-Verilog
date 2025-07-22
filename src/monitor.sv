class monitor;
        transaction pkt, pkt1;
        mailbox #(transaction) mms; //monitor to scoreboard mailbox
        virtual alu_if vif;
        covergroup mon_cg; //output coverage
                c1 : coverpoint pkt.res;
                c2 : coverpoint pkt.g;
                c3 : coverpoint pkt.l;
                c4 : coverpoint pkt.e;
                c5 : coverpoint pkt.oflow;
                c6 : coverpoint pkt.err;
                c7 : coverpoint pkt.cout;
        endgroup

        function new(mailbox #(transaction) mms, virtual alu_if vif);
                this.mms = mms;
                this.vif = vif;
                mon_cg = new();
        endfunction
        task recieve();
                pkt.opa = vif.opa;
                pkt.opb = vif.opb;
                pkt.cmd = vif.cmd;
                pkt.mode = vif.mode;
                pkt.inp_valid = vif.inp_valid;
                pkt.cin = vif.cin;
                $display("[%0t]--Monitor in interface -- inp_valid = %0d, opa = %0d, opb = %0d", $time, vif.inp_valid, vif.opa, vif.opb);

        endtask
        task send();
                pkt1.res = vif.res;
                pkt1.cout = vif.cout;
                pkt1.err = vif.err;
                pkt1.oflow = vif.oflow;
                pkt1.g = vif.g;
                pkt1.l = vif.l;
                pkt1.e = vif.e;
        endtask
        task start();
                int single_op_arithmetic[] = {4,5,6,7};
                int single_op_logical[] = {6,7,8,9,10,11};
                pkt = new(); //for recieving from DUT
                pkt1 = new();
                repeat(3)@(vif.mon_cb); // 1 cycle delay to driver
                repeat(num)begin
                        recieve();
                        $display("[%0t]--Monitor-- inp_valid = %0d, opa = %0d, opb = %0d", $time, pkt.inp_valid, pkt.opa, pkt.opb);
                        @(vif.mon_cb);
                        if(pkt.inp_valid == 2'b11 || pkt.inp_valid == 2'b01)begin
                                send();
                                if(pkt.inp_valid == 2'b11 && (pkt.cmd == 4'b1010 || pkt.cmd == 4'b1001))
                                        repeat(2)@(vif.mon_cb);
                                else
                                        repeat(1)@(vif.mon_cb);
                                mms.put(pkt1);
                        end
                        else begin
                                if(pkt.mode == 0)begin
                                        if(pkt.cmd inside {single_op_logical})begin

                                                repeat(1)@(vif.mon_cb);
                                                send();
                                                mms.put(pkt1);
                                                $display("[%0t] ---Monitot--- pkt.res = %0d", $time, pkt1.res);
                                        end
                                        else begin
                                                repeat(1)@(vif.mon_cb);

                                                for(int i = 0; i < 16; i++)begin
                                                        @(vif.mon_cb);
                                                        recieve();
                                                        send();
                                                        $display("[%0t] ---Monitor--- pkt.res = %0d", $time, pkt1.res);
                                                        if(pkt.inp_valid == 2'b11)begin
                                                                mms.put(pkt1);
                                                                break;
                                                        end
                                                end
                                        end
                                end
                                if(pkt.mode == 1)begin
                                        if(pkt.cmd inside {single_op_arithmetic})begin
                                                repeat(1)@(vif.mon_cb);
                                                send();
                                                mms.put(pkt1);
                                                $display("%t pkt.res = %0d", $time, pkt1.res);
                                        end
                                        else begin
                                                repeat(1)@(vif.mon_cb);
                                                $display("%t pkt.res = %0d", $time, pkt1.res);
                                                for(int i = 0; i < 16; i++)begin
                                                        @(vif.mon_cb);
                                                        recieve();
                                                        if(pkt.inp_valid == 2'b11)begin
                                                                if(pkt.cmd == 4'b1010 || pkt.cmd == 4'b1001)begin
                                                                        repeat(1)@(vif.mon_cb);
                                                                        break;
                                                                end
                                                                else begin
                                                                        repeat(0)@(vif.mon_cb)
                                                                        break;
                                                                end
                                                        end
                                                end
                                        end

                                end
                        end
                        if(pkt.cmd == 4'b1010 || pkt.cmd == 4'b1001)
                                @(vif.mon_cb);
                        @(vif.mon_cb);
                end
        endtask
endclass
