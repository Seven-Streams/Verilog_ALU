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
    always @(*) begin
        carry[0] = g[0];
        carry[1] = g[1] | (p[1] & g[0]);
        carry[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]);
    end
endmodule
