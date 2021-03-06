// tb_simple_ics_uvm_test.svh
//      This file implements the test for tb_simple_ics_uvm.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class simple_ics_uvm_test_example extends uvm_test;
    `uvm_component_utils(simple_ics_uvm_test_example)
    `uvm_new_func
    tb_simple_ics_uvm_env env;
    virtual function void build_phase(uvm_phase phase);
        env=tb_simple_ics_uvm_env::type_id::create("tb_simple_ics_uvm_env",this);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        //issue_one_trans_seq seq = issue_one_trans_seq::type_id::create("seq");
        issue_one_trans_ics_seq seq2 = issue_one_trans_ics_seq::type_id::create("seq2");
        uvm_report_info("TEST", "simple_ics_uvm_test_example running");
        phase.raise_objection(this);
        //seq.start(env.uart_agent.sequencer);
        seq2.start(env.ics_env.sequencer);
        phase.drop_objection(this);
    endtask
endclass
