module instr_mem (
        input  [31:0]   adr_i, 
        output [31:0]   rd_o 
    );
    
    reg [31:0] RAM [0:63];

    initial $readmemb ("file", RAM);
    assign rd_o = RAM[adr_i]; 
   
    
endmodule