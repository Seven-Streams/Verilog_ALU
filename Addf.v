`include "Add.v"

module add_float(
        input [31:0] a,
        input [31:0] b,
        output reg [31:0] sum
    );
    wire signal[1:0];
    wire [31:0]tail[1:0];
    wire [31:0]exp[1:0];
    genvar i;
    generate
        assign signal[0] = a[31];
        assign signal[1] = b[31];
        for(i = 0; i < 8; i = i + 1) begin
            assign tail[0][i] = a[23 + i];
            assign tail[1][i] = b[23 + i];
        end
        assign tail[0][8] = 1;
        assign tail[1][8] = 1;
        for(i = 9; i < 32; i = i + 1) begin
            assign tail[0][i] = 0;
            assign tail[1][i] = 0;
        end
        for(i = 0; i < 23; i = i + 1) begin
            assign exp[0][i] = a[i];
            assign exp[1][i] = b[i];
        end
        for(i = 23; i < 32; i = i + 1) begin
            assign exp[0][i] = 0;
            assign exp[1][i] = 0;
        end
    endgenerate
    reg [31:0] res_tail[1:0];
    wire [31:0] exp_diff;
    reg [31:0] smaller;
    wire [31:0] small_comp;
    reg [31:0] big_num;
    reg [31:0] small_num;
    wire [31:0] tail_sum;
    reg [31:0] tail_output;
    reg [31:0] exp_output;
    wire [31:0] bigger_exp;
    reg [31:0] minus_input;
    wire [31:0] minus_output;
    Add adder_minus(
            .a(minus_input),
            .b(1),
            .sum(minus_output)
        );
    Add adder_comp(
            .a(smaller),
            .b(1),
            .sum(small_comp)
        );
    Add adder_exp(
            .a(exp_output),
            .b(1),
            .sum(bigger_exp)
        );
    Add adder_exp_diff(
            .a(small_num),
            .b(big_num),
            .sum(exp_diff)
        );
    Add adder_tail(
            .a(res_tail[0]),
            .b(res_tail[1]),
            .sum(tail_sum)
        );
    always @(*) begin
        if(a == 0 || b == 0) begin
            sum = (a == 0) ? b : a;
        end
        else begin
            if(signal[0] == signal[1]) begin
                if(exp[0] != exp[1]) begin
                    if(exp[0] > exp[1]) begin
                        assign big_num = exp[0];
                        smaller = ~exp[1];
                        small_num = small_comp;
                        if(exp_diff >= 8) begin
                            sum = a;
                        end
                        else begin
                            res_tail[0] = tail[0];
                            res_tail[1] = tail[1];
                            res_tail[1] = res_tail[1] >> exp_diff;
                            exp_output = exp[0];
                            tail_output = tail_sum;
                            if(tail_sum[9] != 0) begin
                                tail_output = tail_sum >> 1;
                                exp_output = bigger_exp;
                            end
                            sum[31] = signal[0];
                            sum[30:23] = tail_output[7:0];
                            sum[22:0] = exp_output[22:0];
                        end
                    end
                    else begin
                        assign big_num = exp[1];
                        smaller = ~exp[0];
                        small_num = small_comp;
                        if(exp_diff >= 8) begin
                            sum = b;
                        end
                        else begin
                            res_tail[0] = tail[0];
                            res_tail[1] = tail[1];
                            res_tail[0] = res_tail[0] >> exp_diff;
                            exp_output = exp[1];
                            tail_output = tail_sum;
                            if(tail_sum[9] != 0) begin
                                tail_output = tail_sum >> 1;
                                exp_output = bigger_exp;
                            end
                            sum[31] = signal[0];
                            sum[30:23] = tail_output[7:0];
                            sum[22:0] = exp_output[22:0];
                        end
                    end
                end
            end
            else begin
                if(exp[0] != exp[1]) begin
                    if(exp[0] > exp[1]) begin
                        assign big_num = exp[0];
                        smaller = ~exp[1];
                        small_num = small_comp;
                        if(exp_diff >= 8) begin
                            sum = a;
                        end
                        else begin
                            res_tail[0] = tail[0];
                            minus_input = ~tail[1];
                            res_tail[1] = minus_output;
                            tail_output = tail_sum;
                            exp_output = exp[0];
                            if(tail_sum[9] != 0) begin
                                tail_output = tail_sum >> 1;
                                exp_output = bigger_exp;
                            end
                            sum[31] = signal[0];
                            sum[30:23] = tail_output[7:0];
                            sum[22:0] = exp_output[22:0];
                        end
                    end
                    else begin
                        assign big_num = exp[1];
                        smaller = ~exp[0];
                        small_num = small_comp;
                        if(exp_diff >= 8) begin
                            sum = b;
                        end
                        else begin
                            res_tail[1] = tail[1];
                            minus_input = ~tail[0];
                            res_tail[0] = minus_output;
                            tail_output = tail_sum;
                            exp_output = exp[1];
                            if(tail_sum[9] != 0) begin
                                tail_output = tail_sum >> 1;
                                exp_output = bigger_exp;
                            end
                            sum[31] = signal[1];
                            sum[30:23] = tail_output[7:0];
                            sum[22:0] = exp_output[22:0];
                        end
                    end
                end
                else begin
                    if(tail[0] == tail[1]) begin
                        sum = 0;
                    end
                    else begin
                        if(tail[0] > tail[1]) begin
                            minus_input = ~tail[1];
                            res_tail[0] = tail[0];
                            res_tail[1] = minus_input;
                            tail_output = tail_sum;
                            exp_output = exp[0];
                            while(tail_output[8] != 0) begin
                                tail_output = tail_output << 1;
                                exp_output = bigger_exp;
                            end
                            sum[31] = signal[0];
                            sum[30:23] = tail_output[7:0];
                            sum[22:0] = exp_output[22:0];
                        end
                        else begin
                            minus_input = ~tail[0];
                            res_tail[0] = tail[1];
                            res_tail[1] = minus_input;
                            tail_output = tail_sum;
                            exp_output = exp[0];
                            while(tail_output[8] != 0) begin
                                tail_output = tail_output << 1;
                                exp_output = bigger_exp;
                            end
                            sum[31] = signal[0];
                            sum[30:23] = tail_output[7:0];
                            sum[22:0] = exp_output[22:0];
                        end
                    end
                end
            end
        end
    end
endmodule
