// ============================================================
// Module: data_memory
// Description: MIPS Data Memory (RAM)
//              Single-port synchronous write / asynchronous read.
//              64 words × 32 bits (256 bytes).
//              Address input uses addr[7:2] (word-aligned).
//
//              Write: on rising clock edge when mem_write = 1
//              Read:  combinational when mem_read = 1
// ============================================================
module data_memory (
    input  logic        clk,         // Clock
    input  logic        mem_write,   // Write enable (SW)
    input  logic        mem_read,    // Read  enable (LW)
    input  logic [31:0] addr,        // Byte address (from ALU result)
    input  logic [31:0] write_data,  // Data to write (from register)
    output logic [31:0] read_data    // Data read out (to register file)
);
    logic [31:0] mem [0:63];

    // Initialize memory to zero
    initial begin
        integer j;
        for (j = 0; j < 64; j = j + 1)
            mem[j] = 32'b0;
    end

    // Synchronous write
    always_ff @(posedge clk) begin
        if (mem_write)
            mem[addr[7:2]] <= write_data;
    end

    // Asynchronous read
    assign read_data = mem_read ? mem[addr[7:2]] : 32'b0;

endmodule
