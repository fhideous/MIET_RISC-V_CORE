`define LOAD_OPCODE         5'b00_000
`define MISC_MEM_OPCODE     5'b00_011
`define OP_IMM_OPCODE       5'b00_100
`define AUIPC_OPCODE        5'b00_101
`define STORE_OPCODE        5'b01_000
`define OP_OPCODE           5'b01_100
`define LUI_OPCODE          5'b01_101
`define BRANCH_OPCODE       5'b11_000
`define JALR_OPCODE         5'b11_001
`define JAL_OPCODE          5'b11_011
`define SYSTEM_OPCODE       5'b11_100

`define ALU_OP_WIDTH        5
`define ALU_ADD             5'b00000
`define ALU_SUB             5'b01000
`define ALU_SLL             5'b00001
`define ALU_LTS             5'b00010
`define ALU_LTU             5'b00011
`define ALU_XOR             5'b00100
`define ALU_SRL             5'b00101
`define ALU_SRA             5'b01101
`define ALU_OR              5'b00110
`define ALU_AND             5'b00111

`define ALU_EQ              5'b11000
`define ALU_NE              5'b11001
`define ALU_LTS_F           5'b11100
`define ALU_LTU_F           5'b11110
`define ALU_GES             5'b11101
`define ALU_GEU             5'b11111

