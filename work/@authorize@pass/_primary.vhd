library verilog;
use verilog.vl_types.all;
entity AuthorizePass is
    generic(
        OFF             : vl_logic := Hi0;
        \ON\            : vl_logic := Hi1
    );
    port(
        Password        : in     vl_logic_vector(3 downto 0);
        Submit          : in     vl_logic;
        ID              : out    vl_logic_vector(3 downto 0);
        PassAuthorized  : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of OFF : constant is 1;
    attribute mti_svvh_generic_type of \ON\ : constant is 1;
end AuthorizePass;
