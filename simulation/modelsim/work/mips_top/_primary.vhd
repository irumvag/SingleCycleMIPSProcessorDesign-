library verilog;
use verilog.vl_types.all;
entity mips_top is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        pc_out          : out    vl_logic_vector(31 downto 0);
        alu_result_out  : out    vl_logic_vector(31 downto 0);
        zero_out        : out    vl_logic
    );
end mips_top;
