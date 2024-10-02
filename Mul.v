`include "Add.v"

module Add64(
        input [63:0] a,
        input [63:0] b,
        output reg [63:0] sum
    );
    wire [63:0] res_sum;
    wire res_carry[2:0];
    reg carry[2:0];
    wire p[3:0];
    wire g[3:0];
    BitAdd16 first(
                 .a(a[15:0]),
                 .b(b[15:0]),
                 .carry_in(1'b0),
                 .sum(res_sum[15:0]),
                 .carry_out(res_carry[0]),
                 .G(g[0]),
                 .P(p[0]));
    BitAdd16 second(
                 .a(a[31:16]),
                 .b(b[31:16]),
                 .carry_in(carry[0]),
                 .sum(res_sum[31:16]),
                 .carry_out(res_carry[1]),
                 .G(g[1]),
                 .P(p[1])
             );
    BitAdd16 third(
                 .a(a[47:32]),
                 .b(b[47:32]),
                 .carry_in(carry[1]),
                 .sum(res_sum[47:32]),
                 .carry_out(res_carry[2]),
                 .G(g[2]),
                 .P(p[2])
             );
    BitAdd16 forth(
                 .a(a[63:48]),
                 .b(b[63:48]),
                 .carry_in(carry[2]),
                 .sum(res_sum[63:48])
             );
    integer i;
    always @(*) begin
        carry[0] = g[0];
        carry[1] = g[1] | (p[1] & g[0]);
        carry[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]);
        for(i = 0; i < 63; i++) begin
            sum[i] = res_sum[i];
        end
    end
endmodule


module Mul(
        input [31:0] a,
        input [31:0] b,
        output reg [31:0] product
    );
    wire [63:0] first_sum[15:0];
    wire [63:0] second_sum[7:0];
    wire [63:0] third_sum[3:0];
    wire [63:0] fourth_sum[1:0];
    wire [63:0] a_64;
    wire [63:0] b_64;
    genvar i;
    generate
        for(i = 0; i < 32; i = i + 1) begin
            assign a_64[i] = a[i];
            assign b_64[i] = b[i];
        end
        for(i = 32; i < 64; i = i + 1) begin
            assign a_64[i] = 0;
            assign b_64[i] = 0;
        end
        for(i = 0; i < 16; i = i + 1) begin
            Add64 adder(
                      .a((b[i << 1] == 0) ? 0 : (a_64 << (i << 1))),
                      .b((b[(i << 1) | 1] == 0) ? 0 : (a_64 << ((i << 1) | 1))),
                      .sum(first_sum[i])
                  );
        end
        for(i = 0; i < 8; i = i + 1) begin
            Add64 adder(
                      .a(first_sum[i << 1]),
                      .b(first_sum[(i << 1) | 1]),
                      .sum(second_sum[i])
                  );
        end
        for(i = 0; i < 4; i = i + 1) begin
            Add64 adder(
                      .a(second_sum[i << 1]),
                      .b(second_sum[(i << 1) | 1]),
                      .sum(third_sum[i])
                  );
        end
        for(i = 0; i < 2; i = i + 1) begin
            Add64 adder(
                      .a(third_sum[i << 1]),
                      .b(third_sum[(i << 1) | 1]),
                      .sum(fourth_sum[i])
                  );
        end
    endgenerate
    wire [63:0] res_sum;
    Add64 adder(.a(fourth_sum[0]),
                .b(fourth_sum[1]),
                .sum(res_sum[63:0]));

    integer j;
    always @(*) begin
        for(j = 0; j < 64; j++) begin
            product[j] = res_sum[j];
        end
    end
endmodule
