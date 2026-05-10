// ============================================================
// Module: full_adder_1bit
// Description: 1-bit Full Adder (structural gate-level)
// ============================================================
module full_adder_1bit (
    input  logic a, b, cin,
    output logic sum, cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// ============================================================
// Module: full_adder_32
// Description: 32-bit Ripple Carry Adder
//              Built from 32 instances of full_adder_1bit
// ============================================================
module full_adder_32 (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic        cin,
    output logic [31:0] sum,
    output logic        cout
);
    logic [32:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : fa_chain
            full_adder_1bit fa_inst (
                .a    (a[i]),
                .b    (b[i]),
                .cin  (carry[i]),
                .sum  (sum[i]),
                .cout (carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[32];
endmodule
