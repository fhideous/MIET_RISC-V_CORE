`timescale 1ns / 1ps

`define I_IMM           instr[31:20]
`define I_IMM_SIGN      instr[31]
`define U_IMM           instr[31:12]

module control_unit(
    input           clk_i,
    input           nreset_i,
    input  [15:0]   switches,
    );

    wire  [31:0]    instr;
    wire  [4:0]     alu_op_o;
    wire            mem_we_o;
    wire            ex_op_a_sel_o;
    wire            ex_op_b_sel_o;


    riscV_decode dec_inst
    (
        .fetched_instr_i    ( instr    ),
        .ex_op_a_sel_o      ( ex_op_a_sel_o  ),
        .ex_op_b_sel_o      ( ex_op_b_sel_o  ),
        .alu_op_o           ( alu_op_o ),
        .mem_req_o          (   ),
        .mem_we_o           ( mem_we_o ),
        .mem_size_o         (   ),
        .grp_we_a_o         (   ),
        .wb_src_sel_o       (   ),
        .illegal_instr_o    (   ),
        .branch_o           (   ),
        .jal_o              (   ),
        .jarl_o             (   )
    );

    reg   [31:0]    prog_cnt;

    instr_mem instr_mem_inst
    (
        .adr_i          (      prog_cnt   ),
        .rd_o           (      instr      )
    );

    wire  [31:0]    reg_file_rd1_o;
    wire  [31:0]    reg_file_rd2_o;
    wire  [31:0]    data_sourse;

    RF rf_inst
    (
        .clk_i          (   clk_i           ),
        .nreset_i       (   nreset_i        ),
        
        .adr1_i         (   instr[19:5]     ),
        .rd1_o          (   reg_file_rd1_o  ),
    
        .adr2_i         (   instr[24:20]    ),
        .rd2_o          (   reg_file_rd2_o  ),
    
        .we_i           (   mem_we_o        ),
        .adr3_i         (   instr[11:7]     ),
        .wd3_i          (   data_sourse     )
        
    );

    reg   [31:0]   alu_operand_a_i;
    reg   [31:0]   alu_operand_b_i;
    wire  [31:0]   alu_res_o;
    
    assign          alu_operand_b_i = reg_file_rd1_o;

    always @(*) begin
        case (ex_op_a_sel_o) 
            `h0 :  alu_operand_a_i = reg_file_rd1_o;
            `h1 :  alu_operand_a_i = 'h0;
            `h2 :
            default:
        endcase
    end

    always @(*) begin
        case (ex_op_b_sel_o) 
            `h0 :  alu_operand_b_i = reg_file_rd1_o;
            `h1 :  alu_operand_b_i = { { 20{`I_IMM_SIGN  } }, `I_IMM   };
            `h2 :  alu_operand_b_i = { `U_IMM, { 12'b0 } };
            `h3 :
            `h4 :
            default:
        endcase
    end

    riscV_alu alu_inst
    (
        .operator_i     (   alu_op_o        ),      
        .operand_a_i    (   alu_operand_a_i ),
        .operand_b_i    (   alu_operand_b_i ),
        .result_o       (   alu_res_o       ),
        .flag_o         (   alu_flag_o      )
    );

    assign data_sourse = alu_res_o;
 
    always @(posedge clk_i) begin
        if ( !nreset_i )
            prog_cnt <= 'b0;
        else begin
                prog_cnt <= prog_cnt +     32'b4;
            end 
        end
    end


endmodule
