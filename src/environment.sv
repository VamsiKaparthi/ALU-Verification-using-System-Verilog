class environment;
        //interfaces
        virtual alu_if inf;
        //Mailboxes
        mailbox #(transaction) mgd;
        mailbox #(transaction) mdr;
        mailbox #(transaction) mrs;
        mailbox #(transaction) mms;
        //testbench components
        generator gen;
        driver drv;
        reference rf;
        monitor mon;
        function new(virtual alu_if inf);
                this.inf = inf;
        endfunction

        task build(); //this task is for creating objects for mailboxes and classes of testbench components
                begin
                        //Create objects for mailbox
                        mgd = new(); //generator to driver mailbox
                        mrs = new();
                        mdr = new();
                        mms = new();
                        //Create objects for testbench components.
                        gen = new(mgd);
                        drv = new(mgd, mdr, inf);
                        rf = new(mdr, mrs, inf);
                        mon = new(mms, inf);
                end
        endtask

        task start();
                fork
                        gen.start();
                        drv.start();
                        rf.start();
                        mon.start();
                join
        endtask

endclass
