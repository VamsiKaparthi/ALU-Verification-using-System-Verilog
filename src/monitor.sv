class monitor;
        transaction pkt;
        mailbox #(transaction) mms; //monitor to scoreboard mailbox
        virtual alu_if vif;
        covergroup mon_cg; //output coverage
                c1 : coverpoint pkt.res{
                        bins b1 = {0};
                        bins b2 = {511};
                        bins b3 = default;
                }
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
                pkt.res = vif.res;
                pkt.cout = vif.cout;
                pkt.err = vif.err;
                pkt.oflow = vif.oflow;
                pkt.g = vif.g;
                pkt.l = vif.l;
                pkt.e = vif.e;
                //$display("[%0t]--Monitor in interface -- inp_valid = %0d, opa = %0d, opb = %0d", $time, vif.inp_valid, vif.opa, vif.opb);
                mon_cg.sample;
        endtask
        task start();
                //bit flag = 0;
                int single_op_arithmetic[] = {4,5,6,7};
                int single_op_logical[] = {6,7,8,9,10,11};
                pkt = new(); //for recieving from DUT
                repeat(4)@(vif.mon_cb); // 1 cycle delay to driver
                repeat(num)begin
                //      flag = 0;
                        //@(vif.mon_cb);
                        pkt = new();
                        recieve();
                        $display("[%0t] THE INITIAL IP PKT IN MONITOR IS inp_valid = %0d, opa = %0d, opb = %0d", $time,pkt.inp_valid, pkt.opa, pkt.opb);
                        if(pkt.inp_valid == 2'b11 || pkt.inp_valid == 2'b00)begin
                                recieve();
                                if(pkt.inp_valid == 2'b11 && (pkt.cmd == 4'b1010 || pkt.cmd == 4'b1001)&& pkt.mode == 1)begin
                                        $display("[%0t] ---Monitor--- pkt.res = %0d, pkt.err = %0b", $time, pkt.res, pkt.err);
                                        repeat(2)@(vif.mon_cb);
                                        recieve();
                                end
                                else begin
                                        repeat(1)@(vif.mon_cb);
                                        $display("[%0t] ---Monitor--- pkt.res = %0d, pkt.err = %0b", $time, pkt.res, pkt.err);
                                        recieve();
                                end
                                $display("[%0t] ---Monitor_Outputs--- res = %0d, err = %0b", $time, pkt.res, pkt.err);

                                //mms.put(pkt);
                        end
                        else begin
                                if(pkt.mode == 0)begin
                                        if(pkt.cmd inside {single_op_logical})begin
                                                repeat(1)@(vif.mon_cb);
                                                recieve();
                                                //mms.put(pkt);
                                                $display("[%0t] ---Monitor_Outputs--- res = %0d, err = %0b", $time, pkt.res, pkt.err);
                                        end
                                        else begin
                                                //repeat(1)@(vif.mon_cb);
                                                recieve();
                                                for(int i = 0; i < 16; i++)begin
                                                        repeat(1)@(vif.mon_cb);
                                                        recieve();
                                                        $display("[%0t] ---Monitor--- pkt.inp_valid = %0d", $time, pkt.inp_valid);
                                                        if(pkt.inp_valid == 2'b11)begin
                                                //              @(vif.mon_cb);
                                                                //mms.put(pkt);
                                                                $display("[%0t] ---Monitor_Outputs--- res = %0d, err = %0b", $time, pkt.res, pkt.err);

                                                                break;
                                                        end
                                                end
                                        end
                                end
                                if(pkt.mode == 1)begin
                                        if(pkt.cmd inside {single_op_arithmetic})begin
                                                repeat(1)@(vif.mon_cb);
                                                recieve();
                                                //mms.put(pkt);
                                                $display("[%0t] --Monitor-- pkt.res = %0d", $time, pkt.res);
                                        end
                                        else begin
                                                //repeat(1)@(vif.mon_cb);
                                                recieve();
                                                $display("[%0t] --Monitor-- inp_valid = %0d, opa = %0d, opb = %0d", $time, pkt.inp_valid, pkt.opa, pkt.opb);
                                                for(int i = 0; i < 16; i++)begin
                                                        @(vif.mon_cb);
                                                        recieve();
                                                        $display("[%0t] --Monitor-- inp_valid = %0d, opa = %0d, opb = %0d", $time, pkt.inp_valid, pkt.opa, pkt.opb);
                                                        if(pkt.inp_valid == 2'b11)begin
                                                                if(pkt.cmd == 4'b1010 || pkt.cmd == 4'b1001)begin
                                                                        repeat(1)@(vif.mon_cb);
                        //                                              repeat(1)@(vif.mon_cb);
                                                                        $display("[%0t] ---Monitor_Outputs--- res = %0d, err = %0b, opa = %0d, opb = %0d", $time, pkt.res, pkt.err, pkt.opa, pkt.opb);
                //                                                      flag = 1;
                                                                        break;
                                                                end
                                                                else begin
                                                                        repeat(0)@(vif.mon_cb);
                        //                                              repeat(1)@(vif.mon_cb);
                                                                         $display("[%0t] ---Monitor_Outputs [inside loop]--- res = %0d, err = %0b", $time, pkt.res, pkt.err);
                //                                                      flag = 1;
                                                                        break;
                                                                end
                                                        end
                                                end
                                        end

                                end
                        end
                //      if(flag == 0)
                //              @(vif.mon_cb);
                        recieve();
                        //$display("[%0t] ##-Monitor_Outputs--- res = %0d, err = %0b, opa = %0d, opb = %0d", $time, pkt.res, pkt.err, pkt.opa, pkt.opb);

                        //mms.put(pkt);
                        if((pkt.cmd == 4'b1010 || pkt.cmd == 4'b1001) && pkt.mode)begin
                                @(vif.mon_cb);
                                pkt.err <= vif.err;
                        end
                        @(vif.mon_cb);
        //              recieve();
                        pkt.err <= vif.err;
                        pkt.cout <= vif.cout;
                        pkt.res <= vif.res;
                        pkt.g <= vif.g;
                        pkt.l <= vif.l;
                        pkt.e <= vif.e;
                        pkt.oflow <= vif.oflow;
                        $display("[%0t] ##-Monitor_Outputs--- res = %0d, err = %0b, opa = %0d, opb = %0d", $time, pkt.res, pkt.err, pkt.opa, pkt.opb);
                        mms.put(pkt);
                end
        endtask
endclass
