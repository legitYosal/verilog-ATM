library verilog;
use verilog.vl_types.all;
entity ATM is
    generic(
        \ON\            : vl_logic := Hi1;
        OFF             : vl_logic := Hi0;
        DEAD            : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi1);
        PASSCHECK       : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi0);
        WORKPLACE       : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi0);
        MONEY           : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi0)
    );
    port(
        Clock           : in     vl_logic;
        Clear           : in     vl_logic;
        CardIn          : in     vl_logic;
        Eject           : in     vl_logic;
        Submit          : in     vl_logic;
        Password        : in     vl_logic_vector(3 downto 0);
        Value           : in     vl_logic_vector(4 downto 0);
        ShowBalance     : in     vl_logic;
        Withdraw        : in     vl_logic;
        BalanceValue    : out    vl_logic_vector(4 downto 0);
        Ready           : out    vl_logic;
        Working         : out    vl_logic;
        ErrPass         : out    vl_logic;
        ErrValue        : out    vl_logic;
        State           : out    vl_logic_vector(3 downto 0);
        NextState       : out    vl_logic_vector(3 downto 0);
        ID              : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of \ON\ : constant is 1;
    attribute mti_svvh_generic_type of OFF : constant is 1;
    attribute mti_svvh_generic_type of DEAD : constant is 1;
    attribute mti_svvh_generic_type of PASSCHECK : constant is 1;
    attribute mti_svvh_generic_type of WORKPLACE : constant is 1;
    attribute mti_svvh_generic_type of MONEY : constant is 1;
end ATM;
