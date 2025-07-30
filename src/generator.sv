class generator;
        mailbox #(transaction) mgd;
        transaction pkt;
        function new(mailbox #(transaction) mgd);
                this.mgd = mgd;
                pkt = new();
        endfunction
        task start();
                //pkt = new();
                repeat(num)begin
                        void'(pkt.randomize());
                        mgd.put(pkt.copy());
                        $display("\nThe Packet is generated with data : ");
                        $display("opa = %d | opb = %d | cin = %d | inp_valid = %d | mode = %d | cmd = %d", pkt.opa, pkt.opb, pkt.cin, pkt.inp_valid, pkt.mode, pkt.cmd);
                end
                $display("-------------------------------------------------------");
        endtask
endclass
