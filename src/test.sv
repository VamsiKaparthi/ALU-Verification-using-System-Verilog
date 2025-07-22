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
