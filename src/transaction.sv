class transaction;
        //inputs
        rand bit[W - 1 : 0] opa, opb;
        rand bit cin;
        rand bit mode;
        rand bit [1:0] inp_valid;
        rand bit [3:0] cmd;

        constraint c1 {/*inp_valid dist {0:=10, 1:=10, 2:=40, 3:=20};*/ mode == 0; cmd == 1;}
        //outputs
        bit [W : 0] res;
        bit oflow;
        bit cout;
        bit g, l , e;
        bit err;

        function transaction copy();
                copy = new();
                copy.opa = this.opa;
                copy.opb = this.opb;
                copy.cin = this.cin;

                copy.mode = this.mode;
                copy.inp_valid = this.inp_valid;
                copy.cmd = this.cmd;
        endfunction
endclass
