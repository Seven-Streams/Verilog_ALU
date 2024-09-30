`include "Add.v"

module Mul(
        input [31:0] a,
        input [31:0] b,
        output reg [63:0] product
    );
    wire [31:0] double_a;
    assign double_a = a << 1;
    wire [31:0] first_output [15:0];
    genvar i;
    generate
    endgenerate
endmodule
