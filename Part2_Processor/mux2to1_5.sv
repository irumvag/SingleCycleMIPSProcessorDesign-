// ============================================================
// Module: mux2to1_5
// Description: 2-to-1 Multiplexer with 5-bit inputs
//              Used to select the write register address:
//              RT (R[20:16]) for I-type, RD (R[15:11]) for R-type
//              Controlled by RegDst from the control unit
// ============================================================
module mux2to1_5 (
    input  logic [4:0] d0,   // Input 0: rt field (selected when sel = 1'b0)
    input  logic [4:0] d1,   // Input 1: rd field (selected when sel = 1'b1)
    input  logic       sel,  // 1-bit selection signal (RegDst)
    output logic [4:0] y     // 5-bit output: write register number
);
    assign y = sel ? d1 : d0;
endmodule
