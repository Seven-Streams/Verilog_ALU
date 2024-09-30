/*
    Problem:
    https://acm.sjtu.edu.cn/OnlineJudge/problem?problem_id=1250
 
    任务：掌握组合逻辑，完成一个加法器。
*/
module BitAdd(
        input [3:0] a,
        input [3:0] b,
        input input_carry,
        output reg[3:0] sum,
        output reg flag
    );
    reg [3:0] carry;
    reg [3:0] g;
    reg [3:0] p;
    integer i;
    always @* begin
        for(i = 0; i < 4; i++) begin
            g[i] = a[i] | b[i];
            p[i] = a[i] ^ b[i];
        end
        carry[1] = g[0] + (p[0] & input_carry);
        carry[2] = g[1] + (p[1] & g[0]) + (p[1] & p[0] & input_carry);
        carry[3] = g[2] + (p[2] & g[1]) + (p[2] & p[1] & g[0]) + (p[2] & p[1] & p[0] & input_carry);
        flag = g[3] + (p[3] & g[2]) + (p[3] & p[2] & g[1]) + (p[3] & p[2] & p[1] & g[0]) + (p[3] & p[2] & p[1] & p[0] & input_carry);
        sum[0] = a[0] + b[0] + input_carry;
        for(i = 1; i < 3; i++) begin
           sum[i] = a[i] + b[i] + carry[i];
        end
    end
endmodule

module Add(
        input       [31:0]          a,
        input       [31:0]          b,
        output reg  [31:0]          sum
    );

    // TODO

endmodule
