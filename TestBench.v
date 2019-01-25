module TestBench;
  reg Clock, Clear, CardIn, Eject, Submit, ShowBalance, Withdraw;
  reg [3:0] Password;
  reg [4:0] Value;
  
  wire Ready, Working, ErrPass, ErrValue;
  wire [3:0] ID;
  wire [4:0] BalanceValue;
  wire [3:0] State;
  wire [3:0] NextState;

  parameter TRUE   = 1'b1;
  parameter FALSE  = 1'b0;
  parameter CLOCK_CYCLE  = 10;
  parameter CLOCK_WIDTH  = CLOCK_CYCLE/2;
  parameter IDLE_CLOCKS  = 2;

  // instantiate an object of type TicketMachine to test

  ATM TFSM(Clock, Clear, CardIn, Eject, Submit, Password, Value, ShowBalance,
           Withdraw, BalanceValue, Ready, Working, ErrPass, ErrValue, State, NextState, ID);

  // set up monitor
  //

  // initial begin
  //   forever @(posedge Clock) begin
  //     #1
  //     $display($time, "    %b    %b        %b", CardIn, Password, State);
  //     end
  //   end

  // Create free running clock
  //

  initial begin
    Clock = FALSE;
    forever #CLOCK_WIDTH Clock = ~Clock;
    end

  // Generate stimulus after waiting for reset
  //

  initial begin

    Clear = 1;
    repeat (2) @(negedge Clock);
    Clear = 0;
    repeat (2) @(negedge Clock);   // case one
    CardIn = 1;
    repeat (2) @(negedge Clock);
    Password = 4'b0000;
    repeat (1) @(negedge Clock);
    Submit = 1;
    repeat (1) @(negedge Clock);
    Submit = 0;
    repeat (1) @(negedge Clock);
    Password = 4'b1111;
    repeat (1) @(negedge Clock);
    Submit = 1;
    repeat (1) @(negedge Clock);
    repeat (1) @(negedge Clock);
       
    
    $stop;

    end

  endmodule
