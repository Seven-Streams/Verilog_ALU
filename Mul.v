`include "Add.v"

module Mul(
        input [31:0] a,
        input [31:0] b,
        output reg [63:0] product
    );
    wire [31:0] double_a;
    wire carry[16:0];
    wire first_bit;
    assign double_a = a << 1;
    assign first_bit = a >> 31;
    wire [31:0] first_output [15:0];
    wire [31:0] sum[31:0];
    genvar i;
    for(i = 0; i < 16; i = i + 1) begin
        Add add(.a(b[i << 1] == 0 ? a : 0),
                .b(b[(i << 1) + 1] == 0 ? double_a : 0),
                .carry_out(carry[i]),
                .sum(sum[i]));
    end
    // This part is to do 16 times addition, and record the necessary carry_out.
    generate
    endgenerate
endmodule
