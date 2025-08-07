class scoreboard;
        mailbox #(transaction) mrs;
        mailbox #(transaction) mms;
        transaction pkt_ref, pkt_mon;
        function new(mailbox #(transaction) mrs, mailbox #(transaction) mms);
                this.mrs = mrs;
                this.mms = mms;
        endfunction
        function int compare();
                if(pkt_ref.res === pkt_mon.res)begin
                        if(pkt_ref.err === pkt_mon.err)begin
                                if(pkt_ref.cout === pkt_mon.cout)begin
                                        if(pkt_ref.g === pkt_mon.g)begin
                                                if(pkt_ref.l === pkt_mon.l)begin
                                                        if(pkt_ref.e === pkt_mon                                                                                        .e)begin
                                                                if(pkt_ref.oflow                                                                                         === pkt_mon.oflow)begin
                                                                        return 1                                                                                        ;
                                                                end
                                                        end
                                                end
                                        end
                                end
                        end
                end
                else
                        return 0;
        endfunction
        task start();
                static int count = 0;
                $display("monitor pkts = %0d", mms.num());
                $display("-----------------------------------------------------"                                                                                        );
                repeat(num)begin
                        pkt_ref = new();
                        pkt_mon = new();
                        mrs.get(pkt_ref);
                        mms.get(pkt_mon);
                        $display("Reference Packet : res = %0d, err = %0b, opa =                                                                                         %0d, opb = %0d, cin = %0b, cout = %0b, g = %0b, l = %0b, e = %0b, oflow = %0b",                                                                                         pkt_ref.res, pkt_ref.err, pkt_ref.opa, pkt_ref.opb, pkt_ref.cin, pkt_ref.cout,                                                                                         pkt_ref.g, pkt_ref.l, pkt_ref.e, pkt_ref.oflow);
                        $display("Monitor Packet   : res = %0d, err = %0b, opa =                                                                                         %0d, opb = %0d, cin = %0b, cout = %0b, g = %0b, l = %0b, e = %0b, oflow = %0b "                                                                                        , pkt_mon.res, pkt_mon.err, pkt_mon.opa, pkt_mon.opb, pkt_mon.cin, pkt_mon.cout,                                                                                         pkt_mon.g, pkt_mon.l, pkt_mon.e, pkt_mon.oflow);
                        if(compare())begin
                                $display("Pass");
                        end
                        else begin
                                $display("Fail");
                                count++;
                        end
                        $display("----------------------------------------------                                                                                        -------");
                end
                $display("Total Fails = %0d", count);
        endtask
endclass
