// ============================================================
// Module: mux4to1_32
// Description: 4-to-1 Multiplexer with 32-bit inputs
//              Fig. B.4.2 — Verilog definition of a 4-to-1
//              Multiplexor with 32-bit inputs, using a case statement
//              (Patterson & Hennessy, Computer Organization & Design)
// ============================================================
module mux4to1_32 (
    input  logic [31:0] d0,   // Input 0 (selected when sel = 2'b00)
    input  logic [31:0] d1,   // Input 1 (selected when sel = 2'b01)
    input  logic [31:0] d2,   // Input 2 (selected when sel = 2'b10)
    input  logic [31:0] d3,   // Input 3 (selected when sel = 2'b11)
    input  logic [1:0]  sel,  // 2-bit selection signal
    output logic [31:0] y     // 32-bit output
);
    always @(*) begin
        case (sel)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            2'b11: y = d3;
            default: y = 32'bx;
        endcase
    end
endmodule
