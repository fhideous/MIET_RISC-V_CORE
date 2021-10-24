`timescale 1ns / 1ps

`define B               instr[31]
`define C               instr[30]
`define WS              instr[29:28]
`define ALUop           instr[27:23]
`define RA1             instr[22:18]
`define RA2             instr[17:13]
`define const           instr[12:5]
`define WA              instr[4:0]

module control_unit(
    input         clk_i,
    input         nreset_i,
    input  [15:0] switches,
    output [31:0] data_to_hex
    );

    wire            reg_file_we_i;
    wire  [31:0]    reg_file_rd1_o;
    wire  [31:0]    reg_file_rd2_o;
    wire  [31:0]    data_sourse;

    RF rf_inst
    (
        .clk_i          (   clk_i           ),
        .nreset_i       (   nreset_i        ),
        
        .adr1_i         (   `RA1            ),
        .rd1_o          (   reg_file_rd1_o  ),
    
        .adr2_i         (   `RA2            ),
        .rd2_o          (   reg_file_rd2_o  ),
    
        .we_i           (   reg_file_we_i   ),
        .adr3_i         (   `WA             ),
        .wd3_i          (   data_sourse     )
        
    );

    assign data_to_hex = reg_file_rd1_o;
    
    wire   [31:0]   alu_res_o;

    riscV_alu alu_inst
    (
        .operator_i     (   `ALUop          ),      
        .operand_a_i    (   reg_file_rd1_o  ),
        .operand_b_i    (   reg_file_rd2_o  ),
        .result_o       (   alu_res_o       ),
        .flag_o         (   alu_flag_o      )
    );

    reg   [31:0]    prog_cnt;
    wire  [31:0]    instr;


    instr_mem instr_mem_inst
    (
        .adr_i          (      prog_cnt   ),
        .rd_o           (      instr      )
    );
    
    assign reg_file_we_i = ( `WS != 2'b00 ) ; 

    assign data_sourse  = (`WS == 2'b11 ? alu_res_o : 
                                `WS == 2'b01 ? { { 24{instr[12]   } }, `const   } :
                                                    { { 16{switches[15]} }, switches } );
 
 
    // always @( * ) begin
    //     case ( `WS )                                            
    //         01 : data_sourse = { { 24{instr[12]   } }, `const   } ;
    //         // 01 : data_sourse = `const;
    //         10 : data_sourse = { { 16{switches[16]} }, 16'b01111 } ;
    //         11 : data_sourse = alu_res_o;                    
    //     endcase
    // end

    always @(posedge clk_i) begin
        if ( !nreset_i )
            prog_cnt <= 'b0;
        else begin
            if (!`B && !`C)
                prog_cnt <= prog_cnt +     32'b1;
            else if (`B)
                prog_cnt <= prog_cnt + { { 24{instr[12]} }, `const };
            else if (`C && !`B) begin
                case ( alu_flag_o )
                    0 : prog_cnt <= prog_cnt +     32'b1;
                    1 : prog_cnt <= prog_cnt + { { 24{instr[12]} }, `const };
                endcase
            end 
        end
    end
endmodule
