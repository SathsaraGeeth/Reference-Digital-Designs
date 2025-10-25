// /////////         Unsigned Integer Multipliers         //////////
// //                                                            //

// /* 
// 1. Unsigned Bit Serial Multiplication - with right shifts
// p(j+1) = (p(j) + x(j) * a * 2^k) * 2^-1
// -> p(k) = ax + p(0) * 2^-k

// Remarks:
// - Alternative approaches:
//     1. Simply having a 2N bit wide adder
//     2. Also we could separately shift the addition; either into two cycles or two sub cycles
//     3. The product multiplexer can be replaced with N and gates (implemented here)
//     4. Can share the register for x and p partially (implemented here)
// - We can use this to do multiplication in hardware that dont have multipliers
// but have adders and shifters. (programmed multiplier).
// */

// module bitSerialMultiplier #(parameter N = 8) (
//     input  logic            clk,
//     input  logic            rst_n,
//     input  logic            start,
//     input  logic [N-1:0]    a,
//     input  logic [N-1:0]    x,
//     output logic [2*N-1:0]  p,
//     output logic            done
// ); 
//     logic [N-1:0]   A;
//     logic [2*N-1:0] P;                  // shift register PP and Multiplier -> Answer
//     logic [$clog2(N+1)-1:0] count;
//     logic busy;

//     always_ff @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             A     <= '0;
//             P     <= '0;
//             count <= '0;
//             done  <= 1'b0;
//             busy  <= 1'b0;
//         end 
//         else if (start && !busy) begin
//             A     <= a;
//             P     <= {{N'b0}, x};
//             count <= N;
//             done  <= 1'b0;
//             busy  <= 1'b1;
//         end 
//         else if (busy) begin
//             if (count > 0) begin
//                 logic [N-1:0] sum;            // carry + sum; N bit adder
//                 logic carry;
//                 logic [N-1:0] adder_in;

//                 //adder_in = (P[0]) ? A : 0;              // mux impl.
//                 adder_in = A & {N{P[0]}};               // and gate impl.
//                 {carry, sum} = P[2*N-1:N] + adder_in;   // N bit adder

//                 // >> 1
//                 P <= {carry, sum, P[N-1:1]};

//                 count <= count - 1;

//                 if (count == 1) begin
//                     done <= 1'b1;
//                     busy <= 1'b0;
//                 end
//             end
//         end
//     end
//     assign p = P;
// endmodule

// /*
// 2. We can fuse the multiply and add operations without no
// overhead in time or area.
// */

// module bitSerialFusedMultiplyAdder #(parameter N = 8) (
//     input  logic            clk,
//     input  logic            rst_n,
//     input  logic            start,
//     input  logic [N-1:0]    a,
//     input  logic [N-1:0]    x,
//     input  logic [N-1:0]    b,
//     output logic [2*N-1:0]  p,
//     output logic            done
// ); 
//     logic [N-1:0]   A;
//     logic [2*N-1:0] P;
//     logic [$clog2(N+1)-1:0] count;
//     logic busy;

//     always_ff @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             A     <= '0;
//             P     <= '0;
//             count <= '0;
//             done  <= 1'b0;
//             busy  <= 1'b0;
//         end 
//         else if (start && !busy) begin
//             A     <= a;
//             P     <= {b, x};
//             count <= N;
//             done  <= 1'b0;
//             busy  <= 1'b1;
//         end 
//         else if (busy) begin
//             if (count > 0) begin
//                 logic [N-1:0] sum;            // carry + sum; N-bit adder
//                 logic carry;
//                 logic [N-1:0] adder_in;

//                 //adder_in = (P[0]) ? A : 0;              // mux impl.
//                 adder_in = A & {N{P[0]}};               // and gate impl.
//                 {carry, sum} = P[2*N-1:N] + adder_in;   // Nbit adder

//                 // >> 1
//                 P <= {carry, sum, P[N-1:1]};

//                 count <= count - 1;

//                 if (count == 1) begin
//                     done <= 1'b1;
//                     busy <= 1'b0;
//                 end
//             end
//         end
//     end
//     assign p = P;
// endmodule


// /* 
// 3. Unsigned Bit Serial Multiplication - with right shifts 
// p(j+1) = 2p(j) + x(k-j-1) * a
// -> p(k) = ax + p(0) * 2^k

// Remarks: 
// not used in practice due to the need for wide adders
// can make a fma similarly to the right shift version
// */

// module bitSerialMultiplier #(parameter N = 8) (
//     input  logic            clk,
//     input  logic            rst_n,
//     input  logic            start,
//     input  logic [N-1:0]    a,
//     input  logic [N-1:0]    x,
//     output logic [2*N-1:0]  p,
//     output logic            done
// ); 
//     logic [2*N-1:0]         A;
//     logic [N-1:0]           X;
//     logic [2*N-1:0]         P;
//     logic [$clog2(N+1)-1:0] count;
//     logic busy;

