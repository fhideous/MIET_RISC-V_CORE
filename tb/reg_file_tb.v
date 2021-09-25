`timescale 1ns / 1ps

module reg_file_tb();

    reg           clk_i;
    reg           nreset_i;
    
    reg  [4:0]    adr1_i;
    wire [31:0]   rd1_o;
 
    reg  [4:0]    adr2_i;
    wire [31:0]   rd2_o;

    reg           we_i; 
    reg  [4:0]    adr3_i;
    reg  [31:0]   wd3_i;

    RF RF_inst
    (
        .clk_i      (   clk_i       ),
        .nreset_i   (   nreset_i    ),
        
        .adr1_i     (   adr1_i      ),
        .rd1_o      (   rd1_o       ),   
    
        .adr2_i     (   adr2_i      ),
        .rd2_o      (   rd2_o       ),
        
        .we_i       (   we_i        ),
        .adr3_i     (   adr3_i      ),
        .wd3_i      (   wd3_i       )
    );  
    
    task rf_check;
        
        
        
    endtask
    
    initial begin
    
    
    
    
    end

endmodule
