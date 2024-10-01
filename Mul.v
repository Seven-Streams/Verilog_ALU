`include "Add.v"

module Mul(
        input [31:0] a,
        input [31:0] b,
        output reg [63:0] product
    );
    wire [31:0] half_a;
    wire lowest_bit;
    wire [31:0] first_output [31:0];
    assign half_a = a >> 1;
    assign lowest_bit = a & 1;
    assign first_output[31] = (b[31] == 0) ? 0 : (a  & 32'h7FFFFFFF);
    assign first_output[0] = (b[0] == 0) ? 0 : (a ^ 1);
    genvar i;
    generate
        for(i = 1; i < 31; i = i + 1) begin
            assign first_output[i] = (b[i] == 0) ? 0 : a;
        end
    endgenerate
    always @(*) begin
        product[63] = (a >> 31) & (b >> 31);
        product[0] = (a & b & 1);
    end
endmodule
