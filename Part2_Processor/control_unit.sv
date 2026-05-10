// ============================================================
// Module: control_unit
// Description: MIPS Main Control Unit
//              Implements Fig. B.5.9 — The simple control unit
//              (Patterson & Hennessy, Computer Organization & Design)
//
// Supported instructions and their control signals:
// -------------------------------------------------------
//  Instr  | Op[5:0] | RegDst | ALUSrc | MemToReg | RegWrite
//         |         |        |        |          |
//  R-type | 000000  |   1    |   0    |    0     |    1
//  LW     | 100011  |   0    |   1    |    1     |    1
//  SW     | 101011  |   -    |   1    |    -     |    0
//  BEQ    | 000100  |   -    |   0    |    -     |    0
//
//  Instr  | MemWrite | Branch | ALUOp[1:0]
//  R-type |    0     |   0    |    10
//  LW     |    0     |   0    |    00
//  SW     |    1     |   0    |    00
//  BEQ    |    0     |   1    |    01
// ============================================================
module control_unit (
    input  logic [5:0] op,          // Instruction opcode [31:26]
    output logic       reg_dst,     // 0=rt, 1=rd as write register
    output logic       alu_src,     // 0=RD2, 1=SignImm as ALU B input
    output logic       mem_to_reg,  // 0=ALUResult, 1=ReadData as write-back
    output logic       reg_write,   // 1=enable register file write
    output logic       mem_read,    // 1=enable data memory read (LW)
    output logic       mem_write,   // 1=enable data memory write (SW)
    output logic       branch,      // 1=BEQ: enable PC+4+offset if Zero
    output logic [1:0] alu_op       // ALU operation selector -> ALU Control
);
    always @(*) begin
        // Default: all signals deasserted (NOP-like)
        reg_dst   = 1'b0;
        alu_src   = 1'b0;
        mem_to_reg= 1'b0;
        reg_write = 1'b0;
        mem_read  = 1'b0;
        mem_write = 1'b0;
        branch    = 1'b0;
        alu_op    = 2'b00;

        case (op)
            6'b000000: begin  // R-type
                reg_dst   = 1'b1;
                alu_src   = 1'b0;
                mem_to_reg= 1'b0;
                reg_write = 1'b1;
                mem_read  = 1'b0;
                mem_write = 1'b0;
                branch    = 1'b0;
                alu_op    = 2'b10;
            end
            6'b100011: begin  // LW
                reg_dst   = 1'b0;
                alu_src   = 1'b1;
                mem_to_reg= 1'b1;
                reg_write = 1'b1;
                mem_read  = 1'b1;
                mem_write = 1'b0;
                branch    = 1'b0;
                alu_op    = 2'b00;
            end
            6'b101011: begin  // SW
                reg_dst   = 1'bx;
                alu_src   = 1'b1;
                mem_to_reg= 1'bx;
                reg_write = 1'b0;
                mem_read  = 1'b0;
                mem_write = 1'b1;
                branch    = 1'b0;
                alu_op    = 2'b00;
            end
            6'b001000: begin  // ADDI
                reg_dst   = 1'b0;
                alu_src   = 1'b1;
                mem_to_reg= 1'b0;
                reg_write = 1'b1;
                mem_read  = 1'b0;
                mem_write = 1'b0;
                branch    = 1'b0;
                alu_op    = 2'b00;
            end
            6'b000100: begin  // BEQ
                reg_dst   = 1'bx;
                alu_src   = 1'b0;
                mem_to_reg= 1'bx;
                reg_write = 1'b0;
                mem_read  = 1'b0;
                mem_write = 1'b0;
                branch    = 1'b1;
                alu_op    = 2'b01;
            end
            default: ; // retain deasserted defaults
        endcase
    end
endmodule
