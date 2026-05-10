// Testbench: tb_alu_32
// Tests all 6 ALU operations with expected result checking
`timescale 1ns/1ps

module tb_alu_32;

    logic [31:0] a, b;
    logic [2:0]  alu_ctrl;
    logic [31:0] result;
    logic        zero;

    // Instantiate DUT
    alu_32 dut (
        .a        (a),
        .b        (b),
        .alu_ctrl (alu_ctrl),
        .result   (result),
        .zero     (zero)
    );

    // Display header
    initial begin
        $display("=================================================");
        $display("  alu_32 Functional Simulation");
        $display("=================================================");
        $display("Time | alu_ctrl | Operation | A          | B          | Result     | Zero");
        $display("-----|----------|-----------|------------|------------|------------|-----");
    end

    // Monitor changes
    initial begin
        $monitor("%4t |   %b    | %-9s | %h | %h | %h |  %b",
                 $time, alu_ctrl,
                 (alu_ctrl==3'b000) ? "AND" :
                 (alu_ctrl==3'b001) ? "OR"  :
                 (alu_ctrl==3'b010) ? "ADD" :
                 (alu_ctrl==3'b110) ? "SUB" :
                 (alu_ctrl==3'b111) ? "SLT" :
                 (alu_ctrl==3'b100) ? "NOR" : "???",
                 a, b, result, zero);
    end

    task apply_and_check(
        input [2:0]  ctrl,
        input [31:0] in_a, in_b,
        input [31:0] expected_result,
        input        expected_zero
    );
        alu_ctrl = ctrl;
        a = in_a;
        b = in_b;
        #20;
        if (result !== expected_result || zero !== expected_zero) begin
            $display("FAIL: ctrl=%b a=%h b=%h expected=%h/%b got=%h/%b",
                     ctrl, in_a, in_b, expected_result, expected_zero, result, zero);
        end
    endtask

    initial begin
        // Test 1: AND — FFFF0000 & 0000FFFF = 00000000, zero=1
        apply_and_check(3'b000, 32'hFFFF0000, 32'h0000FFFF, 32'h00000000, 1'b1);

        // Test 2: OR  — FFFF0000 | 0000FFFF = FFFFFFFF, zero=0
        apply_and_check(3'b001, 32'hFFFF0000, 32'h0000FFFF, 32'hFFFFFFFF, 1'b0);

        // Test 3: ADD — 5 + 3 = 8, zero=0
        apply_and_check(3'b010, 32'h00000005, 32'h00000003, 32'h00000008, 1'b0);

        // Test 4: SUB — 10 - 3 = 7, zero=0
        apply_and_check(3'b110, 32'h0000000A, 32'h00000003, 32'h00000007, 1'b0);

        // Test 5: SLT — 3 < 10 → result=1, zero=0
        apply_and_check(3'b111, 32'h00000003, 32'h0000000A, 32'h00000001, 1'b0);

        // Test 6: NOR — ~(FFFF0000 | 0000FFFF) = 00000000, zero=1
        apply_and_check(3'b100, 32'hFFFF0000, 32'h0000FFFF, 32'h00000000, 1'b1);

        // Bonus: SUB same values → zero=1
        apply_and_check(3'b110, 32'h00000005, 32'h00000005, 32'h00000000, 1'b1);

        $display("=================================================");
        $display("  Simulation complete.");
        $display("=================================================");
        $finish;
    end

endmodule
