class reference;
        //transaction
        transaction pkt;
        //mailboxes
        mailbox #(transaction) mdr;
        mailbox #(transaction) mrs;
        //virtual interface
        virtual alu_if vif;

        function new(mailbox #(transaction) mdr, mailbox #(transaction) mrs, virtual alu_if vif);
                this.mdr = mdr;
                this.mrs = mrs;
                this.vif = vif;
        endfunction

        task alu();
                if(vif.rst)begin
                        pkt.res = 0;
                        pkt.oflow = 0;
                        pkt.cout = 0;
                        pkt.g = 0;
                        pkt.l = 0;
                        pkt.e = 0;
                        pkt.err = 0;
                end
                else if (vif.cen)begin
                        //reseting the outputs
                        pkt.res = 0;
                        pkt.oflow = 0;
                        pkt.cout = 0;
                        pkt.g = 0;
                        pkt.l = 0;
                        pkt.e = 0;
                        pkt.err = 0;
                        if(pkt.mode == 1)begin //arithmetic
                                case(pkt.inp_valid)
                                        2'b00:begin
                                                pkt.err = 1;
                                        end
                                        2'b01:begin //only a valid
                                                case(pkt.cmd)
                                                        4'b0100:begin //inc_a
                                                                pkt.res = pkt.opa + 1;
                                                        end
                                                        4'b0101:begin //dec_a
                                                                pkt.res = pkt.opa - 1;
                                                        end
                                                        default : pkt.err = 1;
                                                endcase
                                        end
                                        2'b10:begin //only a valid
                                                case(pkt.cmd)
                                                        4'b0110:begin //inc_a
                                                                pkt.res = pkt.opb + 1;
                                                        end
                                                        4'b0111:begin //dec_a
                                                                pkt.res = pkt.opb - 1;
                                                        end
                                                        default : pkt.err = 1;
                                                endcase
                                        end
                                        2'b11:begin
                                                case(pkt.cmd)
                                                        4'b0000:begin //add
                                                                pkt.res = pkt.opa + pkt.opb;
                                                                pkt.cout = ((pkt.opa + pkt.opb) > 2**W - 1);
                                                        end
                                                        4'b0001:begin //sub
                                                                pkt.res = pkt.opa - pkt.opb;
                                                                pkt.oflow = ((pkt.opa - pkt.opb) < 0);
                                                        end
                                                        4'b0010:begin //add_cin
                                                                pkt.res = pkt.opa + pkt.opb + pkt.cin;
                                                                pkt.cout = ((pkt.opa + pkt.opb + pkt.cin) > 2**W - 1);
                                                        end
                                                        4'b0011:begin //sub_cin
                                                                pkt.res = pkt.opa - pkt.opb - pkt.cin;
                                                                pkt.oflow = ((pkt.opa - pkt.opb - pkt.cin) < 0);
                                                        end
                                                        4'b0100:begin //inc_a
                                                                pkt.res = pkt.opa + 1;
                                                        end
                                                        4'b0101:begin //dec_a
                                                                pkt.res = pkt.opa - 1;
                                                        end
                                                        4'b0110:begin //inc_a
                                                                pkt.res = pkt.opb + 1;
                                                        end
                                                        4'b0111:begin //dec_a
                                                                pkt.res = pkt.opb - 1;
                                                        end
                                                        4'b1000:begin //cmp
                                                                pkt.g = (pkt.opa > pkt.opb);
                                                                pkt.l = (pkt.opa < pkt.opb);
                                                                pkt.e = (pkt.opa == pkt.opb);
                                                        end
                                                        4'b1001:begin //inc_mult
                                                                pkt.res = (pkt.opa + 1) * (pkt.opb + 1);
                                                        end
                                                        4'b1010:begin //shift_a_mult
                                                                pkt.res = (pkt.opa << 1) * pkt.opb;
                                                        end
                                                        default : pkt.err = 1;
                                                endcase
                                        end
                                endcase
                        end
                        else begin
                                case(pkt.inp_valid)
                                        2'b00: pkt.err = 1;
                                        2'b01:begin //only a valid
                                                case(pkt.cmd)
                                                        4'b0110:begin //not_a
                                                                pkt.res = !pkt.opa;
                                                        end
                                                        4'b1000:begin //shr1_a
                                                                pkt.res = pkt.opa >> 1;
                                                        end
                                                        4'b1001:begin //shl1_a
                                                                pkt.res = pkt.opa << 1;
                                                        end
                                                        default: pkt.err = 1;
                                                endcase
                                        end
                                        2'b10:begin //only b valid
                                                case(pkt.cmd)
                                                        4'b0111:begin
                                                                pkt.res = !pkt.opb;
                                                        end
                                                        4'b1010:begin
                                                                pkt.res = pkt.opb >> 1;
                                                        end
                                                        4'b1011:begin
                                                                pkt.res = pkt.opb << 1;
                                                        end
                                                        default: pkt.err = 1;
                                                endcase
                                        end
                                        2'b11:begin
                                                case(pkt.cmd)
                                                        4'b0000:begin
                                                                pkt.res = pkt.opa & pkt.opb;
                                                                //$display("Enter inside add");
                                                        end
                                                        4'b0001:begin
                                                                pkt.res = !(pkt.opa & pkt.opb);
                                                        end
                                                        4'b0010:begin
                                                                pkt.res = pkt.opa | pkt.opb;
                                                        end
                                                        4'b0011:begin
                                                                pkt.res = !(pkt.opa | pkt.opb);
                                                        end
                                                        4'b0100:begin
                                                                pkt.res = pkt.opa ^ pkt.opb;
                                                        end
                                                        4'b0101:begin
                                                                pkt.res = !(pkt.opa ^ pkt.opb);
                                                        end
                                                        4'b0110:begin //not_a
                                                                pkt.res = !pkt.opa;
                                                        end
                                                        4'b0111:begin
                                                                pkt.res = !pkt.opb;
                                                        end
                                                        4'b1000:begin //shr1_a
                                                                pkt.res = pkt.opa >> 1;
                                                        end
                                                        4'b1001:begin //shl1_a
                                                                pkt.res = pkt.opa << 1;
                                                        end
                                                        4'b1010:begin
                                                                pkt.res = pkt.opb >> 1;
                                                        end
                                                        4'b1011:begin
                                                                pkt.res = pkt.opb << 1;
                                                        end
                                                        4'b1100:begin
                                                                if( |(pkt.opb[W - 1 : SHIFT_WIDTH + 1]))begin
                                                                        pkt.err = 1;
                                                                end
                                                                else begin
                                                                        pkt.res = (pkt.opa << pkt.opb[SHIFT_WIDTH - 1 : 0]) | (pkt.opa >> (W - pkt.opb[SHIFT_WIDTH - 1 : 0]));
                                                                end
                                                        end
                                                        4'b1101:begin
                                                                if(|pkt.opb[W-1: SHIFT_WIDTH + 1])begin
                                                                        pkt.err = 1;
                                                                end
                                                                else begin
                                                                        pkt.res = (pkt.opa >> pkt.opb[SHIFT_WIDTH - 1:0]) | (pkt.opa << (W - pkt.opb[SHIFT_WIDTH - 1: 0]));
                                                                end
                                                        end
                                                        default : pkt.err = 1;
                                                endcase
                                        end
                                endcase
                        end
                end
        endtask
        task start();
                int count = 0;
                int single_op_logical[] = {6,7,8,9,10,11};
                int single_op_arithmetic[] = {4,5,6,7};
                repeat(3)@(vif.ref_cb);
                repeat(num)begin
                        pkt = new();
                        mdr.get(pkt);
                        $display("[%0t] - THE INITIAL INPUT PKT IS IN REFERENCE inp_valid = %0d, mode = %0b, cmd = %0d, opa = %0d, opb = %0d\n", $time, pkt.inp_valid, pkt.mode, pkt.cmd, pkt.opa, pkt.opb);
                        if(pkt.inp_valid == 2'b11 || pkt.inp_valid == 2'b00)begin
                                if((pkt.cmd == 4'b1001 || pkt.cmd == 4'b1010)&& pkt.mode == 1)begin
                                        repeat(2)@(vif.ref_cb);
                                        $display("[%0t]-THE INPUT PKT IS IN REFERENCE inp_valid = %0d, mode = %0b, cmd = %0d, opa = %0d, opb = %0d\n", $time, pkt.inp_valid, pkt.mode, pkt.cmd, pkt.opa, pkt.opb);
                                        alu();
                                end
                                else begin
                                        repeat(1)@(vif.ref_cb);
                                        $display("[%0t]-THE INPUT PKT IS IN REFERENCE inp_valid = %0d, mode = %0b, cmd = %0d, opa = %0d, opb = %0d\n", $time, pkt.inp_valid, pkt.mode, pkt.cmd, pkt.opa, pkt.opb);
                                        alu();
                                end
                        end

                        else begin
                                if(pkt.mode == 0 && pkt.cmd inside {single_op_logical})begin
                                        repeat(1) @(vif.ref_cb);
                                        alu();
                                end
                                else if(pkt.mode == 1 && pkt.cmd inside {single_op_arithmetic})begin
                                        repeat(1) @(vif.ref_cb);
                                        alu();
                                end
                                else begin
                                        count = 0;
                                        for(count  = 1; count < 17; count++)begin
                                                //$display("-",pkt.inp_valid, count);
                                               @(vif.ref_cb);
                                                mdr.get(pkt);
                                                $display("[%0t]-THE INPUT PKT IS IN REFERENCE inp_valid = %0d, mode = %0b, cmd = %0d, opa = %0d, opb = %0d\n", $time, pkt.inp_valid, pkt.mode, pkt.cmd, pkt.opa, pkt.opb);
                                                if(pkt.inp_valid == 2'b11)begin
                                                        pkt.err = 0;
                                                        if(pkt.cmd == 4'b1001 || pkt.cmd == 4'b1010)begin
                                                                repeat(1) @(vif.ref_cb);
                                                                alu();
                                                        end
                                                        else begin
                                                                //repeat(2)@(vif.ref_cb)
                                                                alu();
                                                        end
                                                        break;
                                                end

                                        end
                                        $display("count = %0d", count);
                                        @(vif.ref_cb);
                                        if(count == 17)
                                                pkt.err = 1;
                                end
                        end
                        $display("[%0t]-Outputs : res = %0d, err = %0d", $time, pkt.res, pkt.err);
                        mrs.put(pkt);
                        //repeat(1)@(vif.ref_cb);
                end
        endtask
endclass
