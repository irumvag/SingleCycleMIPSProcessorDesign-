// ============================================================
// Module: mips_top
// Description: Single-Cycle MIPS Processor — Top-Level Datapath
//              Implements the complete single-cycle MIPS CPU
//              following Fig. B.5.10 / B.5.11 in:
//              Patterson & Hennessy, Computer Organization & Design
//
// Supported instructions:
//   R-type: add, sub, and, or, slt
//   I-type: lw, sw, beq
//
// Datapath Overview:
//   PC  → Instr Memory → Decode → Register File → ALU → Data Memory → WB
//   Control Unit generates: RegDst, ALUSrc, MemToReg, RegWrite,
//                           MemRead, MemWrite, Branch, ALUOp[1:0]
//   ALU Control decodes ALUOp + funct → alu_ctrl[2:0]
// ============================================================
module mips_top (
    input  logic        clk,        // System clock
    input  logic        reset,      // Synchronous reset (active high)
    output logic [31:0] pc_out,     // Current PC (for observation/debug)
    output logic [31:0] alu_result_out, // ALU result (for observation)
    output logic        zero_out    // ALU zero flag (for observation)
);

    // --------------------------------------------------------
    // Internal signal declarations
    // --------------------------------------------------------

    // PC / branch
    logic [31:0] pc, pc_next, pc_plus4, pc_branch;
    logic        pc_src;

    // Instruction fields
    logic [31:0] instr;
    logic [5:0]  op, funct;
    logic [4:0]  rs, rt, rd;
    logic [15:0] imm16;

    // Control signals
    logic        reg_dst, alu_src, mem_to_reg;
    logic        reg_write, mem_read, mem_write, branch;
    logic [1:0]  alu_op;
    logic [2:0]  alu_ctrl;

    // Datapath signals
    logic [4:0]  write_reg;
    logic [31:0] rd1, rd2;
    logic [31:0] sign_imm;
    logic [31:0] alu_b;
    logic [31:0] alu_result;
    logic        alu_zero;
    logic [31:0] mem_read_data;
    logic [31:0] write_back_data;

    // --------------------------------------------------------
    // Instruction field extraction
    // --------------------------------------------------------
    assign op    = instr[31:26];
    assign rs    = instr[25:21];
    assign rt    = instr[20:16];
    assign rd    = instr[15:11];
    assign imm16 = instr[15:0];
    assign funct = instr[5:0];

    // --------------------------------------------------------
    // PC Logic
    // --------------------------------------------------------
    assign pc_plus4  = pc + 32'd4;
    assign pc_branch = pc_plus4 + {sign_imm[29:0], 2'b00};  // left-shift sign_imm by 2
    assign pc_src    = branch & alu_zero;
    assign pc_next   = pc_src ? pc_branch : pc_plus4;

    always_ff @(posedge clk) begin
        if (reset)
            pc <= 32'h0000_0000;
        else
            pc <= pc_next;
    end

    assign pc_out         = pc;
    assign alu_result_out = alu_result;
    assign zero_out       = alu_zero;

    // --------------------------------------------------------
    // Instruction Memory
    // --------------------------------------------------------
    instr_memory u_imem (
        .pc    (pc),
        .instr (instr)
    );

    // --------------------------------------------------------
    // Control Unit
    // --------------------------------------------------------
    control_unit u_ctrl (
        .op        (op),
        .reg_dst   (reg_dst),
        .alu_src   (alu_src),
        .mem_to_reg(mem_to_reg),
        .reg_write (reg_write),
        .mem_read  (mem_read),
        .mem_write (mem_write),
        .branch    (branch),
        .alu_op    (alu_op)
    );

    // --------------------------------------------------------
    // Register File
    // --------------------------------------------------------
    mux2to1_5 u_reg_dst_mux (
        .d0  (rt),
        .d1  (rd),
        .sel (reg_dst),
        .y   (write_reg)
    );

    register_file u_rf (
        .clk (clk),
        .we3 (reg_write),
        .ra1 (rs),
        .ra2 (rt),
        .wa3 (write_reg),
        .wd3 (write_back_data),
        .rd1 (rd1),
        .rd2 (rd2)
    );

    // --------------------------------------------------------
    // Sign Extend
    // --------------------------------------------------------
    sign_extend u_sext (
        .imm16 (imm16),
        .imm32 (sign_imm)
    );

    // --------------------------------------------------------
    // ALU
    // --------------------------------------------------------
    mux2to1_32 u_alu_src_mux (
        .d0  (rd2),
        .d1  (sign_imm),
        .sel (alu_src),
        .y   (alu_b)
    );

    alu_control u_alu_ctrl (
        .alu_op   (alu_op),
        .funct    (funct),
        .alu_ctrl (alu_ctrl)
    );

    alu_32 u_alu (
        .a        (rd1),
        .b        (alu_b),
        .alu_ctrl (alu_ctrl),
        .result   (alu_result),
        .zero     (alu_zero)
    );

    // --------------------------------------------------------
    // Data Memory
    // --------------------------------------------------------
    data_memory u_dmem (
        .clk        (clk),
        .mem_write  (mem_write),
        .mem_read   (mem_read),
        .addr       (alu_result),
        .write_data (rd2),
        .read_data  (mem_read_data)
    );

    // --------------------------------------------------------
    // Write-back MUX
    // --------------------------------------------------------
    mux2to1_32 u_wb_mux (
        .d0  (alu_result),
        .d1  (mem_read_data),
        .sel (mem_to_reg),
        .y   (write_back_data)
    );

endmodule
