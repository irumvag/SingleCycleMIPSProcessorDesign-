// ============================================================
// Module: instr_memory
// Description: MIPS Instruction Memory (ROM)
//              Single-port, synchronous read, word-addressed.
//              Stores up to 64 32-bit MIPS instructions.
//              Address input uses PC[7:2] (word-aligned).
//
//              Pre-loaded with a simple test program:
//                addi $t0, $0,  5      # $t0 = 5
//                addi $t1, $0, 12      # $t1 = 12
//                add  $t2, $t0, $t1   # $t2 = $t0 + $t1 = 17
//                sub  $t3, $t1, $t0   # $t3 = $t1 - $t0 = 7
//                and  $t4, $t0, $t1   # $t4 = $t0 & $t1 = 4
//                or   $t5, $t0, $t1   # $t5 = $t0 | $t1 = 13
//                slt  $t6, $t0, $t1   # $t6 = ($t0<$t1)=1
//                sw   $t2, 0($0)      # Mem[0] = $t2
//                lw   $t7, 0($0)      # $t7 = Mem[0]
//                beq  $t0, $t0, 0     # branch taken (NOP loop)
// ============================================================
module instr_memory (
    input  logic [31:0] pc,          // Program counter (byte address)
    output logic [31:0] instr        // 32-bit instruction output
);
    logic [31:0] mem [0:63];         // 64-word instruction ROM

    initial begin
        // addi $t0, $0, 5       0x20080005
        mem[0]  = 32'h20080005;
        // addi $t1, $0, 12      0x2009000C
        mem[1]  = 32'h2009000C;
        // add  $t2, $t0, $t1   0x01095020
        mem[2]  = 32'h01095020;
        // sub  $t3, $t1, $t0   0x01285822
        mem[3]  = 32'h01285822;
        // and  $t4, $t0, $t1   0x01096024
        mem[4]  = 32'h01096024;
        // or   $t5, $t0, $t1   0x01096825
        mem[5]  = 32'h01096825;
        // slt  $t6, $t0, $t1   0x0109702A
        mem[6]  = 32'h0109702A;
        // sw   $t2, 0($0)      0xAC0A0000
        mem[7]  = 32'hAC0A0000;
        // lw   $t7, 0($0)      0x8C0F0000
        mem[8]  = 32'h8C0F0000;
        // beq  $t0, $t0, 0     0x11080000
        mem[9]  = 32'h11080000;
        // Remaining filled with NOP (sll $0,$0,0)
        begin : fill_nop
            integer k;
            for (k = 10; k < 64; k = k + 1)
                mem[k] = 32'h00000000;
        end
    end

    // Word-aligned read: ignore lower 2 bits of PC
    assign instr = mem[pc[7:2]];

endmodule
