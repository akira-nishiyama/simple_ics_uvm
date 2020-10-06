// ics_reactive_seq.svh
//      This file implements the ics reactive sequence.
//      Receive simple_ics_seq_item from monitor and
//      Transmit responce simple_ics_seq_item to the simple_ics_env sequencer.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class ics_reactive_seq extends uvm_sequence #(simple_ics_seq_item);
    `uvm_object_utils(ics_reactive_seq)
    simple_ics_seq_item received_item;
    simple_ics_seq_item responce_item;
    uvm_tlm_analysis_fifo#(simple_ics_seq_item) react_req_fifo;
    simple_ics_slave_storage storage;
    int baud_rate;
    int bit_period;
    int stop_bit_num;
    bit parity_enable;

    function new(string name="ics_reactive_seq");
        super.new(name);
    endfunction

    task body();
        logic[7:0]      rdata;

        if(!uvm_config_db #(uvm_tlm_analysis_fifo#(simple_ics_seq_item))::get(get_sequencer(), "", "react_req_fifo", react_req_fifo)) begin
            `uvm_fatal("CONFIG_DB_ERROR", "Could not find react_req_fifo")
        end
        if(!uvm_config_db #(simple_ics_slave_storage)::get(get_sequencer(),"", "storage", storage)) begin
            `uvm_fatal("CONFIG_DB_ERROR", "Could not find simple_ics_slave_storage")
        end
        //baud rate
        if(!uvm_config_db#(int)::get(get_sequencer(), "", "simple_uart_baud_rate", baud_rate)) begin
            uvm_report_info("CONFIG","baud rate set to default value(115200 bps)");
            baud_rate = 115200;//default value
        end
        case(baud_rate)
            115200: bit_period = 8681;//8680.6 ns for 115200 bps.
            default: `uvm_fatal("CONFIG_ERR","Undefined baud rate.")
        endcase
        //parity enable flag
        if(!uvm_config_db#(bit)::get(get_sequencer(), "", "simple_uart_parity_enable", parity_enable)) begin
            uvm_report_info("CONFIG","parity_enable set to default value(enabled)");
            parity_enable = 1;//default value
        end
        //number of stop bit
        if(!uvm_config_db#(int)::get(get_sequencer(), "", "simple_uart_stop_bit_num", stop_bit_num)) begin
            uvm_report_info("CONFIG","number of stop bit set to default value(1bit)");
            stop_bit_num = 1;//default value
        end

        forever begin
            react_req_fifo.get(received_item);
            uvm_report_info("REACT","get item");
            #(bit_period*(0.2+stop_bit_num+parity_enable));
            received_item.print();
            responce_item = new();

            case(received_item.cmd)
                simple_ics_seq_item::POSITION_R: uvm_report_fatal("REACT", "Invalid POSITION_R command received.");
                simple_ics_seq_item::READ_R: uvm_report_fatal("REACT", "Invalid READ_R command received.");
                simple_ics_seq_item::WRITE_R: uvm_report_fatal("REACT", "Invalid WRITE_R command received.");
                simple_ics_seq_item::ID_R: uvm_report_fatal("REACT", "Invalid ID_R command received.");
                simple_ics_seq_item::POSITION:
                    begin
                        storage.write_reg(received_item.id, simple_ics_seq_item::TCH, received_item.data);
                        responce_item.cmd = simple_ics_seq_item::POSITION_R;
                        responce_item.id = received_item.id;
                        responce_item.data = storage.read_reg(received_item.id, simple_ics_seq_item::TCH);
                    end
                simple_ics_seq_item::READ:
                    begin
                        responce_item.cmd = simple_ics_seq_item::READ_R;
                        responce_item.id = received_item.id;
                        if(received_item.sub_cmd === simple_ics_seq_item::EEPROM) begin
                            logic[7:0] eeprom[0:63];
                            //responce_item.eeprom_data = new[64];
                            storage.read_mem(received_item.id, eeprom);
                            responce_item.eeprom_data = eeprom;
                        end else begin
                            responce_item.sub_cmd = received_item.sub_cmd;
                            responce_item.data = storage.read_reg(received_item.id, received_item.sub_cmd);
                        end
                    end
                simple_ics_seq_item::WRITE:
                    begin
                        responce_item.cmd = simple_ics_seq_item::WRITE_R;
                        responce_item.id = received_item.id;
                        if(received_item.sub_cmd === simple_ics_seq_item::EEPROM) begin
                            storage.write_mem(received_item.id, received_item.eeprom_data);
                            responce_item.sub_cmd = simple_ics_seq_item::EEPROM;
                            responce_item.data = 0;
                        end else begin
                            storage.write_reg(received_item.id, received_item.sub_cmd, received_item.data);
                            responce_item.sub_cmd = received_item.sub_cmd;
                            responce_item.data = storage.read_reg(received_item.id, received_item.sub_cmd);
                        end
                    end
                simple_ics_seq_item::ID:
                    begin
                        uvm_report_fatal("REACT", "ID command is not implemented yet.");
                    end
            endcase
            responce_item.print();
            `uvm_send(responce_item);
        end
    endtask

endclass
