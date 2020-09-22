// uart_item_to_ics_item_monitor.svh
//      This file implements the translation sequence item
//      from simple_uart_seq_item to simple_ics_seq_item.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//
class uart_item_to_ics_item_monitor extends uvm_subscriber #(simple_uart_seq_item);
    // provides an analysis export of type C_item 
    `uvm_component_utils(uart_item_to_ics_item_monitor)
    uvm_analysis_port#(simple_ics_seq_item) item_port;
    simple_ics_seq_item mon_item;
    logic[7:0] data[$];

    // declarations omitted ...  
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_port = new("item_port",this);
    endfunction

    function void write(simple_uart_seq_item t);
        data.push_back(t.char);
        uvm_report_info("MON",$sformatf("receive:%02x",t.char));
        
        //foreach(data[i]) $display("data[%02x]:%x",i,data[i]);
        if(data.size > 0) begin
            uvm_report_info("MON",$sformatf("data[0]:%x",data[0]));
            case(data[0][7:5])
                simple_ics_seq_item::POSITION_R: begin
                        if(data.size === 3) begin
                            logic[7:0] d;
                            logic[13:0] tch;
                            mon_item = new();
                            //header
                            d = data.pop_front();
                            mon_item.cmd = simple_ics_seq_item::POSITION_R;
                            mon_item.id = d[4:0];
                            //tch_h
                            d = data.pop_front();
                            tch = {d,7'h0};
                            //tch_l
                            d = data.pop_front();
                            tch = tch + d;
                            mon_item.data = tch;
                            //output item
                            item_port.write(mon_item);
                            uvm_report_info("MON","position_r detect");
                        end
                    end
                simple_ics_seq_item::READ_R: begin
                        if(data.size > 2) begin
                            if(data[1][7:0] === simple_ics_seq_item::EEPROM) begin
                                if(data.size === 66) begin
                                    logic[7:0] d;
                                    mon_item = new();
                                    //header
                                    d = data.pop_front();
                                    mon_item.cmd = simple_ics_seq_item::READ_R;
                                    mon_item.id = d[4:0];
                                    //subcmd
                                    d = data.pop_front();
                                    mon_item.sub_cmd = simple_ics_seq_item::EEPROM;
                                    //eeprom data
                                    mon_item.eeprom_data = new[64];
                                    for(int i = 0; i < 64; ++i) begin
                                        mon_item.eeprom_data[i] = data.pop_front();
                                    end
                                    //output item
                                    item_port.write(mon_item);
                                    uvm_report_info("MON","read_r,subcmd eeprom detect");
                                end
                            end else if(data[1][7:0] == simple_ics_seq_item::TCH) begin
                                if(data.size == 4) begin
                                    logic[7:0] d;
                                    logic[13:0] tch;
                                    mon_item = new();
                                    //header
                                    d = data.pop_front();
                                    mon_item.cmd = simple_ics_seq_item::READ_R;
                                    mon_item.id = d[4:0];
                                    //subcmd
                                    d = data.pop_front();
                                    mon_item.sub_cmd = simple_ics_seq_item::TCH;
                                    //tch_h
                                    d = data.pop_front();
                                    tch = {d,7'h0};
                                    //tch_l
                                    d = data.pop_front();
                                    tch = tch + d;
                                    mon_item.data = tch;
                                    //output item
                                    item_port.write(mon_item);
                                    uvm_report_info("MON","read_r,subcmd tch detect");
                                end
                            end else begin
                                if(data.size === 3) begin
                                    logic[7:0] d;
                                    mon_item = new();
                                    //header
                                    d = data.pop_front();
                                    mon_item.cmd = simple_ics_seq_item::READ_R;
                                    mon_item.id = d[4:0];
                                    //subcmd
                                    d = data.pop_front();
                                    case(d[7:0])
                                        8'h0: uvm_report_fatal("MON","bug! never reach here");
                                        8'h1: mon_item.sub_cmd = simple_ics_seq_item::STRC;
                                        8'h2: mon_item.sub_cmd = simple_ics_seq_item::SPD;
                                        8'h3: mon_item.sub_cmd = simple_ics_seq_item::CUR;
                                        8'h4: mon_item.sub_cmd = simple_ics_seq_item::TMP;
                                        8'h5: uvm_report_fatal("MON","bug! never reach here");
                                    endcase
                                    //data
                                    d = data.pop_front();
                                    mon_item.data = d;
                                    //output item
                                    item_port.write(mon_item);
                                    uvm_report_info("MON","read_r,subcmd data detect");
                                end
                            end
                        end
                    end
                simple_ics_seq_item::WRITE_R: begin
                        if(data.size > 1) begin
                            if(data[1][7:0] === simple_ics_seq_item::EEPROM) begin
                                if(data.size === 2) begin
                                    logic[7:0] d;
                                    mon_item = new();
                                    //header
                                    d = data.pop_front();
                                    mon_item.cmd = simple_ics_seq_item::WRITE_R;
                                    mon_item.id = d[4:0];
                                    //subcmd
                                    d = data.pop_front();
                                    mon_item.sub_cmd = simple_ics_seq_item::EEPROM;
                                    //output item
                                    item_port.write(mon_item);
                                    uvm_report_info("MON","write_r,subcmd eeprom detect");
                                end
                            end else begin
                                if(data.size === 3) begin
                                    logic[7:0] d;
                                    mon_item = new();
                                    //header
                                    d = data.pop_front();
                                    mon_item.cmd = simple_ics_seq_item::WRITE_R;
                                    mon_item.id = d[4:0];
                                    //subcmd
                                    d = data.pop_front();
                                    case(d[7:0])
                                        8'h0: uvm_report_fatal("MON","bug! never reach here");
                                        8'h1: mon_item.sub_cmd = simple_ics_seq_item::STRC;
                                        8'h2: mon_item.sub_cmd = simple_ics_seq_item::SPD;
                                        8'h3: mon_item.sub_cmd = simple_ics_seq_item::CUR;
                                        8'h4: mon_item.sub_cmd = simple_ics_seq_item::TMP;
                                        8'h5: uvm_report_fatal("MON","bug! never reach here");
                                    endcase
                                    //data
                                    d = data.pop_front();
                                    mon_item.data = d;
                                    //output item
                                    item_port.write(mon_item);
                                    uvm_report_info("MON","write_r,subcmd data detect");
                                end
                            end
                        end
                    end
//                simple_ics_seq_item::ID_R: begin
//                        if(data.size === 1) begin
//                            logic[7:0] d;
//                            mon_item = new();
//                            //header
//                            d = data.pop_front();
//                            mon_item.cmd = simple_ics_seq_item::ID_R;
//                            mon_item.id = d[4:0];
//                            //output item
//                            item_port.write(mon_item);
//                            uvm_report_info("MON","id_r detect");
//                        end
//                    end
                simple_ics_seq_item::POSITION: begin
                        if(data.size === 3) begin
                            logic[7:0] d;
                            logic[13:0] tch;
                            mon_item = new();
                            //header
                            d = data.pop_front();
                            mon_item.cmd = simple_ics_seq_item::POSITION;
                            mon_item.id = d[4:0];
                            //tch_h
                            d = data.pop_front();
                            tch = {d,7'h0};
                            //tch_l
                            d = data.pop_front();
                            tch = tch + d;
                            //output item
                            mon_item.data = tch;
                            item_port.write(mon_item);
                            uvm_report_info("MON","position detect");
                        end
                    end
                simple_ics_seq_item::READ: begin
                        if(data.size === 2) begin
                            logic[7:0] d;
                            mon_item = new();
                            //header
                            d = data.pop_front();
                            mon_item.cmd = simple_ics_seq_item::READ;
                            mon_item.id = d[4:0];
                            //subcmd
                            d = data.pop_front();
                            case(d[7:0])
                                8'h0: mon_item.sub_cmd = simple_ics_seq_item::EEPROM;
                                8'h1: mon_item.sub_cmd = simple_ics_seq_item::STRC;
                                8'h2: mon_item.sub_cmd = simple_ics_seq_item::SPD;
                                8'h3: mon_item.sub_cmd = simple_ics_seq_item::CUR;
                                8'h4: mon_item.sub_cmd = simple_ics_seq_item::TMP;
                                8'h5: mon_item.sub_cmd = simple_ics_seq_item::TCH;
                            endcase
                            //output item
                            item_port.write(mon_item);
                            uvm_report_info("MON","read detect");
                        end
                    end
                simple_ics_seq_item::WRITE: begin
                        if(data.size > 2) begin
                            if(data[1][7:0] === simple_ics_seq_item::EEPROM) begin
                                if(data.size === 66) begin
                                    logic[7:0] d;
                                    mon_item = new();
                                    //header
                                    d = data.pop_front();
                                    mon_item.cmd = simple_ics_seq_item::WRITE;
                                    mon_item.id = d[4:0];
                                    //subcmd
                                    d = data.pop_front();
                                    mon_item.sub_cmd = simple_ics_seq_item::EEPROM;
                                    //eeprom data
                                    mon_item.eeprom_data = new[64];
                                    for(int i = 0; i < 64; ++i) begin
                                        mon_item.eeprom_data[i] = data.pop_front();
                                    end
                                    //output item
                                    item_port.write(mon_item);
                                    uvm_report_info("MON","write, subcmd eeprom detect");
                                end
                            end else begin
                                if(data.size === 3) begin
                                    logic[7:0] d;
                                    mon_item = new();
                                    //header
                                    d = data.pop_front();
                                    mon_item.cmd = simple_ics_seq_item::WRITE;
                                    mon_item.id = d[4:0];
                                    //subcmd
                                    d = data.pop_front();
                                    case(d[7:0])
                                        8'h0: uvm_report_fatal("MON","bug! never reach here");
                                        8'h1: mon_item.sub_cmd = simple_ics_seq_item::STRC;
                                        8'h2: mon_item.sub_cmd = simple_ics_seq_item::SPD;
                                        8'h3: mon_item.sub_cmd = simple_ics_seq_item::CUR;
                                        8'h4: mon_item.sub_cmd = simple_ics_seq_item::TMP;
                                        8'h5: uvm_report_fatal("MON","bug! never reach here");
                                    endcase
                                    //data
                                    d = data.pop_front();
                                    mon_item.data = d;
                                    //output item
                                    item_port.write(mon_item);
                                    uvm_report_info("MON","write, subcmd data detect");
                                end
                            end
                        end
                    end
                default: uvm_report_fatal("MON", "ID sub command is not valid for simulation");
//                simple_ics_seq_item::ID: begin
//                        if(data.size === 4) begin
//                            logic[7:0] d;
//                            mon_item = new();
//                            //header
//                            d = data.pop_front();
//                            mon_item.cmd = simple_ics_seq_item::ID;
//                            mon_item.id = d[4:0];
//                            //body
//                            repeat(4) uvm_report_info("MON",$sformatf("pop:%02x",data.pop_front()));
//                            uvm_report_info("MON","id detect");
//                        end
//                    end
            endcase
            //simple_ics_seq_item mon_item;
            //mon_item = new();
            //item_port.write(mon_item);
        end
    endfunction
endclass

