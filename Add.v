/*
    Problem:
    https://acm.sjtu.edu.cn/OnlineJudge/problem?problem_id=1250
 
    任务：掌握组合逻辑，完成一个加法器。
*/
module BitAdd4(
        input [3:0] a,
        input [3:0] b,
        input carry_in,
        output reg[3:0] sum,
        output carry_out,
        output P,
        output G
    );
    reg [3:0] carry;
    reg [3:0] g;
    reg [3:0] p;
    integer i;
    always @* begin
        for(i = 0; i < 4; i++) begin
            g[i] = a[i] & b[i];
            p[i] = a[i] ^ b[i];
        end
        carry[1] = g[0] + (p[0] & carry_in);
        carry[2] = g[1] + (p[1] & g[0]) + (p[1] & p[0] & carry_in);
        carry[3] = g[2] + (p[2] & g[1]) + (p[2] & p[1] & g[0]) + (p[2] & p[1] & p[0] & carry_in);
        sum[0] = a[0] + b[0] + carry_in;
        for(i = 1; i < 4; i++) begin
            sum[i] = a[i] + b[i] + carry[i];
        end
    end
    assign G = g[3] + (p[3] & g[2]) + (p[3] & p[2] & g[1]) + (p[3] & p[2] & p[1] & g[0]);
    assign P = p[0] & p[1] & p[2] & p[3];
    assign carry_out = g[3] + (p[3] & g[2]) + (p[3] & p[2] & g[1]) + (p[3] & p[2] & p[1] & g[0]) + (p[3] & p[2] & p[1] & p[0] & carry_in);
endmodule

module BitAdd16(
        input [15:0] a,
        input [15:0] b,
        input carry_in,
        output [15:0] sum,
        output carry_out
    );
    reg [2:0] carry;
    wire [3:0] p;
    wire [3:0] g;
    always @* begin
        carry[0] = g[0] + (p[0] & carry[0]);
        carry[1] = g[1] + (p[1] & g[0]) + (p[1] & p[0] & carry_in);
        carry[2] = g[2] + (p[2] & g[1]) + (p[2] & p[1] & g[0]) + (p[2] & p[1] & p[0] & carry_in);
    end
    BitAdd4 adder0 (
                .a(a[3:0]),
                .b(b[3:0]),
                .carry_in(carry_in),
                .sum(sum[3:0]),
                .P(p[0]),
                .G(g[0])
            );

    BitAdd4 adder1 (
                .a(a[7:4]),
                .b(b[7:4]),
                .carry_in(carry[0]),
                .sum(sum[7:4]),
                .P(p[1]),
                .G(g[1])
            );

    BitAdd4 adder2 (
                .a(a[11:8]),
                .b(b[11:8]),
                .carry_in(carry[1]),
                .sum(sum[11:8]),
                .P(p[2]),
                .G(g[2])
            );

    BitAdd4 adder3 (
                .a(a[15:12]),
                .b(b[15:12]),
                .carry_in(carry[2]),
                .sum(sum[15:12]),
                .P(p[3]),
                .G(g[3])
            );
    assign carry_out = g[3] + (p[3] & g[2]) + (p[3] & p[2] & g[1]) + (p[3] & p[2] & p[1] & g[0]) + (p[3] & p[2] & p[1] & p[0] & carry_in);
endmodule
module Add(
        input       [31:0]          a,
        input       [31:0]          b,
        output reg  [31:0]          sum
    );
    wire [31:0] res_sum;
    wire first_output;
    BitAdd16 first(
                 .a(a[15:0]),
                 .b(b[15:0]),
                 .carry_in(1'b0),
                 .sum(res_sum[15:0]),
                 .carry_out(first_output));
    BitAdd16 second(
                 .a(a[31:16]),
                 .b(b[31:16]),
                 .carry_in(first_output),
                 .sum(res_sum[31:16])
             );
    integer i;
    always @* begin
        for(i = 0; i < 32; i++) begin
            sum[i] = res_sum[i];
        end
    end
endmodule
