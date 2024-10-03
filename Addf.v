
module add_float(
        input [31:0] a,
        input [31:0] b,
        output reg [31:0] sum
    );
    wire signal[1:0];
    wire [7:0]tail[1:0];
    wire [22:0]exp[1:0];
    genvar i;
    generate
        assign signal[0] = a[31];
        assign signal[1] = b[31];
        for(i = 0; i < 8; i = i + 1) begin
            assign tail[0][i] = a[23 + i];
            assign tail[1][i] = b[23 + i];
        end
        for(i = 0; i < 23; i = i + 1) begin
            assign exp[0][i] = a[i];
            assign exp[1][i] = b[i];
        end
    endgenerate
endmodule
