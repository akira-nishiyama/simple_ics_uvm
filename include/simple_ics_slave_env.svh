// simple_ics_slave_env.svh
//      This file implements the simple_ics_uvm slave environment for simple_ics_uvm_pkg.
//      This environment has simple_ics_env and the slave wrapper.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class simple_ics_slave_env extends uvm_env;
    `uvm_component_utils(simple_ics_slave_env)
    `uvm_new_func
    simple_ics_env ics_env;
    simple_ics_slave_storage storage;
    uvm_tlm_analysis_fifo#(simple_ics_seq_item) react_req_fifo;
    //uvm_sequencer#(simple_ics_seq_item) sequencer;
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ics_env = simple_ics_env::type_id::create("ics_env",this);
        react_req_fifo = new("react_req_fifo",this);
        storage = simple_ics_slave_storage::type_id::create("storage",this);
        storage.init();
        uvm_config_db #(uvm_tlm_analysis_fifo#(simple_ics_seq_item))::set(this, "*", "react_req_fifo", react_req_fifo);
        uvm_config_db #(simple_ics_slave_storage)::set(this, "*", "storage", storage);
    endfunction

    function void connect_phase(uvm_phase phase);
        ics_env.monitor.react_req_port.connect(react_req_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        ics_reactive_seq reactive_seq;
        reactive_seq = ics_reactive_seq::type_id::create("reactive_seq",this);
        //reactive_seq.up_sequencer = sequencer;
        reactive_seq.start(ics_env.sequencer);
    endtask
endclass

