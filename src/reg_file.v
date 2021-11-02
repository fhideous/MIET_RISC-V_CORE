`timescale 1ns / 1ps

module RF(
   
    input           clk_i,
    input           nreset_i,
    
    input  [4:0]    adr1_i,
    output [31:0]   rd1_o,
 
    input  [4:0]    adr2_i,
    output [31:0]   rd2_o,

    input           we_i, 
    input  [4:0]    adr3_i,
    input  [31:0]   wd3_i 

    );


    reg [31:0] RAM [0:31];
    
    assign rd1_o = RAM[adr1_i];
    assign rd2_o = RAM[adr2_i];
    
    integer i;
    always @(posedge clk_i) begin
        if ( !nreset_i )
            for (i = 0; i < 32; i = i + 1)
                RAM[i] <= 5'b0;
        else begin
             if ( we_i && adr3_i)
                RAM[adr3_i] <= wd3_i;    
        end
        
    end
    

endmodule
