
module numb_dec(
    input     [3:0] value_i,
    output    [6:0] hex_o
    );

reg [6:0] dec;

always @(*) begin
    case(value_i)
        4'h0: dec <= 7'b100_0000;
        4'h1: dec <= 7'b111_1001;
        4'h2: dec <= 7'b010_0100;
        4'h3: dec <= 7'b011_0000;
        4'h4: dec <= 7'b001_1001;
        4'h5: dec <= 7'b001_0010;
        4'h6: dec <= 7'b000_0010;
        4'h7: dec <= 7'b111_1000;
        4'h8: dec <= 7'b000_0000;
        4'h9: dec <= 7'b001_0000;
        4'ha: dec <= 7'b000_1000;
        4'hb: dec <= 7'b000_0011;
        4'hc: dec <= 7'b100_0110;
        4'hd: dec <= 7'b010_0001;
        4'he: dec <= 7'b000_0110;
        4'hf: dec <= 7'b000_1110;
    endcase
end

assign hex_o = dec;

endmodule
