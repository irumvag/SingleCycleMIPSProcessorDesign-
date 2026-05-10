library verilog;
use verilog.vl_types.all;
entity mips_components_top is
    port(
        fa_a            : in     vl_logic_vector(31 downto 0);
        fa_b            : in     vl_logic_vector(31 downto 0);
        fa_cin          : in     vl_logic;
        fa_sum          : out    vl_logic_vector(31 downto 0);
        fa_cout         : out    vl_logic;
        mux_d0          : in     vl_logic_vector(31 downto 0);
        mux_d1          : in     vl_logic_vector(31 downto 0);
        mux_d2          : in     vl_logic_vector(31 downto 0);
        mux_d3          : in     vl_logic_vector(31 downto 0);
        mux_sel         : in     vl_logic_vector(1 downto 0);
        mux_y           : out    vl_logic_vector(31 downto 0);
        alu_a           : in     vl_logic_vector(31 downto 0);
        alu_b           : in     vl_logic_vector(31 downto 0);
        alu_ctrl        : in     vl_logic_vector(2 downto 0);
        alu_result      : out    vl_logic_vector(31 downto 0);
        alu_zero        : out    vl_logic;
        aluctrl_alu_op  : in     vl_logic_vector(1 downto 0);
        aluctrl_funct   : in     vl_logic_vector(5 downto 0);
        aluctrl_out     : out    vl_logic_vector(2 downto 0)
    );
end mips_components_top;
