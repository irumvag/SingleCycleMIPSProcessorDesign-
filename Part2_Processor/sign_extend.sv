// ============================================================
// Module: sign_extend
// Description: 16-bit to 32-bit Sign Extender
//              Extends the 16-bit immediate field of I-type
//              MIPS instructions to 32 bits by replicating
//              the sign bit (bit 15) into bits [31:16].
//
//              Used for: LW, SW, BEQ, ADDI, etc.
// ============================================================
module sign_extend (
    input  logic [15:0] imm16,   // 16-bit immediate from instruction [15:0]
    output logic [31:0] imm32    // Sign-extended 32-bit result
);
    assign imm32 = {{16{imm16[15]}}, imm16};
endmodule
