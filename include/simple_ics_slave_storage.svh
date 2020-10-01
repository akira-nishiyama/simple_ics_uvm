// simple_ics_slave_storage.svh
//      This file implements the simple_ics_slave_env storage.
//      This storage has 32 ics slave device memory and registers.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class simple_ics_slave_storage extends uvm_component;
    `uvm_component_utils(simple_ics_slave_storage)

    logic[ 7:0] eeprom[0:31][0:63];
    logic[ 7:0] reg_strc[0:31];
    logic[ 7:0] reg_spd[0:31];
    logic[ 7:0] reg_cur[0:31];
    logic[ 7:0] reg_tmp[0:31];
    logic[13:0] reg_tch[0:31];
    bit init_random_flag = 0;
    logic[ 7:0] seed = 0;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void write_reg(int id, simple_ics_seq_item::ics_subcommand sub_cmd, logic[13:0] data);
        uvm_report_info("STRG", $sformatf("write_reg:id=%02d, sub_cmd=%p, data=%04x",id,sub_cmd,data));
        case(sub_cmd)
            simple_ics_seq_item::STRC: reg_strc[id] = data[7:0];
            simple_ics_seq_item::SPD:  reg_spd[id]  = data[7:0];
            simple_ics_seq_item::CUR:  reg_cur[id]  = data[7:0];
            simple_ics_seq_item::TMP:  reg_tmp[id]  = data[7:0];
            simple_ics_seq_item::TCH:  reg_tch[id]  = data[13:0];
        endcase
    endfunction

    function void write_mem(int id, logic[7:0] data[0:63]);
        eeprom[id] = data;
//        for(int i = 0; i < 64; ++i) begin
//            eeprom[id][i] = data[i];
//        end
    endfunction

    function logic[13:0] read_reg(int id, simple_ics_seq_item::ics_subcommand sub_cmd);
        logic[13:0] val;
        case(sub_cmd)
            simple_ics_seq_item::STRC: val = reg_strc[id];
            simple_ics_seq_item::SPD:  val = reg_spd[id];
            simple_ics_seq_item::CUR:  val = reg_cur[id];
            simple_ics_seq_item::TMP:  val = reg_tmp[id];
            simple_ics_seq_item::TCH:  val = reg_tch[id];
        endcase
        uvm_report_info("STRG", $sformatf("read_reg:id=%02d, sub_cmd=%p, data=%04x",id,sub_cmd, val));
        return val;
    endfunction

    function void read_mem(int id, ref logic[7:0] data[0:63]);
        data = eeprom[id];
    endfunction

    function void init();
        if(init_random_flag  === 0) begin
            for(int i = 0; i < 32; ++i) begin
                for(int j = 0; j < 64; ++j) begin
                    eeprom[i][j] = 0;
                end
                reg_strc[i] = 0;
                reg_spd[i]  = 0;
                reg_cur[i]  = 0;
                reg_tmp[i]  = 0;
                reg_tch[i]  = 0;
            end
        end else begin
            int rand_val = seed;
            for(int i = 0; i < 32; ++i) begin
                for(int j = 0; j < 64; ++j) begin
                    eeprom[i][j] = $random(rand_val);
                end
                reg_strc[i] = $random(rand_val);
                reg_spd[i]  = $random(rand_val);
                reg_cur[i]  = $random(rand_val);
                reg_tmp[i]  = $random(rand_val);
                reg_tch[i]  = $random(rand_val);
            end
        end
    endfunction

endclass

