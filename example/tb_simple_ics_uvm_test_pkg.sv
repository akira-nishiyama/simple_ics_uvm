// tb_simple_ics_uvm_test_pkg.svh
//      This file implements the test package for tb_simple_ics_uvm.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

package tb_simple_ics_uvm_test_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import simple_uart_uvm_pkg::*;
    import simple_ics_uvm_pkg::*;
    `include "tb_simple_ics_uvm_env.svh"
    `include "tb_simple_ics_uvm_sequence.svh"
    `include "tb_simple_ics_uvm_test.svh"

endpackage
