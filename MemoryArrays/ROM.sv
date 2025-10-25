/* Example ROM that implemnets a full adder */
module ROM (
    input  logic [2:0] addr,    // {a, b, cin}
    output logic [1:0] data     // {cout, sum}
);
    always_comb begin
        case (addr)
            3'b000: data = 2'b00; // 0 + 0 + 0 = 00
            3'b001: data = 2'b01; // 0 + 0 + 1 = 01
            3'b010: data = 2'b01; // 0 + 1 + 0 = 01
            3'b011: data = 2'b10; // 0 + 1 + 1 = 10
            3'b100: data = 2'b01; // 1 + 0 + 0 = 01
            3'b101: data = 2'b10; // 1 + 0 + 1 = 10
            3'b110: data = 2'b10; // 1 + 1 + 0 = 10
            3'b111: data = 2'b11; // 1 + 1 + 1 = 11
            default: data = 2'b00;
        endcase
    end
endmodule