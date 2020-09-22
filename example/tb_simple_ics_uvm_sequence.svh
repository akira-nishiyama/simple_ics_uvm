// tb_simple_ics_uvm_sequence
//      This file implements the sequence for simple_ics_uvm_pkg.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class issue_one_trans_seq extends simple_uart_base_sequence;
    `uvm_object_utils(issue_one_trans_seq)
    function new(string name="issue_one_trans_seq");
        super.new(name);
    endfunction
  virtual task body();
    simple_uart_seq_item trans_item;
    `uvm_create(trans_item)
    `uvm_do(trans_item)
    //`uvm_send(trans_item)
    #1000;
  endtask
endclass

class issue_one_trans_ics_seq extends simple_uart_base_sequence;
    `uvm_object_utils(issue_one_trans_ics_seq)
    function new(string name="issue_one_trans_ics_seq");
        super.new(name);
    endfunction
  virtual task body();
    logic[7:0] config_data[];
    //simple_uart_seq_item trans_item;
    simple_ics_seq_item trans_item;
    simple_ics_seq_item trans_item2;
    //position
    `uvm_create(trans_item)
    `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::POSITION;})
    trans_item.print();
    `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::POSITION_R;})
    trans_item.print();
    //read
    `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::READ;})
    trans_item.print();
    `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::READ_R;sub_cmd==simple_ics_seq_item::TCH;})
    trans_item.print();
    //read eeprom reply
    config_data = { 8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                    8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                    8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                    8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                    8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                    8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                    8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                    8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00};
//    foreach(config_data[i]) $display("config_data[%d]=%h",i,config_data[i]);
//    `uvm_do_with(trans_item,{   trans_item.cmd==simple_ics_seq_item::READ_R;trans_item.sub_cmd==simple_ics_seq_item::EEPROM; \
//                                foreach( config_data[i] ) { trans_item.eeprom_data[i] == config_data[i]; } trans_item.eeprom_data.size==64; })
    `uvm_create(trans_item)
    start_item(trans_item);
    assert(trans_item.randomize());
    trans_item.cmd = simple_ics_seq_item::READ_R;
    trans_item.sub_cmd = simple_ics_seq_item::EEPROM;
    trans_item.data = 0;
    trans_item.eeprom_data = new[64];
    foreach(config_data[i]) begin
        trans_item.eeprom_data[i] = config_data[i];
    end
    finish_item(trans_item);

    trans_item.print();
    //write
    `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::WRITE;sub_cmd==simple_ics_seq_item::CUR;})
    trans_item.print();
    `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::WRITE_R;sub_cmd==simple_ics_seq_item::CUR;})
    trans_item.print();
    //write eeprom
    `uvm_create(trans_item)
    start_item(trans_item);
    assert(trans_item.randomize());
    trans_item.cmd = simple_ics_seq_item::WRITE;
    trans_item.sub_cmd= simple_ics_seq_item::EEPROM;
    trans_item.data = 0;
    trans_item.eeprom_data = new[64];
    foreach(config_data[i]) begin
        trans_item.eeprom_data[i] = config_data[i];
    end
    finish_item(trans_item);

    trans_item.print();
    `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::WRITE_R;sub_cmd==simple_ics_seq_item::EEPROM;})
    trans_item.print();
    //id read
//    `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::ID; id_sub_cmd==simple_ics_seq_item::ID_READ;})
//    trans_item.print();
//    `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::ID_R;})
//    trans_item.print();
    //id write
//    `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::ID; id_sub_cmd==simple_ics_seq_item::ID_WRITE;})
//    trans_item.print();
//    `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::ID_R;})
//    trans_item.print();
    #1000;
  endtask
endclass

