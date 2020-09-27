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

    //if cmd is not equals to ID_R or ID, id_sub_cmd is fixed to ID_READ.
    constraint c_id_subcommand { !((cmd == ID) || (cmd == ID_R)) -> id_sub_cmd == ID_READ;}
    //if cmd equals to POSITION_R or POSITION, sub_cmd is fixed to EEPROM.
    constraint c_sub_cmd { (cmd == POSITION_R || cmd == POSITION) -> sub_cmd == EEPROM;}
    //if cmd equals to WRITE or WRITE_R, sub_cmd is not TCH.
    constraint c_sub_cmd2 { (cmd == WRITE || cmd == WRITE_R) -> sub_cmd != TCH;}
    //if cmd equals to READ or READ_R and sub_cmd equals EEPROM, data should be zero.
    constraint c_data { (cmd == READ || (cmd == READ_R && sub_cmd == EEPROM)) -> data == 0;}
    //if cmd equals to WRITE or WRITE_R and sub_cmd equals to EEPROM, data should be zero.
    constraint c_data2 { ((cmd == WRITE || cmd == WRITE_R) && sub_cmd == EEPROM) -> data == 0;}
    //if cmd equals to READ_R and sub_cmd equals to EEPROM or TCH, data should be less than 256
    constraint c_data3 { (cmd == READ_R && (sub_cmd == EEPROM || sub_cmd == TCH)) -> data < 256;}
    //if cmd equals to WRITE or WRITE_R and sub_cmd not equals to EEPROM, data should be less than 256
    constraint c_data4 { ((cmd == WRITE || cmd == WRITE_R) && sub_cmd != EEPROM) -> data < 256;}

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

