// simple_ics_seq_item.svh
//      This file implements the sequence_item for simple_ics.
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class simple_ics_seq_item extends uvm_sequence_item;
    typedef enum{   POSITION_R  = 3'b000,   READ_R  = 3'b001,
                    WRITE_R     = 3'b010,   ID_R    = 3'b011,
                    POSITION    = 3'b100,   READ    = 3'b101,
                    WRITE       = 3'b110,   ID      = 3'b111} ics_command;
    typedef enum{   EEPROM=8'h00,       STRC=8'h01,
                    SPD   =8'h02,       CUR =8'h03,
                    TMP   =8'h04,       TCH =8'h05} ics_subcommand;
    typedef enum{   ID_READ = 8'h00, ID_WRITE = 8'h01} ics_id_subcommand;
    rand ics_command cmd;
    rand logic[4:0] id;
    rand ics_id_subcommand id_sub_cmd;
    rand ics_subcommand sub_cmd;
    rand logic[13:0] data;
    rand logic[7:0] eeprom_data[];

    `uvm_object_utils_begin(simple_ics_seq_item)
        `uvm_field_enum (ics_command, cmd, UVM_DEFAULT)
        `uvm_field_int (id, UVM_DEFAULT | UVM_HEX)
        `uvm_field_enum (ics_subcommand, sub_cmd, UVM_DEFAULT)
        `uvm_field_enum (ics_id_subcommand, id_sub_cmd, UVM_DEFAULT)
        `uvm_field_int (data, UVM_DEFAULT | UVM_HEX)
        `uvm_field_array_int (eeprom_data, UVM_DEFAULT | UVM_HEX)
    `uvm_object_utils_end
    function new (string name = "simple_ics_seq_item_inst");
        super.new(name);
    endfunction : new
endclass

