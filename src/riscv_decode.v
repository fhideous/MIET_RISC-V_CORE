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


module riscV_decode
(
    input   [31:0]                  fetched_instr_i,
    
    output  [1:0 ]                  ex_op_a_sel_o,
    output  [2:0 ]                  ex_op_b_sel_o,
    
    output  [`ALU_OP_WIDTH -1:0]    alu_op_o,

    output                          mem_req_o,
    output                          mem_we_o,
    output                          mem_size_o,

    output                          grp_we_a_o,
    output                          wb_src_sel_o,
    output                          illegal_instr_o,
    output                          branch_o,

    output                          jal_o,
    output                          jarl_o
    );

    wire []

    always @(*) begin
        case (`OPCODE)
            `OP_OPCODE:   begin   
                case (`FUNC3)
                    3'h0 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_ADD; 
                            else if (`FUNC7 == 'h20 ) alu_op_o = `ALU_SUB;  end
                    3'h1 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_SLL;  end
                    3'h2 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_LTS;  end
                    3'h3 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_LTU;  end
                    3'h4 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_XOR;  end
                    3'h5 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_SRL;  
                            else if (`FUNC7 == 'h20 ) alu_op_o = `ALU_SRA;  end
                    3'h6 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_OR;   end  
                    3'h7 : begin if (`FUNC7 == 'h0  ) alu_op_o = `ALU_AND;  end
                endcase  
                mem_we_o      =  'h1;  
                ex_op_b_sel_o =  'h0;    
            end
            
            `OP_IMM_OPCODE      :   begin
                case (`FUNC3)
                    3`h0 : begin  alu_op_o = `ALU_ADD;  end
                    3`h1 : begin  if ( `FUNC7 == 'h0 ) 
                                  alu_op_o = `ALU_SLL;  end
                    3`h2 : begin  alu_op_o = `ALU_LTS;  end
                    3`h3 : begin  alu_op_o = `ALU_lTU;  end
                    3`h4 : begin  alu_op_o = `ALU_XOR;  end
                    3`h5 : begin  if ( `FUNC7 == 'h20 )  
                                  alu_op_o = `ALU_SRAI; 
                            else  if ( `FUNC7 == 'h0 )
                                  alu_op_o = `ALU_SRL ; end
                    3`h6 : begin  alu_op_o = `ALU_OR;   end
                    3`h7 : begin  alu_op_o = `ALU_AND;  end
                endcase
                mem_we_o      = 'h1;  
                ex_op_b_sel_o = 'h1;
            end
            `LOAD_OPCODE        :   begin                       end
            `STORE_OPCODE       :   begin                       end
            `BRANCH_OPCODE      :   begin                       end
            `JAL_OPCODE         :   begin                       end
            `JALR_OPCODE        :   begin                       end
            `LUI_OPCODE         :   begin   
                ex_op_a_sel_o = 'h1; ex_op_b_sel_o  = 'h2;
                mem_we_o      = 'h1; alu_op_o       = `ALU_ADD; end
            `AUIPC_OPCODE       :   begin                       end
            `SYSTEM_OPCODE      :   begin                       end
        
        default:

    end



endmodule