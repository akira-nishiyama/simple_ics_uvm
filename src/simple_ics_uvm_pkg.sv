// simple_ics_uvm_pkg.sv
//      This file implements the simple_ics_uvm_pkg for simulation with uvm.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

package simple_ics_uvm_pkg;

    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import simple_uart_uvm_pkg::*;
    `include "simple_ics_seq_item.svh"
    `include "ics_item_to_uart_item_seq.svh"
//    `include "simple_ics_driver.svh"
//    `include "simple_ics_monitor.svh"
//    `include "simple_ics_slave_agent.svh"
    `include "simple_ics_env.svh"
//    `include "simple_ics_base_sequence.svh"
endpackage

