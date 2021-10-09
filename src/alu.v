`define ALU_ADD     6'b00000
`define ALU_SUB     6'b01000
`define ALU_SLL     6'b00001
`define ALU_LTS     6'b00010
`define ALU_LTU     6'b00011
`define ALU_XOR     6'b00100
`define ALU_SRL     6'b00101
`define ALU_SRA     6'b01101
`define ALU_OR      6'b00110
`define ALU_AND     6'b00111
`define ALU_EQ_F    6'b11000
`define ALU_NE_F    6'b11001
`define ALU_LTS_F   6'b00010
`define ALU_GES_F   6'b11101
`define ALU_LTU_F   6'b00011
`define ALU_GEU_F   6'b11111


module riscV_alu(

    input      [5:0]    operator_i,
    input      [31:0]   operand_a_i,
    input      [31:0]   operand_b_i,
    output reg [31:0]   result_o,
    output reg          flag_o
    );
    
    always @(*) begin 
            case(operator_i)
                `ALU_ADD:     begin result_o =         operand_a_i +    operand_b_i             ;  flag_o = 0         ; end
                `ALU_SUB:     begin result_o =         operand_a_i -    operand_b_i             ;  flag_o = 0         ; end
                `ALU_XOR:     begin result_o =         operand_a_i ^    operand_b_i             ;  flag_o = 0         ; end
                `ALU_OR:      begin result_o =         operand_a_i |    operand_b_i             ;  flag_o = 0         ; end
                `ALU_AND:     begin result_o =         operand_a_i &    operand_b_i             ;  flag_o = 0         ; end
                `ALU_SRA:     begin result_o = $signed(operand_a_i)>>>  operand_b_i             ;  flag_o = 0         ; end
                `ALU_SRL:     begin result_o =         operand_a_i >>   operand_b_i             ;  flag_o = 0         ; end
                `ALU_SLL:     begin result_o =         operand_a_i <<   operand_b_i             ;  flag_o = 0         ; end
                `ALU_LTS:     begin result_o =($signed(operand_a_i)<    operand_b_i ) ? 1 :  0  ;  flag_o = 0         ; end
                `ALU_LTU:     begin result_o =        (operand_a_i <    operand_b_i ) ? 1 :  0  ;  flag_o = 0         ; end
                
                `ALU_GES_F:   begin result_o =($signed(operand_a_i)>=   operand_b_i ) ? 1 :  0  ;  flag_o = result_o  ; end
                `ALU_GEU_F:   begin result_o =        (operand_a_i >=   operand_b_i ) ? 1 :  0  ;  flag_o = result_o  ; end
                `ALU_EQ_F:    begin result_o =        (operand_a_i ==   operand_b_i ) ? 1 :  0  ;  flag_o = result_o  ; end
                `ALU_NE_F:    begin result_o =        (operand_a_i !=   operand_b_i ) ? 1 :  0  ;  flag_o = result_o  ; end
                `ALU_LTS_F:   begin result_o =($signed(operand_a_i)<    operand_b_i ) ? 1 :  0  ;  flag_o = result_o  ; end
                `ALU_LTU_F:   begin result_o =        (operand_a_i <    operand_b_i ) ? 1 :  0  ;  flag_o = result_o  ; end
                
            endcase
        end
    
endmodule
