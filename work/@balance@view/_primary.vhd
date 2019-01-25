library verilog;
use verilog.vl_types.all;
entity BalanceView is
    port(
        ID              : in     vl_logic_vector(3 downto 0);
        ShowBalance     : in     vl_logic;
        BalanceValue    : out    vl_logic_vector(4 downto 0)
    );
end BalanceView;
