/* 

Takes three 1-bit inputs a, b, cin and produces a 2-bit output {cout, sum}.

*/
module FA (
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic cout
);
    always_comb begin
        sum = a ^ b ^ cin; // odd parity function
        cout = (a & b) | (b & cin) | (cin & a); // majority function
    end
endmodule

/* Made using two half adders */
module FA (
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic cout
);
    logic sum1, carry1, carry2;
    HA ha1 (
        .a(a),
        .b(b),
        .sum(sum1),
        .carry(carry1)
    );
    HA ha2 (
        .a(sum1),
        .b(cin),
        .sum(sum),
        .carry(carry2)
    );
    assign cout = carry1 | carry2;
endmodule

/* Made using seven inverters and two 4 to 1 multiplexers */
module mux4 (
        input logic [1:0] sel,
        input logic d0,
        input logic d1,
        input logic d2,
        input logic d3,
        output logic y
    );
        always_comb begin
            case(sel)
                2'b00: y = d0;
                2'b01: y = d1;
                2'b10: y = d2;
                2'b11: y = d3;
                default: y = 1'b0;
            endcase
        end
    endmodule

module FA (
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic cout
);
    logic nota, notnota, notb, notnotb, notcin, notnotcin;
    logic notsum, notcout;

    assign nota = ~a;
    assign notnota = ~nota;
    assign notb = ~b;
    assign notnotb = ~notb;
    assign notcin = ~cin;
    assign notnotcin = ~notcin;

    assign cout = notcout;
    assign sum = ~notsum;

    mux4 mux_sum (
        .sel({notnota, notnotb}),
        .d0(notcin),
        .d1(notnotcin),
        .d2(notnotcin),
        .d3(notcin),
        .y(notsum)
    );
    mux4 mux_cout (
        .sel({notnota, notnotb}),
        .d0(1'b0),
        .d1(notnotcin),
        .d2(notnotcin),
        .d3(1'b1),
        .y(notcout)
    );
endmodule