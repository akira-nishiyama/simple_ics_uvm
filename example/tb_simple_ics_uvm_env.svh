// tb_simple_ics_uvm_env
//      This file implements the testbench environment for simple_ics_uvm_pkg.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class tb_simple_ics_uvm_env extends uvm_env;
    `uvm_component_utils(tb_simple_ics_uvm_env)
    //`uvm_new_func
    simple_ics_env ics_env;
    gp_scoreboard#(simple_ics_seq_item) ics_scrbd;
    uvm_analysis_port#(simple_ics_seq_item) item_port;
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_port = new("item_port",this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ics_env  = simple_ics_env::type_id::create("ics_env",this);
        ics_scrbd = gp_scoreboard#(simple_ics_seq_item)::type_id::create("ics_scrbd",this);
        uvm_config_db #(uvm_analysis_port#(simple_ics_seq_item))::set(uvm_root::get(), "*", "scrbd_item_port", item_port);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        item_port.connect(ics_scrbd.ap_exp);
        ics_env.monitor.item_port.connect(ics_scrbd.ap_obs);
    endfunction
endclass

