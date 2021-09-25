module DM (
        input           clk_i, 
        input  [31:0]   adr_i, 
        input  [31:0]   wd_i, 
        input           we_i, 
        output [19:0]   rd_o 
    );
    
    reg [31:0] RAM [0:63];

    assign rd_o = RAM[adr_i]; 
   
    always @(posedge clk_i) begin
        if (we_i) RAM[adr_i] <= wd_i;
    end 
    
    
    
endmodule