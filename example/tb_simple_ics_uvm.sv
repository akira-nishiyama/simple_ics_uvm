// tb_simple_ics_uvm.sv
//      This file implements the test example for simple_ics_uvm.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

module tb_simple_ics_uvm;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    //import simple_uart_uvm_pkg::*;
    import tb_simple_ics_uvm_test_pkg::*;
    
    logic clk, rstz;
    simple_uart_if sif();// interface
    simple_uart_if sif2();// interface
    logic ics_sig_from_dut;
    initial begin
        fork
            begin
                clk = 1'b1;
                #100;
                forever #10 clk = ~clk;
            end
            begin
                rstz = 1'b0;
                #100;
                rstz = 1'b1;
            end
        join
    end

    initial begin
        ics_sig_from_dut <= 1;
        forever begin
            #50;
            ics_sig_from_dut <= 1'b1;
            #50;
            ics_sig_from_dut <= 1'bz;
            #50;
            ics_sig_from_dut <= 1'b0;
        end
    end

    //assign sif.posi = ics_sig_from_dut;
    //pullup(ics_sig_from_dut);
    //assign ics_sig_from_dut = (sif.piso === 1'b0) ? 0 : ics_sig_from_dut;
    assign sif.posi = sif2.piso;
    assign sif2.posi = sif.piso;

    initial begin
        set_global_timeout(100000000ns);
        uvm_config_db#(virtual simple_uart_if)::set(uvm_root::get(), "uvm_test_top.tb_simple_ics_uvm_env.uart_agent*", "vif", sif);
        uvm_config_db#(virtual simple_uart_if)::set(uvm_root::get(), "uvm_test_top.tb_simple_ics_uvm_env.ics_env.agent*", "vif", sif2);
        run_test("simple_ics_uvm_test_example");
    end

endmodule

