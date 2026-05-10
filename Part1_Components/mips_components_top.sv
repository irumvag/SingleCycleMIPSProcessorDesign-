// ============================================================
// Module: mips_components_top
// Description: Top-level wrapper instantiating all Part I
//              MIPS processor components for synthesis and
//              simulation in Quartus II 13.1
// ============================================================
module mips_components_top (
    // --- 32-bit Full Adder ports ---
    input  logic [31:0] fa_a,
    input  logic [31:0] fa_b,
    input  logic        fa_cin,
    output logic [31:0] fa_sum,
    output logic        fa_cout,

    // --- 4-to-1 MUX (32-bit) ports ---
    input  logic [31:0] mux_d0,
    input  logic [31:0] mux_d1,
    input  logic [31:0] mux_d2,
    input  logic [31:0] mux_d3,
    input  logic [1:0]  mux_sel,
    output logic [31:0] mux_y,

    // --- 32-bit MIPS ALU ports ---
    input  logic [31:0] alu_a,
    input  logic [31:0] alu_b,
    input  logic [2:0]  alu_ctrl,
    output logic [31:0] alu_result,
    output logic        alu_zero,

    // --- ALU Control ports ---
    input  logic [1:0]  aluctrl_alu_op,
    input  logic [5:0]  aluctrl_funct,
    output logic [2:0]  aluctrl_out
);

    // --- Instantiate 32-bit Full Adder ---
    full_adder_32 u_full_adder (
        .a    (fa_a),
        .b    (fa_b),
        .cin  (fa_cin),
        .sum  (fa_sum),
        .cout (fa_cout)
    );

    // --- Instantiate 4-to-1 MUX with 32-bit inputs ---
    mux4to1_32 u_mux4to1 (
        .d0  (mux_d0),
        .d1  (mux_d1),
        .d2  (mux_d2),
        .d3  (mux_d3),
        .sel (mux_sel),
        .y   (mux_y)
    );

    // --- Instantiate 32-bit MIPS ALU ---
    alu_32 u_alu (
        .a        (alu_a),
        .b        (alu_b),
        .alu_ctrl (alu_ctrl),
        .result   (alu_result),
        .zero     (alu_zero)
    );

    // --- Instantiate ALU Control ---
    alu_control u_alu_ctrl (
        .alu_op   (aluctrl_alu_op),
        .funct    (aluctrl_funct),
        .alu_ctrl (aluctrl_out)
    );

endmodule
