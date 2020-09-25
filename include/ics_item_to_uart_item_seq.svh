// ics_item_to_uart_item_seq.svh
//      This file implements the translation sequence
//      from simple_ics_seq_item to simple_uart_seq_item.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//
class ics_item_to_uart_item_seq extends uvm_sequence #(simple_uart_seq_item);
    `uvm_object_utils(ics_item_to_uart_item_seq)
    function new(string name="ics_item_to_uart_item");
        super.new(name);
    endfunction

    uvm_sequencer #(simple_ics_seq_item) up_sequencer;
    uvm_analysis_port#(simple_ics_seq_item) item_port;

    virtual task body();
        simple_ics_seq_item ics_item;
        simple_uart_seq_item uart_item;
        logic[4:0] id;
        bit enable_item_port = 0;
        //get item_port
        if(!uvm_config_db #(uvm_analysis_port#(simple_ics_seq_item))::get(null,"", "scrbd_item_port", item_port)) begin
            enable_item_port = 0;
            uvm_report_info("CONFIG","Could not find scrbd_item_port. Sequence item export function is disabled.");
            //`uvm_error("CONFIG_DB_ERROR", "Could not find config")
        end else begin
            uvm_report_info("CONFIG","scrbd_item_port found. Sequence item export function is enabled.");
            enable_item_port = 1;
        end
        forever begin
            up_sequencer.get_next_item(ics_item);
            if(enable_item_port) item_port.write(ics_item);
            uart_item = simple_uart_seq_item::type_id::create("test");
            id = ics_item.id;
            `uvm_create(uart_item)
            case(ics_item.cmd)
                simple_ics_seq_item::POSITION_R:
                    begin
                        `uvm_do_with(uart_item, {char=={simple_ics_seq_item::POSITION_R,id};})
                        `uvm_do_with(uart_item, {char=={0,ics_item.data[13:7]};})
                        `uvm_do_with(uart_item, {char=={0,ics_item.data[ 6:0]};})
                    end
                simple_ics_seq_item::READ_R:
                    begin
                        `uvm_do_with(uart_item, {char=={simple_ics_seq_item::READ_R,id};})
                        `uvm_do_with(uart_item, {char==ics_item.sub_cmd;})
                        if(ics_item.sub_cmd === simple_ics_seq_item::EEPROM) begin
                            for(int i = 0; i < 64; ++i) begin
                                `uvm_do_with(uart_item, {char==ics_item.eeprom_data[i];})
                            end
                        end else if(ics_item.sub_cmd === simple_ics_seq_item::TCH) begin
                            `uvm_do_with(uart_item, {char=={0,ics_item.data[13:7]};})
                            `uvm_do_with(uart_item, {char=={0,ics_item.data[ 6:0]};})
                        end else begin
                            `uvm_do_with(uart_item, {char==ics_item.data[7:0];})
                        end
                    end
                simple_ics_seq_item::WRITE_R:
                    begin
                        `uvm_do_with(uart_item, {char=={simple_ics_seq_item::WRITE_R,id};})
                        `uvm_do_with(uart_item, {char==ics_item.sub_cmd;})
                        if(ics_item.sub_cmd === simple_ics_seq_item::EEPROM) begin
                            //do nothing
                        end else begin
                            `uvm_do_with(uart_item, {char==ics_item.data[7:0];})
                        end
                    end
                simple_ics_seq_item::ID_R:
                    begin
                        `uvm_do_with(uart_item, {char=={simple_ics_seq_item::ID,id};})
                    end
                simple_ics_seq_item::POSITION:
                    begin
                        `uvm_do_with(uart_item, {char=={simple_ics_seq_item::POSITION,id};})
                        `uvm_do_with(uart_item, {char=={0,ics_item.data[13:7]};})
                        `uvm_do_with(uart_item, {char=={0,ics_item.data[ 6:0]};})
                    end
                simple_ics_seq_item::READ:
                    begin
                        `uvm_do_with(uart_item, {char=={simple_ics_seq_item::READ,id};})
                        `uvm_do_with(uart_item, {char==ics_item.sub_cmd;})
                    end
                simple_ics_seq_item::WRITE:
                    begin
                        `uvm_do_with(uart_item, {char=={simple_ics_seq_item::WRITE,id};})
                        `uvm_do_with(uart_item, {char==ics_item.sub_cmd;})
                        if(ics_item.sub_cmd === simple_ics_seq_item::EEPROM) begin
                            for(int i = 0; i < 64; ++i) begin
                                `uvm_do_with(uart_item, {char==ics_item.eeprom_data[i];})
                            end
                        end else begin
                            `uvm_do_with(uart_item, {char==ics_item.data[7:0];})
                        end
                    end
                simple_ics_seq_item::ID:
                    begin
                        if(ics_item.id_sub_cmd === simple_ics_seq_item::ID_READ) begin
                            `uvm_do_with(uart_item, {char==8'hff;})
                        end else begin
                            `uvm_do_with(uart_item, {char=={simple_ics_seq_item::ID,id};})
                        end
                        for(int i = 0; i < 3; ++i) begin
                            `uvm_do_with(uart_item, {char==ics_item.id_sub_cmd;})
                        end
                    end
            endcase
//            if(ics_item.cmd === simple_ics_seq_item::POSITION) begin
//                `uvm_do_with(uart_item, {char==8'h80;})
//            end
            //start_item(uart_item);
            //finish_item(uart_item);

            up_sequencer.item_done();
        end
    endtask

endclass
