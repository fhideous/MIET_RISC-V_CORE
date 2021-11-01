`timescale 1ns / 1ps

module control_unit_tb();

    reg clk_i;
    reg nreset_i;
    reg [15:0] sw_i;
    wire[7:0] hex_o;
    wire[7:0] an_o;
    wire      dp;
    
   localparam CLK_SEMIPERIOD = 5;

    c_unit_demo dut
     (
        .clk_i          (   clk_i       ),
        .nreset_i       (   nreset_i    ),
        .sw_i           (   sw_i        ),
        .hex_o          (   hex_o       ),
        .dp_o           (   dp_o        ),
        .an_o           (   an_o        )

     );
     

  initial begin 
     clk_i = 'b0;
     forever begin
       #CLK_SEMIPERIOD clk_i = ~clk_i;
     end
  end

initial begin
    nreset_i = 0;
    #300
    nreset_i = 1;

    sw_i = 16'b1_1000_1110;
    
    #400
    nreset_i  = 0;
    #100
    nreset_i  = 1;
    
    
end

endmodule