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
    simple_uart_agent agent;
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = simple_uart_agent::type_id::create("agent",this);
    endfunction
endclass

