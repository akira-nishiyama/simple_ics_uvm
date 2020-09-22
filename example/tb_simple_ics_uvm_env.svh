// tb_simple_ics_uvm_env
//      This file implements the testbench environment for simple_ics_uvm_pkg.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class tb_simple_ics_uvm_env extends uvm_env;
    `uvm_component_utils(tb_simple_ics_uvm_env)
    `uvm_new_func
    //simple_uart_agent uart_agent;
    simple_ics_env ics_env;
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //uart_agent = simple_uart_agent::type_id::create("uart_agent",this);
        ics_env  = simple_ics_env::type_id::create("ics_env",this);
    endfunction
endclass

