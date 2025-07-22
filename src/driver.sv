class driver;
        mailbox #(transaction) mgd; //mailbox from generator
        mailbox #(transaction) mdr; //mailbox to reference
        virtual alu_if vif;
        transaction pkt;
        function new(mailbox #(transaction) mgd, mailbox #(transaction) mdr, virtual alu_if vif);
                this.mgd = mgd;
                this.mdr = mdr;
                this.vif = vif;
        endfunction
        covergroup cg; //input functional coverage
                c1 : coverpoint pkt.opa;
                c2 : coverpoint pkt.opb;
                c3 : coverpoint pkt.cin;
                c4 : coverpoint pkt.mode;
                c5 : coverpoint pkt.inp_valid;
                c6 : coverpoint pkt.cmd;
        endgroup
        task start();
                int single_op_arithmetic[] = {4,5,6,7};
                int single_op_logical[] = {6,7,8,9,10,11};
                int two_arithmetic[] = {0,1,2,3,8,9,10};
                int two_logical[] = {0,1,2,3,4,5,12,13};
                repeat(3)@(vif.drv_cb);
                //start driving
                repeat(num)begin
                mgd.get(pkt);
                pkt.mode.rand_mode(1);
                pkt.cmd.rand_mode(1);
                  // $display("STRTED THE PKT iv is %0d",pkt.inp_valid);
                if(pkt.inp_valid == 2'b11 || pkt.inp_valid == 2'b00)begin
                        vif.opa <= pkt.opa;
                        vif.opb <= pkt.opb;
                        vif.cin <= pkt.cin;
                        vif.mode <= pkt.mode;
                        vif.inp_valid <= pkt.inp_valid;
                        vif.cmd <= pkt.cmd;
                        if(pkt.inp_valid == 2'b11 && (pkt.cmd == 4'b1010 || pkt.cmd == 4'b1001))
                                repeat(2)@(vif.drv_cb);
                        else
                                repeat(1)@(vif.drv_cb);
                        mdr.put(pkt);
                        $display("[%0t]---Sent from Driver--- inp_valid = %0d, opa = %0d, opb = %0d", $time, pkt.inp_valid, pkt.opa, pkt.opb);
                end
                else begin
                        if(pkt.inp_valid == 2'b01 || pkt.inp_valid == 2'b10)begin
                                if(pkt.mode == 0)begin
                                        if(pkt.cmd inside {single_op_logical})begin
                                                vif.opa <= pkt.opa;
                                                vif.opb <= pkt.opb;
                                                vif.cin <= pkt.cin;
                                                vif.mode <= pkt.mode;
                                                vif.inp_valid <= pkt.inp_valid;
                                                vif.cmd <= pkt.cmd;

                                                repeat(1)@(vif.drv_cb);
                                                mdr.put(pkt);
                                                $display("[%0t]---Sent from Driver--- inp_valid = %0d, opa = %0d, opb = %0d", $time, pkt.inp_valid, pkt.opa, pkt.opb);

                                        end
                                        else begin
                                                vif.opa <= pkt.opa;
                                                vif.opb <= pkt.opb;
                                                vif.cin <= pkt.cin;
                                                vif.mode <= pkt.mode;
                                                vif.inp_valid <= pkt.inp_valid;
                                                vif.cmd <= pkt.cmd;
                                                repeat(1)@(vif.drv_cb);
                                                mdr.put(pkt);
                                                $display("[%0t]---Sent from Driver--- inp_valid = %0d, opa = %0d, opb = %0d", $time, pkt.inp_valid, pkt.opa, pkt.opb);

                                                pkt.mode.rand_mode(0);
                                                pkt.cmd.rand_mode(0);
                                                for(int i = 0; i < 16; i = i+1)begin
                                                        @(vif.drv_cb);
                                                        void'(pkt.randomize());
                                                        mdr.put(pkt);
                                                         $display("[%0t]---Sent from Driver--- inp_valid = %0d, opa = %0d, opb = %0d", $time, pkt.inp_valid, pkt.opa, pkt.opb);
                                                        vif.opa <= pkt.opa;
                                                        vif.opb <= pkt.opb;
                                                        vif.cin <= pkt.cin;
                                                        vif.mode <= pkt.mode;
                                                        vif.inp_valid <= pkt.inp_valid;
                                                        vif.cmd <= pkt.cmd;
                                                        if(pkt.inp_valid == 2'b11)begin
                                                        //      mdr.put(pkt);
                                                               // @(vif.drv_cb);
                                                                break;
                                                        end
                                                end
                                        end
                                end
                                else begin //arithmetic
                                        if(pkt.cmd inside {single_op_arithmetic})begin
                                                vif.opa <= pkt.opa;
                                                vif.opb <= pkt.opb;
                                                vif.cin <= pkt.cin;
                                                vif.mode <= pkt.mode;
                                                vif.inp_valid <= pkt.inp_valid;
                                                vif.cmd <= pkt.cmd;
                                                repeat(1)@(vif.drv_cb);
                                                mdr.put(pkt);
                                                $display("[%0t]---Sent from Driver--- inp_valid = %0d, opa = %0d, opb = %0d", $time, pkt.inp_valid, pkt.opa, pkt.opb);
                                        end
                                        else begin
                                                vif.opa <= pkt.opa;
                                                vif.opb <= pkt.opb;
                                                vif.cin <= pkt.cin;
                                                vif.mode <= pkt.mode;
                                                vif.inp_valid <= pkt.inp_valid;
                                                vif.cmd <= pkt.cmd;
                                                //$display("FROM THE DRIVER INP IS %0D",pkt.inp_valid);
                                                repeat(1)@(vif.drv_cb);
                                                mdr.put(pkt);
                                                $display("[%0t]---Sent from Driver--- inp_valid = %0d, opa = %0d, opb = %0d", $time, pkt.inp_valid, pkt.opa, pkt.opb);
                                                pkt.mode.rand_mode(0);
                                                pkt.cmd.rand_mode(0);
                                                for(int i = 0; i < 16; i = i+1)begin
                                                        //$display("At time %t, i = %0d, inp_valid = %0d", $time, i, pkt.inp_valid);
                                                        repeat(1)@(vif.drv_cb);
                                                        void'(pkt.randomize());
                                                        mdr.put(pkt);
                                                        $display("[%0t]---Sent from Driver--- inp_valid = %0d, opa = %0d, opb = %0d", $time, pkt.inp_valid, pkt.opa, pkt.opb);
                                                        vif.opa <= pkt.opa;
                                                        vif.opb <= pkt.opb;
                                                        vif.cin <= pkt.cin;
                                                        vif.mode <= pkt.mode;
                                                        vif.inp_valid <= pkt.inp_valid;
                                                        vif.cmd <= pkt.cmd;
                                                        if(pkt.inp_valid == 2'b11)begin
                                                                //if(i == 0)
                                                                //      @(vif.drv_cb);
                                                                //mdr.put(pkt);
                                                                //$display("GOT IV AS 3");
                                                                if(pkt.cmd == 4'b1010 || pkt.cmd == 4'b1001)begin
                                                                        repeat(1)@(vif.drv_cb);
                                                                        break;
                                                                end
                                                                else begin
                                                                        repeat(0)@(vif.drv_cb);
                                                                        break;
                                                                end
                                                        end
                                                end
                                        end

                                end
                        end
                end
                        if(pkt.cmd == 4'b1010 || pkt.cmd == 4'b1001)
                                @(vif.drv_cb);
                        @(vif.drv_cb);
                end
        endtask
endclass
