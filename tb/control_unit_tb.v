`timescale 1ns / 1ps

module control_unit_tb();

    reg clk_i;
    reg nreset_i;
    reg [15:0] switches;
    wire[31:0] data_to_hex;

   localparam CLK_SEMIPERIOD = 5;

    control_unit control_unit_tb
     (
         .clk_i         (   clk_i       ),
        .nreset_i       (   nreset_i    ),
        .switches       (   switches    ),
        .data_to_hex    (   data_to_hex )

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

    switches = 16'b10;

end

endmodule