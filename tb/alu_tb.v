`timescale 1ns / 1ps

`define ALU_ADD 6'b011000
`define ALU_SUB 6'b011001
`define ALU_XOR 6'b101111
`define ALU_OR  6'b101110
`define ALU_AND 6'b010101
`define ALU_SRA 6'b100100
`define ALU_SRL 6'b100101
`define ALU_SLL 6'b100111
`define ALU_LTS 6'b000000
`define ALU_LTU 6'b000001
`define ALU_GES 6'b001010
`define ALU_GEU 6'b001011
`define ALU_EQ  6'b001100
`define ALU_NE  6'b001101

module alu_tb();

    reg     [5:0]     operator_i;            
    reg     [31:0]    operand_a_i;           
    reg     [31:0]    operand_b_i;            
    wire    [31:0]    result_o;               
    wire              comparison_result_o;   
  
    riscV_alu alu_inst
    (
        .operator_i           (    operator_i             ),
        .operand_a_i          (    operand_a_i            ),
        .operand_b_i          (    operand_b_i            ),
        .result_o             (    result_o               ),
        .comparison_result_o  (    comparison_result_o    )
    );
    
    task alu_oper_test;
        input integer oper;
        input integer operd_a;
        input integer operd_b;
        input integer expected;
    
        reg [8*7:1] str;
        begin
            operator_i   = oper;
            operand_a_i = operd_a;
            operand_b_i  = operd_b;
            #10
            if (expected != result_o) begin
                $display("====================================");
                case (oper)  
                    `ALU_ADD: str = "ALU_ADD";
                    `ALU_SUB: str = "ALU_SUB";
                    `ALU_XOR: str = "ALU_XOR";
                    `ALU_OR : str = "ALU_OR";
                    `ALU_AND: str = "ALU_AND";
                    `ALU_SRA: str = "ALU_SRA";
                    `ALU_SRL: str = "ALU_SRL";
                    `ALU_SLL: str = "ALU_SLL";
                    `ALU_LTS: str = "ALU_LTS";
                    `ALU_LTU: str = "ALU_LTU";
                    `ALU_GES: str = "ALU_GES";
                    `ALU_GEU: str = "ALU_GEU";
                    `ALU_EQ : str = "ALU_EQ";
                    `ALU_NE : str = "ALU_NE";
                endcase 
                $display("ERROR operation = %6b : %s", oper, str);
                $display("------------------------------------");
                $display("operd_a=\t%d\n", operd_a, "operd_b=\t%d\n\n", operd_b, "result_o=\t %d\n", result_o, "result_exp=\t%d", expected);
                $display("====================================");
                
            end
        end
    endtask

    initial 
        begin
            //ALU_ADD
                alu_oper_test(`ALU_ADD,1,2,3);
                #20
                alu_oper_test(`ALU_ADD,1,-1,0);
                #20
                alu_oper_test(`ALU_ADD,1,0,1);
                #20
                alu_oper_test(`ALU_ADD,-1,-1,-2);
                #20
                alu_oper_test(`ALU_ADD,0,0,0);
                #20
                alu_oper_test(`ALU_ADD,-10,4,-6);
                #20
            //ALU_SUB       
                alu_oper_test(`ALU_SUB,1,2,-1);
                #20
                alu_oper_test(`ALU_SUB,1,-1,2);
                #20
                alu_oper_test(`ALU_SUB,1,0,1);
                #20
                alu_oper_test(`ALU_SUB,2,1,1);
                #20
                alu_oper_test(`ALU_SUB,-1,-1,0);
                #20
                alu_oper_test(`ALU_SUB,0,1,-1);
                #20
                alu_oper_test(`ALU_SUB,0,0,0);
                #20
                alu_oper_test(`ALU_SUB,-1,1,-2);
                #20
            //ALU_XOR       
                alu_oper_test(`ALU_XOR,1,1,0);
                #20
                alu_oper_test(`ALU_XOR,1,-1,-2);
                #20
                alu_oper_test(`ALU_XOR,-1,1,-2);
                #20
                alu_oper_test(`ALU_XOR,0,1,1);
                #20
                alu_oper_test(`ALU_XOR,1,0,1);
                #20
                alu_oper_test(`ALU_XOR,1,2,3);
                #20
                alu_oper_test(`ALU_XOR,2,1,3);
                #20
                alu_oper_test(`ALU_XOR,0,0,0);
                #20

            //ALU_OR   
                alu_oper_test(`ALU_OR,1,0,1);
                #20
                alu_oper_test(`ALU_OR,1,1,1);
                #20
                alu_oper_test(`ALU_OR,0,1,1);
                #20
                alu_oper_test(`ALU_OR,1,-1,-1);
                #20
                alu_oper_test(`ALU_OR,-1,2,-1);
                #20
                alu_oper_test(`ALU_OR,1,2,3);
                #20
                alu_oper_test(`ALU_OR,2,1,3);
                #20
                alu_oper_test(`ALU_OR,2,5,7);
                #20
           //ALU_AND  
                alu_oper_test(`ALU_AND,1,-1,1);
                #20
                alu_oper_test(`ALU_AND,-1,1,1);
                #20
                alu_oper_test(`ALU_AND,0,10,0);
                #20
                alu_oper_test(`ALU_AND,10,0,0);
                #20
                alu_oper_test(`ALU_AND,3,4,0);
                #20
                alu_oper_test(`ALU_AND,3,5,1);
                #20
                alu_oper_test(`ALU_AND,5,3,1);
                #20
                alu_oper_test(`ALU_AND,4,3,0);
                #20
            //ALU_SRA   
                alu_oper_test(`ALU_SRA,1,0,1);
                #20
                alu_oper_test(`ALU_SRA,0,1,0);
                #20
                alu_oper_test(`ALU_SRA,1,1,0);
                #20
                alu_oper_test(`ALU_SRA,-1,1,-1);
                #20
                alu_oper_test(`ALU_SRA,2,1,1);
                #20
                alu_oper_test(`ALU_SRA,3,1,1);
                #20
                alu_oper_test(`ALU_SRA,7,2,1);
                #20
                alu_oper_test(`ALU_SRA,7,1,3);
                #20
            //ALU_SRL   
                alu_oper_test(`ALU_SRL,1,0,1);
                #20
                alu_oper_test(`ALU_SRL,0,1,0);
                #20
                alu_oper_test(`ALU_SRL,1,1,0);
                #20
                alu_oper_test(`ALU_SRL,-1,1,2147483647);
                #20
                alu_oper_test(`ALU_SRL,2,1,1);
                #20
                alu_oper_test(`ALU_SRL,3,1,1);
                #20
                alu_oper_test(`ALU_SRL,7,2,1);
                #20
                alu_oper_test(`ALU_SRL,7,1,3);
                #20
            //ALU_SLL   
                alu_oper_test(`ALU_SLL,1,0,1);
                #20
                alu_oper_test(`ALU_SLL,0,1,0);
                #20
                alu_oper_test(`ALU_SLL,1,1,2);
                #20
                alu_oper_test(`ALU_SLL,-1,1,-2);
                #20
                alu_oper_test(`ALU_SLL,2,1,4);
                #20
                alu_oper_test(`ALU_SLL,3,1,6);
                #20
                alu_oper_test(`ALU_SLL,7,2,28);
                #20
                alu_oper_test(`ALU_SLL,7,1,14);
                #20
            //ALU_LTS   
                alu_oper_test(`ALU_LTS,1,2,1);
                #20
                alu_oper_test(`ALU_LTS,2,1,0);
                #20
                alu_oper_test(`ALU_LTS,-1,1,0);
                #20
                alu_oper_test(`ALU_LTS,1,-1,1);
                #20
                alu_oper_test(`ALU_LTS,1,1,0);
                #20
                alu_oper_test(`ALU_LTS,-2,-1,1);
                #20
                alu_oper_test(`ALU_LTS,-1,-2,0);
                #20
                alu_oper_test(`ALU_LTS,0,0,0);
                #20
            //ALU_LTU   
                alu_oper_test(`ALU_LTU,1,2,1);
                #20
                alu_oper_test(`ALU_LTU,2,1,0);
                #20
                alu_oper_test(`ALU_LTU,-1,1,0);
                #20
                alu_oper_test(`ALU_LTU,1,-1,1);
                #20
                alu_oper_test(`ALU_LTU,1,1,0);
                #20
                alu_oper_test(`ALU_LTU,-2,-1,1);
                #20
                alu_oper_test(`ALU_LTU,-1,-2,0);
                #20
                alu_oper_test(`ALU_LTU,0,0,0);
                #20
            //ALU_GES   
                alu_oper_test(`ALU_GES,1,2,0);
                #20
                alu_oper_test(`ALU_GES,2,1,1);
                #20
                alu_oper_test(`ALU_GES,-1,1,1);
                #20
                alu_oper_test(`ALU_GES,1,-1,0);
                #20
                alu_oper_test(`ALU_GES,1,1,1);
                #20
                alu_oper_test(`ALU_GES,-2,-1,0);
                #20
                alu_oper_test(`ALU_GES,-1,-2,1);
                #20
                alu_oper_test(`ALU_GES,0,0,1);
                #20
            //ALU_GEU   
                alu_oper_test(`ALU_GEU,1,2,0);
                #20
                alu_oper_test(`ALU_GEU,2,1,1);
                #20
                alu_oper_test(`ALU_GEU,-1,1,1);
                #20
                alu_oper_test(`ALU_GEU,1,-1,0);
                #20
                alu_oper_test(`ALU_GEU,1,1,1);
                #20
                alu_oper_test(`ALU_GEU,-2,-1,0);
                #20
                alu_oper_test(`ALU_GEU,-1,-2,1);
                #20
                alu_oper_test(`ALU_GEU,0,0,1);
                #20
            //ALU_EQ   
                alu_oper_test(`ALU_EQ,0,0,1);
                #20
                alu_oper_test(`ALU_EQ,1,0,0);
                #20
                alu_oper_test(`ALU_EQ,0,1,0);
                #20
                alu_oper_test(`ALU_EQ,-1,1,0);
                #20
                alu_oper_test(`ALU_EQ,-1,-1,1);
                #20
                alu_oper_test(`ALU_EQ,1,-1,0);
                #20
                alu_oper_test(`ALU_EQ,1,1,1);
                #20
                alu_oper_test(`ALU_EQ,111111,22222,0);
                #20
            //ALU_NE   
                alu_oper_test(`ALU_NE,0,0,0);
                #20
                alu_oper_test(`ALU_NE,1,0,1);
                #20
                alu_oper_test(`ALU_NE,0,1,1);
                #20
                alu_oper_test(`ALU_NE,-1,1,1);
                #20
                alu_oper_test(`ALU_NE,-1,-1,0);
                #20
                alu_oper_test(`ALU_NE,1,-1,1);
                #20
                alu_oper_test(`ALU_NE,1,1,0);
                #20
                alu_oper_test(`ALU_NE,11111,222222,1);

                $display("TEST END");
        end
        
endmodule
