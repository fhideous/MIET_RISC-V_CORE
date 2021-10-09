`define ALU_ADD     5'b00000
`define ALU_SUB     5'b01000
`define ALU_SLL     5'b00001
`define ALU_LTS     5'b00010
`define ALU_LTU     5'b00011
`define ALU_XOR     5'b00100
`define ALU_SRL     5'b00101
`define ALU_SRA     5'b01101
`define ALU_OR      5'b00110
`define ALU_AND     5'b00111

`define ALU_EQ      5'b11000
`define ALU_NE      5'b11001
`define ALU_LTS_F   5'b11100
`define ALU_LTU_F   5'b11110
`define ALU_GES     5'b11101
`define ALU_GEU     5'b11111


module riscV_alu(

    input      [5:0]    operator_i,
    input      [31:0]   operand_a_i,
    input      [31:0]   operand_b_i,
    output reg [31:0]   result_o,
    output reg          flag_o
    );
    
    always @(*) begin 
            case(operator_i)
                `ALU_ADD  :   begin result_o =         operand_a_i +    operand_b_i             ;  flag_o   = 0         ; end
                `ALU_SUB  :   begin result_o =         operand_a_i -    operand_b_i             ;  flag_o   = 0         ; end
                `ALU_XOR  :   begin result_o =         operand_a_i ^    operand_b_i             ;  flag_o   = 0         ; end
                `ALU_OR   :   begin result_o =         operand_a_i |    operand_b_i             ;  flag_o   = 0         ; end
                `ALU_AND  :   begin result_o =         operand_a_i &    operand_b_i             ;  flag_o   = 0         ; end
                `ALU_SRA  :   begin result_o = $signed(operand_a_i)>>>  operand_b_i             ;  flag_o   = 0         ; end
                `ALU_SRL  :   begin result_o =         operand_a_i >>   operand_b_i             ;  flag_o   = 0         ; end
                `ALU_SLL  :   begin result_o =         operand_a_i <<   operand_b_i             ;  flag_o   = 0         ; end
                `ALU_LTS  :   begin result_o =($signed(operand_a_i)<    operand_b_i ) ? 1 :  0  ;  flag_o   = 0         ; end
                `ALU_LTU  :   begin result_o =        (operand_a_i <    operand_b_i ) ? 1 :  0  ;  flag_o   = 0         ; end

                
                `ALU_EQ   :   begin flag_o   =        (operand_a_i ==   operand_b_i ) ? 1 :  0  ;  result_o = 0         ; end
                `ALU_NE   :   begin flag_o   =        (operand_a_i !=   operand_b_i ) ? 1 :  0  ;  result_o = 0         ; end                                    
                `ALU_GES  :   begin flag_o   =($signed(operand_a_i)>=   operand_b_i ) ? 1 :  0  ;  result_o = 0         ; end
                `ALU_GEU  :   begin flag_o   =        (operand_a_i >=   operand_b_i ) ? 1 :  0  ;  result_o = 0         ; end
                `ALU_LTS_F:   begin flag_o   =($signed(operand_a_i)<    operand_b_i ) ? 1 :  0  ;  result_o = 0         ; end
                `ALU_LTU_F:   begin flag_o   =        (operand_a_i <    operand_b_i ) ? 1 :  0  ;  result_o = 0         ; end
            endcase
        end
    
endmodule
