`include "Add.v"

module CSA(
        input [31:0] a,
        input [31:0] b,
        input [2:0] carry_in,
        output [31:0] sum,
        output [2:0] carry_out
    );
    wire [32:0] carry;
    wire [32:0] res_sum;
    wire [32:0] res_output;
    genvar i;
    assign res_sum[0] = (a[0] ^ b[0] ^ carry_in[0]);
    assign res_sum[1] = (a[1] ^ b[1] ^ carry_in[1]);
    assign carry[1] = (a[0] & b[0]) | (a[0] & carry_in[0]) | (b[0] & carry_in[0]);
    assign carry[2] = (a[1] & b[1]) | (a[1] & carry_in[1]) | (b[1] & carry_in[1]);
    generate
        for(i = 2; i < 32; i = i + 1) begin
            assign res_sum[i] = (a[i] ^ b[i]);
            assign carry[i + 1] = (a[i] & b[i]);
        end
    endgenerate
    Add adder(
            .a(res_sum[32:1]),
            .b(carry[32:1]),
            .carry_out(res_output[32]),
            .sum(res_output[31:0]));
    assign sum[0] = res_output[0];
    assign carry_out[1] = res_output[32];
    assign carry_out[0] = res_output[31];
    generate
        for(i = 1; i < 32; i = i + 1) begin
            assign sum[i] = res_output[i - 1];
        end
    endgenerate
endmodule

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