//     always_ff @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             A     <= '0;
//             X     <= '0;
//             P     <= '0;
//             count <= '0;
//             done  <= 1'b0;
//             busy  <= 1'b0;
//         end 
//         else if (start && !busy) begin
//             A     <= {{N{1'b0}}, a};        //zero extend
//             X     <= x;
//             P     <= '0;
//             count <= N;
//             done  <= 1'b0;
//             busy  <= 1'b1;
//         end 
//         else if (busy) begin
//             if (count > 0) begin
//                 if (X[N-1])
//                     P <= (P << 1) + A;      // 2N wide adder
//                 else
//                     P <= (P << 1);

//                 X <= X << 1;
//                 count <= count - 1;

//                 if (count == 1) begin
//                     done <= 1'b1;
//                     busy <= 1'b0;
//                 end
//             end
//         end
//     end
//     assign p = P;
// endmodule





/////////          Signed Integer Multipliers         //////////
//                                                            //

/* 
4. We can complement the negtaive operand(s) and multiply the
resulting operands as unisinged integers, the sign of the result
is the xor of the signs of the operands.
Remarks:
 - ok for 1's complement, but too much overhead for 2's complement
*/


/*
5. We can prceding multiplier for 2's complement multiplicand
and multiplier.
I. Sign-extend the multiplicand to N+1 bits. (to 2N if left shifts are used)
II. If we use sign-extended values during the addition. 
(for right shift algorithm we need N+1 bit adder (2N adder if left shifts), or a k-bit adder can
be augmented with special logic to handle the extra bit at the left).
II. In the last cycle we subtract instead of adding.
(done by adding 2's complement of multiplicand or 
adding the 1's complment and setting carry in of the adder 1)
*/

module bitSerialMultiplier #(parameter N = 5) (
    input  logic            clk,
    input  logic            rst_n,
    input  logic            start,
    input  logic [N-1:0]    a,
    input  logic [N-1:0]    x,
    output logic [2*N-1:0]  p,
    output logic            done
); 
    logic [N:0]   A;
    logic [N:0]   A_1s_comp;
    logic [2*N:0] P;                  // shift register PP and Multiplier -> Answer
    logic [$clog2(N+1)-1:0] count;
    logic busy;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            A     <= '0;
            A_1s_comp <= '0;
            P     <= '0;
            count <= '0;
            done  <= 1'b0;
            busy  <= 1'b0;
        end 
        else if (start && !busy) begin
            A     <= {a[N-1], a};          // sign-extend
            A_1s_comp <= ~{a[N-1], a};     // 1's compl.
            P     <= {{(N+1)'b0}, x};
            count <= N;
            done  <= 1'b0;
            busy  <= 1'b1;
        end 
        else if (busy) begin
            if (count > 0) begin
                logic [N:0] sum;            // carry + sum; N bit adder
                logic carry_out;
                logic carry_in, last_cycle;
                logic [N:0] adder_in;

                carry_in = (count == 0);
                last_cycle = (count == 0);

                //adder_in = (P[0]) ? A : 0;                                // mux impl.
                adder_in = (last_cycle ? A_1s_comp : A) & {(N+1){P[0]}};     // and gate impl.
                {carry_out, sum} = P[2*N:N] + adder_in + carry_in;       // N+1 bit adder

                // >>> 1x
                P <= {carry_out, sum, P[N-1:1]};

                count <= count - 1;
            
                if (count == 1) begin
                    done <= 1'b1;
                    busy <= 1'b0;
                end
            end
        end
    end
    assign p = P[2*N:0];
endmodule

/*
6. Booth's Algorithm for signed multiplication

2^j+2^(j-1)+...+2^i = 2^(j+1) - 2^i
Booth encoding of radix2 transform [0,1] -> [-1,1].
Recorded number may have one more digit than the original number.
(if the number is unsigned we can ignore the extra digit at the MSB side in the recorderd number,
if it is signed ignoring the extra digit gives the proper handling of negative numbers)

go from LSB to MSB of the multiplier
    Previous Bit | Current Bit | Action
    ---------------------------------------
         0       |      0      |    0
         0       |      1      |   +1
         1       |      0      |   -1
         1       |      1      |    0

Remarks:
- Booth's recoding can used to speed up programmed multipliers
*/



/*
7. Multiplication by a Constant using Shift-and-Add/subtract
- can optmized using booth's recoding
- optimal code is NP-complete, but has derived by exhaustive means
*/