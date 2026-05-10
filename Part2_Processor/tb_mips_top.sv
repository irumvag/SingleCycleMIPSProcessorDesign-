// Testbench: tb_mips_top
// Single-Cycle MIPS Processor functional simulation
// Tests: addi, add, sub, and, or, slt, sw, lw, beq
`timescale 1ns/1ps

module tb_mips_top;

    logic        clk, reset;
    logic [31:0] pc_out, alu_result_out;
    logic        zero_out;

    // Instantiate DUT
    mips_top dut (
        .clk            (clk),
        .reset          (reset),
        .pc_out         (pc_out),
        .alu_result_out (alu_result_out),
        .zero_out       (zero_out)
    );

    // 20 ns clock (50 MHz)
    initial clk = 0;
    always #10 clk = ~clk;

    // Expected register values after each instruction
    // Cycle 0 reset, Cycle 1: addi $t0=5, Cycle 2: addi $t1=12
    // Cycle 3: add $t2=17, Cycle 4: sub $t3=7
    // Cycle 5: and $t4=4,  Cycle 6: or  $t5=13
    // Cycle 7: slt $t6=1,  Cycle 8: sw Mem[0]=17
    // Cycle 9: lw  $t7=17, Cycle 10: beq (taken, loop)

    // Header
    initial begin
        $display("=========================================================");
        $display("  Single-Cycle MIPS Processor — Functional Simulation");
        $display("=========================================================");
        $display("Time  | Cycle | PC   | ALU_Result | Zero | Expected");
        $display("------|-------|------|------------|------|----------");
    end

    // Monitor
    integer cycle;
    initial cycle = 0;
    always @(posedge clk) begin
        if (!reset) begin
            $display("%5t |  %2d   | %4h | %10h |  %b   | see table",
                     $time, cycle, pc_out, alu_result_out, zero_out);
            cycle = cycle + 1;
        end
    end

    // Stimulus + checks
    initial begin
        // Reset for 2 cycles
        reset = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        reset = 0;

        // Cycle 1: addi $t0, $0, 5  → ALU result = 5, PC = 0x00
        @(posedge clk); #1;
        if (alu_result_out !== 32'd5)
            $display("FAIL Cycle1 addi $t0=5: got %h", alu_result_out);
        else $display("PASS Cycle1 addi $t0=5");

        // Cycle 2: addi $t1, $0, 12 → ALU result = 12, PC = 0x04
        @(posedge clk); #1;
        if (alu_result_out !== 32'd12)
            $display("FAIL Cycle2 addi $t1=12: got %h", alu_result_out);
        else $display("PASS Cycle2 addi $t1=12");

        // Cycle 3: add $t2,$t0,$t1 → 5+12=17, PC = 0x08
        @(posedge clk); #1;
        if (alu_result_out !== 32'd17)
            $display("FAIL Cycle3 add $t2=17: got %h", alu_result_out);
        else $display("PASS Cycle3 add $t2=17");

        // Cycle 4: sub $t3,$t1,$t0 → 12-5=7, PC = 0x0C
        @(posedge clk); #1;
        if (alu_result_out !== 32'd7)
            $display("FAIL Cycle4 sub $t3=7: got %h", alu_result_out);
        else $display("PASS Cycle4 sub $t3=7");

        // Cycle 5: and $t4,$t0,$t1 → 5&12=4, PC = 0x10
        @(posedge clk); #1;
        if (alu_result_out !== 32'd4)
            $display("FAIL Cycle5 and $t4=4: got %h", alu_result_out);
        else $display("PASS Cycle5 and $t4=4");

        // Cycle 6: or $t5,$t0,$t1 → 5|12=13, PC = 0x14
        @(posedge clk); #1;
        if (alu_result_out !== 32'd13)
            $display("FAIL Cycle6 or $t5=13: got %h", alu_result_out);
        else $display("PASS Cycle6 or $t5=13");

        // Cycle 7: slt $t6,$t0,$t1 → 5<12=1, PC = 0x18
        @(posedge clk); #1;
        if (alu_result_out !== 32'd1)
            $display("FAIL Cycle7 slt $t6=1: got %h", alu_result_out);
        else $display("PASS Cycle7 slt $t6=1");

        // Cycle 8: sw $t2,0($0) → addr=0, no ALU result check
        @(posedge clk); #1;
        $display("INFO Cycle8 sw Mem[0]=$t2 (addr=%h)", alu_result_out);

        // Cycle 9: lw $t7,0($0) → addr=0
        @(posedge clk); #1;
        $display("INFO Cycle9 lw $t7=Mem[0] (addr=%h)", alu_result_out);

        // Cycle 10: beq $t0,$t0,0 → zero=1, PC stays (branch to self)
        @(posedge clk); #1;
        if (zero_out !== 1'b1)
            $display("FAIL Cycle10 beq zero flag: got %b", zero_out);
        else $display("PASS Cycle10 beq zero=1 (branch taken)");

        // Run a few more to confirm PC loops
        repeat(3) @(posedge clk);

        $display("=========================================================");
        $display("  Simulation complete.");
        $display("=========================================================");
        $finish;
    end

endmodule
