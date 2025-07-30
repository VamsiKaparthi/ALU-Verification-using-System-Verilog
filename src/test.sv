class test;
        virtual alu_if drv_vif; //driver to dut interface

        function new(virtual alu_if drv_vif);
                this.drv_vif = drv_vif;
        endfunction

        task run();
                environment e1 = new(drv_vif); //creating environment class
                e1.build; //creating instances in environment
                e1.start; //startimg the process
        endtask
endclass

class test_sl extends test;
        single_logical pkt;
        function new(virtual alu_if drv_vif);
                super.new(drv_vif);
        endfunction
        task run();
                environment e1 = new(drv_vif);
                e1.build;
                begin
                        pkt = new();
                        e1.gen.pkt = this.pkt;
                end
                e1.start;
        endtask
endclass

class test_sa extends test;
        single_arithmetic pkt;
        function new(virtual alu_if drv_vif);
                super.new(drv_vif);
        endfunction
        task run();
                environment e1 = new(drv_vif);
                e1.build;
                begin
                        pkt = new();
                        e1.gen.pkt = this.pkt;
                end
                e1.start;
        endtask
endclass

class test_tl extends test;
        two_logical pkt;
        function new(virtual alu_if drv_vif);
                super.new(drv_vif);
        endfunction
        task run();
                environment e1 = new(drv_vif);
                e1.build;
                begin
                        pkt = new();
                        e1.gen.pkt = this.pkt;
                end
                e1.start;
        endtask
endclass

class test_ta extends test;
        two_arithmetic pkt;
        function new(virtual alu_if drv_vif);
                super.new(drv_vif);
        endfunction
        task run();
                environment e1 = new(drv_vif);
                e1.build;
                begin
                        pkt = new();
                        e1.gen.pkt = this.pkt;
                end
                e1.start;
        endtask
endclass

class test_regression extends test;
        transaction t1;
        single_logical t2;
        single_arithmetic t3;
        two_logical t4;
        two_arithmetic t5;

        function new(virtual alu_if drv_vif);
                super.new(drv_vif);
        endfunction

        task run();
                //build env
                environment e1 = new(drv_vif);
                e1.build();
                //base test
                t1 = new();
                e1.gen.pkt = t1;
                e1.start();

                //single logical
                t2 = new();
                e1.gen.pkt = t2;
                e1.start();

                //single arithmetic
                t3 = new();
                e1.gen.pkt = t3;
                e1.start();

                //two logical
                t4 = new();
                e1.gen.pkt = t4;
                e1.start();

                //two arithmetic
                t5 = new();
                e1.gen.pkt = t5;
                e1.start();
        endtask
endclass
