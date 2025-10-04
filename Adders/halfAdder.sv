/* 

Takes two 1-bit inputs a, b and produces a 2-bit output {carry, sum}.

*/

module HA (
    input  logic a,
    input  logic b,
    output logic sum,
    output logic carry
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule
