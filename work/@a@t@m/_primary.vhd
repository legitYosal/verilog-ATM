library verilog;
use verilog.vl_types.all;
entity ATM is
    generic(
        OFF             : vl_logic := Hi0;
        \ON\            : vl_logic := Hi1;
        X               : vl_logic := HiX;
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        CHECKPASS       : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        SHOWBALANCE     : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        WITHDRAW        : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        WITHDRAWSHOW    : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        TRANSFER        : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        wwwwwwww        : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi1)
    );
    port(
        Clock           : in     vl_logic_vector(0 downto 0);
        Reset           : in     vl_logic_vector(0 downto 0);
        Password        : in     vl_logic_vector(7 downto 0);
        ID              : in     vl_logic_vector(7 downto 0);
        Control         : in     vl_logic_vector(2 downto 0);
        Back            : in     vl_logic_vector(0 downto 0);
        Eject           : in     vl_logic_vector(0 downto 0);
        Request         : in     vl_logic_vector(7 downto 0);
        ErrPass         : out    vl_logic_vector(0 downto 0);
        ErrBalance      : out    vl_logic_vector(0 downto 0);
        ErrID           : out    vl_logic_vector(0 downto 0);
        BalanceValue    : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of OFF : constant is 1;
    attribute mti_svvh_generic_type of \ON\ : constant is 1;
    attribute mti_svvh_generic_type of X : constant is 1;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of CHECKPASS : constant is 1;
    attribute mti_svvh_generic_type of SHOWBALANCE : constant is 1;
    attribute mti_svvh_generic_type of WITHDRAW : constant is 1;
    attribute mti_svvh_generic_type of WITHDRAWSHOW : constant is 1;
    attribute mti_svvh_generic_type of TRANSFER : constant is 1;
    attribute mti_svvh_generic_type of wwwwwwww : constant is 1;
end ATM;
