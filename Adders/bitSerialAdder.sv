module FA (
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic cout
);
    always_comb begin
        sum  = a ^ b ^ cin;
        cout = (a & b) | (b & cin) | (a & cin);
    end
endmodule

module bitSerialAdder (   
        input clk,
        input rst_n,
        input a,
        input b,
        input cin, // cin is valid only for first clock cycle after reset
        output logic sum,
        output logic cout
        );

    logic c, flag; // carry register and state register

    FA fa_inst (
        .a(a),
        .b(b),
        .cin(c),
        .sum(sum),
        .cout(cout)
    );

    always_ff @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) begin
            c <= 0;
            flag <= 0;
        end else begin
            if(flag == 0) begin
                c <= cin;
                flag <= 1;
            end else begin
                c <= cout;
            end
        end 
    end
endmodule