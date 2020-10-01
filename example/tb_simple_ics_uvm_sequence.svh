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
    uvm_analysis_port#(simple_ics_seq_item) item_port;
    function new(string name="issue_one_trans_ics_seq");
        super.new(name);
    endfunction
    virtual task body();
        logic[7:0] config_data[];
        //simple_uart_seq_item trans_item;
        simple_ics_seq_item trans_item;
        simple_ics_seq_item trans_item2;
        if(!uvm_config_db #(uvm_analysis_port#(simple_ics_seq_item))::get(get_sequencer(),"", "scrbd_item_port", item_port)) begin
            uvm_report_fatal("CONFIG_DB_ERROR", "Could not find scrbd_item_port.");
        end
        //position
        `uvm_create(trans_item)
        `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::POSITION;})
        trans_item.print();
        item_port.write(trans_item);
        `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::POSITION_R;})
        trans_item.print();
        item_port.write(trans_item);
        //read
        `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::READ;})
        trans_item.print();
        item_port.write(trans_item);
        `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::READ_R;sub_cmd==simple_ics_seq_item::TCH;})
        trans_item.print();
        item_port.write(trans_item);
        //read eeprom reply
        config_data = { 8'h00,8'h00,8'h01,8'h00,8'h00,8'h00,8'h00,8'h00,
                        8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                        8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                        8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                        8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                        8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                        8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                        8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00};
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
        item_port.write(trans_item);
        finish_item(trans_item);

        trans_item.print();
        //write
        `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::WRITE;sub_cmd==simple_ics_seq_item::CUR;})
        trans_item.print();
        item_port.write(trans_item);
        `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::WRITE_R;sub_cmd==simple_ics_seq_item::CUR;})
        trans_item.print();
        item_port.write(trans_item);
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
        item_port.write(trans_item);
        finish_item(trans_item);

        trans_item.print();
        `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::WRITE_R;sub_cmd==simple_ics_seq_item::EEPROM;})
        trans_item.print();
        item_port.write(trans_item);
        #2000000;
    endtask
endclass

class issue_seq_for_ics_slave_test extends simple_uart_base_sequence;
    `uvm_object_utils(issue_seq_for_ics_slave_test)
    uvm_analysis_port#(simple_ics_seq_item) item_port;
    function new(string name="issue_one_trans_ics_seq");
        super.new(name);
    endfunction
    virtual task body();
        logic[7:0] config_data[];
        //simple_uart_seq_item trans_item;
        simple_ics_seq_item trans_item;
        simple_ics_seq_item trans_item2;
        if(!uvm_config_db #(uvm_analysis_port#(simple_ics_seq_item))::get(get_sequencer(),"", "slave_test_item_port", item_port)) begin
            uvm_report_fatal("CONFIG_DB_ERROR", "Could not find slave_test_item_port.");
        end
        #5000000;
        //position
        `uvm_create(trans_item)
        `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::POSITION;})
        trans_item.print();
        //reply
        trans_item.cmd = simple_ics_seq_item::POSITION_R;
        item_port.write(trans_item);
        #10000000;
        //read
        `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::READ;sub_cmd==simple_ics_seq_item::TCH;})
        trans_item.print();
        trans_item.cmd = simple_ics_seq_item::READ_R;
        trans_item.data = 0;
        item_port.write(trans_item);
        #10000000;
        `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::READ;sub_cmd==simple_ics_seq_item::EEPROM;})
        trans_item.print();
        //reply
        trans_item.cmd = simple_ics_seq_item::READ_R;
        trans_item.data = 0;
        config_data = { 8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                        8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                        8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                        8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                        8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                        8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                        8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,
                        8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00};
        trans_item.eeprom_data = config_data;
        item_port.write(trans_item);
        #10000000;
        //write
        `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::WRITE;sub_cmd==simple_ics_seq_item::CUR;})
        trans_item.print();
        //reply
        trans_item.cmd = simple_ics_seq_item::WRITE_R;
        item_port.write(trans_item);
        #10000000;
        //write eeprom
        `uvm_create(trans_item)
        start_item(trans_item);
        assert(trans_item.randomize());
        trans_item.cmd = simple_ics_seq_item::WRITE;
        trans_item.sub_cmd= simple_ics_seq_item::EEPROM;
        trans_item.id = 1;
        trans_item.data = 0;
        config_data[1] = 8'h1;
        trans_item.eeprom_data = config_data;
        finish_item(trans_item);

        trans_item.print();
        //reply
        trans_item.cmd = simple_ics_seq_item::WRITE_R;
        trans_item.eeprom_data = {};
        item_port.write(trans_item);
        #10000000;
        //readback eeprom
        `uvm_do_with(trans_item,{cmd==simple_ics_seq_item::READ;id==1;sub_cmd==simple_ics_seq_item::EEPROM;})
        trans_item.print();
        //reply
        trans_item.cmd = simple_ics_seq_item::READ_R;
        trans_item.eeprom_data = config_data;
        item_port.write(trans_item);
        #10000000;
    endtask
endclass


