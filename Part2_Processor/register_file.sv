// ============================================================
// Module: register_file
// Description: MIPS 32x32 Register File
//              Implements Fig. B.3.1 — A register file
//              (Patterson & Hennessy, Computer Organization & Design)
//
//              - 32 registers, each 32 bits wide
//              - Two asynchronous read ports (combinational)
//              - One synchronous write port (rising-edge clocked)
//              - Register $0 (r0) is hardwired to zero
// ============================================================
module register_file (
    input  logic        clk,       // Clock (write on rising edge)
    input  logic        we3,       // Write enable (RegWrite from control unit)
    input  logic [4:0]  ra1,       // Read address 1: rs field [25:21]
    input  logic [4:0]  ra2,       // Read address 2: rt field [20:16]
    input  logic [4:0]  wa3,       // Write address:  rd or rt (after mux)
    input  logic [31:0] wd3,       // Write data
    output logic [31:0] rd1,       // Read data 1
    output logic [31:0] rd2        // Read data 2
);
    // 32 registers of 32 bits
    logic [31:0] rf [31:0];

    // Synchronous write (register $0 stays zero)
    always_ff @(posedge clk) begin
        if (we3 && (wa3 != 5'b00000))
            rf[wa3] <= wd3;
    end

    // Asynchronous reads; $0 always returns 0
    assign rd1 = (ra1 != 5'b00000) ? rf[ra1] : 32'b0;
    assign rd2 = (ra2 != 5'b00000) ? rf[ra2] : 32'b0;

endmodule
