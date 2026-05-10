// ============================================================
// Module: alu_32
// Description: 32-bit MIPS Arithmetic Logic Unit (ALU)
//              Implements Fig. B.5.15 — A Verilog behavioral
//              definition of a MIPS ALU
//              (Patterson & Hennessy, Computer Organization & Design)
//
// ALU Control Signal Encoding:
//   3'b000 -> AND
//   3'b001 -> OR
//   3'b010 -> ADD
//   3'b110 -> SUB (a - b)
//   3'b111 -> SLT (Set Less Than: result=1 if a < b)
//   3'b100 -> NOR
// ============================================================
module alu_32 (
    input  logic [31:0] a,          // First operand
    input  logic [31:0] b,          // Second operand
    input  logic [2:0]  alu_ctrl,   // ALU control signal (3 bits)
    output logic [31:0] result,     // 32-bit ALU result
    output logic        zero        // Zero flag: 1 when result == 0
);
    always @(*) begin
        case (alu_ctrl)
            3'b000: result = a & b;                          // AND
            3'b001: result = a | b;                          // OR
            3'b010: result = a + b;                          // ADD
            3'b110: result = a - b;                          // SUB
            3'b111: result = {{31{1'b0}}, ($signed(a) < $signed(b))}; // SLT
            3'b100: result = ~(a | b);                       // NOR
            default: result = 32'bx;
        endcase
    end

    assign zero = (result == 32'b0);

endmodule
