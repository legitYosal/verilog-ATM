library verilog;
use verilog.vl_types.all;
entity TestBench is
    generic(
        TRUE            : vl_logic := Hi1;
        FALSE           : vl_logic := Hi0;
        CLOCK_CYCLE     : integer := 10;
        CLOCK_WIDTH     : vl_notype;
        IDLE_CLOCKS     : integer := 2
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of TRUE : constant is 1;
    attribute mti_svvh_generic_type of FALSE : constant is 1;
    attribute mti_svvh_generic_type of CLOCK_CYCLE : constant is 1;
    attribute mti_svvh_generic_type of CLOCK_WIDTH : constant is 3;
    attribute mti_svvh_generic_type of IDLE_CLOCKS : constant is 1;
end TestBench;