`define OPCODE      fetched_instr_i[6:2]

`define FUNC3       fetched_instr_i[14:12]
`define FUNC7       fetched_instr_i[31:25]

`define LDST_B              3'h0
`define LDST_H              3'h1
`define LDST_W              3'h2
`define LDST_BU             3'h4
`define LDST_HU             3'h5
`define NO_OPER             3'h0

module riscV_decode
(
    input       [31:0]              fetched_instr_i,
    output  reg [1:0]               ex_op_a_sel_o,
    output  reg [2:0]               ex_op_b_sel_o,
    output  reg [`ALU_OP_WIDTH -1:0]alu_op_o,
    output  reg                     mem_req_o,
    output  reg                     mem_we_o,
    output  reg [2:0]               mem_size_o,
    output  reg                     gpr_we_a_o,
    output  reg                     wb_src_sel_o,
    output  reg                     illegal_instr_o,
    output  reg                     branch_o,
    output  reg                     jal_o,
    output  reg                     jalr_o
    );
        
    always @(*) begin
        if (fetched_instr_i[1:0] != 2'b11)
            illegal_instr_o = 1'b1;
        else begin
            illegal_instr_o = 1'b0;
            case (`OPCODE)

                `OP_OPCODE:   begin   
                    case (`FUNC3)
                        3'h0 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_ADD; 
                                else if (`FUNC7 == 'h20 ) alu_op_o = `ALU_SUB; else illegal_instr_o = 1'b1; end     
                        3'h1 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_SLL; else illegal_instr_o = 1'b1; end     
                        3'h2 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_LTS; else illegal_instr_o = 1'b1; end     
                        3'h3 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_LTU; else illegal_instr_o = 1'b1; end     
                        3'h4 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_XOR; else illegal_instr_o = 1'b1; end     
                        3'h5 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_SRL;  
                                else if (`FUNC7 == 'h20 ) alu_op_o = `ALU_SRA; else illegal_instr_o = 1'b1; end     
                        3'h6 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_OR;  else illegal_instr_o = 1'b1; end     
                        3'h7 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_AND; else illegal_instr_o = 1'b1; end     
                    endcase  
                    gpr_we_a_o    = 'h1;    wb_src_sel_o  = 'h0;       
                    ex_op_a_sel_o = 'h0;    ex_op_b_sel_o = 'h0; 
                    mem_we_o      = 'h0;    mem_size_o    = `NO_OPER;  mem_req_o     =  'h0;
                    branch_o      = 'h0;    jal_o         = 'h0;       jalr_o        =  'h0;
                end

                `OP_IMM_OPCODE      :   begin
                    case (`FUNC3)
                        3'h0 : begin  alu_op_o = `ALU_ADD;     end
                        3'h1 : begin  if ( `FUNC7 == 'h0 ) 
                                    alu_op_o = `ALU_SLL; 
                                else 
                                    illegal_instr_o = 1'b1;    end                         
                        3'h2 : begin  alu_op_o = `ALU_LTS;     end
                        3'h3 : begin  alu_op_o = `ALU_LTU;     end
                        3'h4 : begin  alu_op_o = `ALU_XOR;     end
                        3'h5 : begin  if ( `FUNC7 == 'h20 )  
                                    alu_op_o = `ALU_SRA; 
                                else  if ( `FUNC7 == 'h0 )
                                    alu_op_o = `ALU_SRL ;
                                else
                                    illegal_instr_o = 1'b1;    end                         
                        3'h6 : begin  alu_op_o = `ALU_OR;      end
                        3'h7 : begin  alu_op_o = `ALU_AND;     end
                    endcase
                    gpr_we_a_o    = 'h1;    wb_src_sel_o  = 'h0;       
                    ex_op_a_sel_o = 'h0;    ex_op_b_sel_o = 'h1; 
                    mem_we_o      = 'h0;    mem_size_o    = `NO_OPER;  mem_req_o     =  'h0;
                    branch_o      = 'h0;    jal_o         = 'h0;       jalr_o        =  'h0;
                end

                `LOAD_OPCODE        :   begin 
                    case (`FUNC3)
                        3'h0 :  mem_size_o = `LDST_B;
                        3'h1 :  mem_size_o = `LDST_H;
                        3'h2 :  mem_size_o = `LDST_W;
                        3'h4 :  mem_size_o = `LDST_BU;
                        3'h5 :  mem_size_o = `LDST_HU;
                        default:
                            illegal_instr_o = 'h1;
                    endcase
                    gpr_we_a_o    = 'h1;    wb_src_sel_o  = 'h1;       
                    ex_op_a_sel_o = 'h0;    ex_op_b_sel_o = 'h1;    alu_op_o      = `ALU_ADD; 
                    mem_we_o      = 'h0;    mem_req_o     = 'h1;
                    branch_o      = 'h0;    jal_o         = 'h0;    jalr_o        = 'h0;
                end

                `STORE_OPCODE       :   begin    
                    case (`FUNC3)
                        3'h0 :  mem_size_o = `LDST_B;  
                        3'h1 :  mem_size_o = `LDST_H;
                        3'h2 :  mem_size_o = `LDST_W;
                        default:
                            illegal_instr_o = 'h1;

                    endcase
                    gpr_we_a_o    = 'h0;    wb_src_sel_o  = 'h0;       
                    ex_op_a_sel_o = 'h0;    ex_op_b_sel_o = 'h3;    alu_op_o      = `ALU_ADD; 
                    mem_we_o      = 'h1;    mem_req_o     = 'h1;
                    branch_o      = 'h0;    jal_o         = 'h0;    jalr_o        = 'h0;
                end

                `BRANCH_OPCODE      :   begin            
                    case (`FUNC3)
                        3'h0 :  alu_op_o = `ALU_EQ;
                        3'h1 :  alu_op_o = `ALU_NE;
                        3'h4 :  alu_op_o = `ALU_LTS_F;
                        3'h5 :  alu_op_o = `ALU_GES;
                        3'h6 :  alu_op_o = `ALU_LTU_F;
                        3'h7 :  alu_op_o = `ALU_GEU;
                        default : 
                            illegal_instr_o = 'h1;
                    endcase
                    gpr_we_a_o    = 'h0;    wb_src_sel_o  = 'h0;       
                    ex_op_a_sel_o = 'h0;    ex_op_b_sel_o = 'h0; 
                    mem_we_o      = 'h0;    mem_size_o    = `NO_OPER; mem_req_o     = 'h0;
                    branch_o      = 'h1;    jal_o         = 'h0;      jalr_o        = 'h0;
                end

                `JAL_OPCODE         :   begin                  
                    gpr_we_a_o    = 'h1;    wb_src_sel_o  = 'h0;
                    ex_op_a_sel_o = 'h1;    ex_op_b_sel_o = 'h4;      alu_op_o  = `ALU_ADD;
                    mem_we_o      = 'h0;    mem_size_o    = `NO_OPER; mem_req_o = 'h0;
                    branch_o      = 'h0;    jal_o         = 'h1;      jalr_o    = 'h0;  
                end

                `JALR_OPCODE        :   begin 
                    if ( !`FUNC3 ) begin 
                        illegal_instr_o = 'h1; 
                    gpr_we_a_o    = 'h1;    wb_src_sel_o  = 'h0;
                    ex_op_a_sel_o = 'h1;    ex_op_b_sel_o = 'h4;      alu_op_o  = `ALU_ADD;
                    mem_we_o      = 'h0;    mem_size_o    = `NO_OPER; mem_req_o = 'h0;
                    branch_o      = 'h0;    jal_o         = 'h0;      jalr_o    = 'h1;     
                end

                `LUI_OPCODE         :   begin   
                    gpr_we_a_o    = 'h1;    wb_src_sel_o  = 'h0;                                               
                    ex_op_a_sel_o = 'h2;    ex_op_b_sel_o = 'h2;      alu_op_o  = `ALU_ADD;
                    mem_we_o      = 'h0;    mem_size_o    = `NO_OPER; mem_req_o = 'h0;
                    branch_o      = 'h0;    jal_o         = 'h0;      jalr_o    = 'h0;     

                end

                `AUIPC_OPCODE       :   begin
                    gpr_we_a_o    = 'h1;    wb_src_sel_o  = 'h0;
                    ex_op_a_sel_o = 'h1;    ex_op_b_sel_o = 'h2;      alu_op_o  = `ALU_ADD;
                    mem_we_o      = 'h0;    mem_size_o    = `NO_OPER; mem_req_o = 'h0;
                    branch_o      = 'h0;    jal_o         = 'h0;      jalr_o    = 'h0;       
                end
                
                `SYSTEM_OPCODE      :   begin
                    gpr_we_a_o    = 'h0;    wb_src_sel_o  = 'h0;
                    ex_op_a_sel_o = 'h0;    ex_op_b_sel_o = 'h0;      alu_op_o  = `ALU_ADD;
                    mem_we_o      = 'h0;    mem_size_o    = `NO_OPER; mem_req_o = 'h0;
                    branch_o      = 'h0;    jal_o         = 'h0;      jalr_o    = 'h0;       
                end

                  `MISC_MEM_OPCODE      :   begin
                    gpr_we_a_o    = 'h0;    wb_src_sel_o  = 'h0;
                    ex_op_a_sel_o = 'h0;    ex_op_b_sel_o = 'h0;      alu_op_o  = `ALU_ADD;
                    mem_we_o      = 'h0;    mem_size_o    = `NO_OPER; mem_req_o = 'h0;
                    branch_o      = 'h0;    jal_o         = 'h0;      jalr_o    = 'h0;       
                end
                
                default:
                    illegal_instr_o = 'h1;
            endcase
        end
    end 

endmodule