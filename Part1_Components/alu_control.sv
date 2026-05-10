// ============================================================
// Module: alu_control
// Description: MIPS ALU Control Unit
//              Implements Fig. B.5.16 — The MIPS ALU Control:
//              a simple piece of Combinational Control Logic
//              (Patterson & Hennessy, Computer Organization & Design)
//
// ALUOp encoding:
//   2'b00 -> LW / SW (ADD)
//   2'b01 -> BEQ     (SUB)
//   2'b10 -> R-type  (decode from funct field)
//
// Funct field encoding (R-type):
//   6'b100000 -> ADD
//   6'b100010 -> SUB
//   6'b100100 -> AND
//   6'b100101 -> OR
//   6'b101010 -> SLT
// ============================================================
module alu_control (
    input  logic [1:0] alu_op,    // From main control unit (2 bits)
    input  logic [5:0] funct,     // Funct field from instruction [5:0]
    output logic [2:0] alu_ctrl   // Control signal to ALU
);
    always @(*) begin
        case (alu_op)
            2'b00: alu_ctrl = 3'b010;   // LW/SW: ADD
            2'b01: alu_ctrl = 3'b110;   // BEQ: SUB
            2'b10: begin                // R-type: decode funct field
                case (funct)
                    6'b100000: alu_ctrl = 3'b010; // ADD
                    6'b100010: alu_ctrl = 3'b110; // SUB
                    6'b100100: alu_ctrl = 3'b000; // AND
                    6'b100101: alu_ctrl = 3'b001; // OR
                    6'b101010: alu_ctrl = 3'b111; // SLT
                    default:   alu_ctrl = 3'bxxx;
                endcase
            end
            default: alu_ctrl = 3'bxxx;
        endcase
    end
endmodule
