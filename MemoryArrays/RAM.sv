/* Synchrouns write Asynchronous read RAM */
module RAM (#parameter DEPTH = 8, WIDTH = 32)
(
    input   logic clk,
    input   logic WE,
    input   logic [$clog2(DEPTH)-1:0] A,
    input   logic [WIDTH-1:0] WD,
    output  logic [WIDTH-1:0] RD
);
    logic [WIDTH-1:0] ram [DEPTH-1:0];

    always_ff @(posedge clk) begin
        if (WE) 
            ram[A] <= WD;
    end
    assign RD = ram[A];
endmodule


/* Synchronous Dual Data Rate (SDDR) RAM */
module DDR_RAM #(
    parameter int DEPTH = 8,
    parameter int WIDTH = 32
)(
    input  logic                     clk,
    input  logic                     WE_rise,
    input  logic                     WE_fall,
    input  logic [$clog2(DEPTH)-1:0] A_rise,
    input  logic [$clog2(DEPTH)-1:0] A_fall,
    input  logic [WIDTH-1:0]         WD_rise,
    input  logic [WIDTH-1:0]         WD_fall,
    output logic [WIDTH-1:0]         RD_rise,
    output logic [WIDTH-1:0]         RD_fall
);
    logic [WIDTH-1:0] ram [DEPTH-1:0];

    always_ff @(posedge clk) begin
        if (WE_rise)
            ram[A_rise] <= WD_rise;
        RD_rise <= ram[A_rise];
    end
    always_ff @(negedge clk) begin
        if (WE_fall)
            ram[A_fall] <= WD_fall;
        RD_fall <= ram[A_fall];
    end
endmodule