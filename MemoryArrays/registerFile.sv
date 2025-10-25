/* 
A multiport register file with two read ports and one write port.
Wrting happens on the rising edge and reading is combinational.
 */

module regFile (#parameter DEPTH = 32, WIDTH = 32)
(
    input   logic clk,
    input   logic WE3,
    input   logic [$clog2(DEPTH)-1:0] A1, A2, A3,
    input   logic [$clog2(WIDTH)-1:0] WD3,
    output  logic [$clog2(WIDTH)-1:0] RD1, RD2
);
    logic [WIDTH-1:0] regfile [DEPTH-1:0];

    always_ff @(posedge clk) begin
        if (WE3) 
            regfile[A3] <= WD3;
    end

    assign RD1 = (A1 != 0) ? regfile[A1] : '0;
    assign RD2 = (A2 != 0) ? regfile[A2] : '0;

endmodule