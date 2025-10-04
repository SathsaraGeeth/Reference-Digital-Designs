/* 

Takes N bits input and 1 bit carry in, produces N bits sum and 1 bit carry out.

*/

module rippleCarryAdder #(parameter N = 32) (
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    input  logic         cin,
    output logic [N-1:0] sum,
    output logic         cout
);
    logic [N:0] carry;
    assign carry[0] = cin;
    assign cout = carry[N];

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_fa
            FA fa_inst (
                .a    (a[i]),
                .b    (b[i]),
                .cin  (carry[i]),
                .sum  (sum[i]),
                .cout (carry[i+1])
            );
        end
    endgenerate
endmodule