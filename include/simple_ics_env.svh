// simple_ics_env.svh
//      This file implements the simple_ics_uvm environment for simple_ics_uvm_pkg.
//      ICS environment has simple_uart_agent and the wrapper uvm_component
//      to handle ICS protocol.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class simple_ics_env extends uvm_env;
    `uvm_component_utils(simple_ics_env)
    `uvm_new_func
    simple_uart_agent agent;
    uvm_sequencer#(simple_ics_seq_item) sequencer;
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = simple_uart_agent::type_id::create("agent",this);
        sequencer = uvm_sequencer#(simple_ics_seq_item)::type_id::create("sequencer",this);
    endfunction
    task run_phase(uvm_phase phase);
        ics_item_to_uart_item_seq ics2uart_seq;
        ics2uart_seq = ics_item_to_uart_item_seq::type_id::create("ics2uart_seq",this);
        ics2uart_seq.up_sequencer = sequencer;
        ics2uart_seq.start(agent.sequencer);
    endtask
endclass

