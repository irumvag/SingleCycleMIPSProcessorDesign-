// ============================================================
// Module: mux2to1_32
// Description: 2-to-1 Multiplexer with 32-bit inputs
//              Used throughout the MIPS datapath (e.g., ALUSrc,
//              MemToReg selection)
// ============================================================
module mux2to1_32 (
    input  logic [31:0] d0,   // Input 0 (selected when sel = 1'b0)
    input  logic [31:0] d1,   // Input 1 (selected when sel = 1'b1)
    input  logic        sel,  // 1-bit selection signal
    output logic [31:0] y     // 32-bit output
);
    assign y = sel ? d1 : d0;
endmodule
