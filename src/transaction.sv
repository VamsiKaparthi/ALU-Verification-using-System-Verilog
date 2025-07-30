class transaction;
        //inputs
        rand logic[W - 1 : 0] opa, opb;
        rand logic cin;
        rand logic mode;
        rand logic [1:0] inp_valid;
        rand logic [3:0] cmd;

//      constraint c1 {/*inp_valid dist {0:=10, 1:=10, 2:=40, 3:=20};*/ mode == 1; cmd == 9; inp_valid == 3;}
        //outputs
        logic [W : 0] res;
        logic oflow;
        logic cout;
        logic g, l , e;
        logic err;

        virtual function transaction copy();
                copy = new();
                copy.opa = this.opa;
                copy.opb = this.opb;
                copy.cin = this.cin;
                copy.mode = this.mode;
                copy.inp_valid = this.inp_valid;
                copy.cmd = this.cmd;
                return copy;
        endfunction
endclass

class single_logical extends transaction;
        constraint CMD {cmd inside {[6:11]};}
        constraint MODE {mode == 0;}
        constraint IP {inp_valid == 3;}
        virtual function transaction copy();
                single_logical copy1;
                copy1 = new();
                copy1.opa = this.opa;
                copy1.opb = this.opb;
                copy1.cin = this.cin;
                copy1.mode = this.mode;
                copy1.inp_valid = this.inp_valid;
                copy1.cmd = this.cmd;
                return copy1;
        endfunction
endclass

class single_arithmetic extends transaction;
        constraint CMD {cmd inside {[4:7]};}
        constraint MODE {mode == 1;}
        constraint IP {inp_valid == 3;}
        virtual function single_arithmetic copy();
                copy = new();
                copy.opa = this.opa;
                copy.opb = this.opb;
                copy.cin = this.cin;
                copy.mode = this.mode;
                copy.inp_valid = this.inp_valid;
                copy.cmd = this.cmd;
                return copy;
        endfunction
endclass

class two_logical extends transaction;
        constraint CMD {cmd inside {0,1,2,3,4,5,12,13};}
        constraint MODE {mode == 0;}
        constraint IP {inp_valid == 3;}
        virtual function two_logical copy();
                copy = new();
                copy.opa = this.opa;
                copy.opb = this.opb;
                copy.cin = this.cin;
                copy.mode = this.mode;
                copy.inp_valid = this.inp_valid;
                copy.cmd = this.cmd;
                return copy;
        endfunction
endclass

class two_arithmetic extends transaction;
        constraint CMD {cmd inside {0,1,2,3,8,9,10};}
        constraint MODE {mode == 1;}
        constraint IP {inp_valid == 3;}
        virtual function two_logical copy();
                copy = new();
                copy.opa = this.opa;
                copy.opb = this.opb;
                copy.cin = this.cin;
                copy.mode = this.mode;
                copy.inp_valid = this.inp_valid;
                copy.cmd = this.cmd;
                return copy;
        endfunction
endclass
