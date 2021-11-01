module c_unit_demo(
    input         clk_i,
    input         nreset_i,
    input  [15:0] sw_i,
    output [7:0]  hex_o,
    output        dp_o,
    output [7:0]  an_o
    );

    wire [31:0 ] data_unit_o ; 
    wire         reset_press;

    control_unit control_unit_demo
     (
         .clk_i         (   clk_i             ),
        .nreset_i       (   reset_press       ),
        .switches       (   sw_i              ),
        .data_to_hex    (   data_unit_o       )
     );
         assign reset_press = nreset_i;

/*
    reg [2:0]    reset_delay;
    assign reset_press = !reset_delay[2] & reset_delay[1] & reset_delay[0];
    always @(posedge clk_i) begin
        if(!nreset_i)
            reset_delay <= 'b0;
        else begin
           reset_delay <= {reset_delay[1:0], nreset_i};
        end
    end */

    wire [6:0] all_hexs [0:7];
        
    genvar i;
    generate 
        for (i = 1; i <= 8; i = i + 1) begin : generate_block_name
            numb_dec s_segm ( 
                .value_i  (   data_unit_o[(4 * i) -1 : (4 * i) - 4]   ),
                .hex_o    (   all_hexs[i - 1]                         )
            );
        end 
    endgenerate
    

    reg [6:0] hex_mult;
    reg [7:0] an_shift;
    always @(posedge clk_i) begin
        if (!nreset_i)
            an_shift <= 'b0111_1111;
        else begin 
               an_shift <= {an_shift[6:0], an_shift[7]};
            case(an_shift)
    
                 8'b1111_1110:       hex_mult <= all_hexs[1];
                 8'b1111_1101:       hex_mult <= all_hexs[2];
                 8'b1111_1011:       hex_mult <= all_hexs[3];
                 8'b1111_0111:       hex_mult <= all_hexs[4];
                 8'b1110_1111:       hex_mult <= all_hexs[5];
                 8'b1101_1111:       hex_mult <= all_hexs[6];
                 8'b1011_1111:       hex_mult <= all_hexs[7];
                 8'b0111_1111:       hex_mult <= all_hexs[0];

                 default:            hex_mult <= 7'b111_1111;
          endcase
      end
    end

    assign an_o = an_shift;
    assign dp_o =  'b1;
    assign hex_o = { dp_o, hex_mult };

endmodule