// usefss
// ATM machine

module ATM(Clock,         // module clock
           Clear,         // module clear, if ON state must be base state
           CardIn,        // one bit, if a credit card inserted CardIn is ON, then Working is ON
           Eject,         // one bit, if Eject is ON credit card must put out, working is OFF
           Submit,        // one bit, if Submit is ON then Password and Value inputed
           Password,      // four bits, if it is authorized then go to nextstate
           Value,         // five bits, amount of money wanted to withdraw
           ShowBalance,   // one bit, button that just led to show the account balance
           Withdraw,      // one bit, button that withdraw money
           BalanceValue,  // five bit, output that shows the balance
           Ready,         // one bit, led that shows ATM is ready for a credit card
           Working,       // one bit, led that shows ATM is working
           ErrPass,       // one bit, Error that shows the password entered is unauthorized
           ErrValue,      // one bit, Error that shows account balance is not enough to withdraw
           State,         // just for debuging
           NextState,     // debug
           ID);    // debuging

  input Clock, Clear, CardIn, Eject, Submit, ShowBalance, Withdraw;
  input [3:0] Password;
  input [4:0] Value;
  output Ready, Working, ErrPass, ErrValue;
  reg Ready, Working, ErrPass, ErrValue;
  output [4:0] BalanceValue;


  parameter ON = 1'b1;
  parameter OFF = 1'b0;

  parameter     // states
        DEAD        = 4'b0001,     // state that can accept a credit card
        PASSCHECK   = 4'b0010,     // state that inputs password and check it if is authorized
        WORKPLACE   = 4'b0100,     // state that it can choose four differen options 1- balance 2-eject 3- balance and withdraw 4- just withdraw
        MONEY       = 4'b1000;     // state that input is available for withdrawing

  output reg [3:0] State;
  output reg [3:0] NextState;

  reg [4:0] accounts_balance_RAM [0:9];
  output [3:0] ID;       // id of person who entered the password
  wire PassAuthorized; // on if password was found in rom

  // inputing .mem file
  //
  initial begin
    $readmemb("accounts_balanceRAM.mem", accounts_balance_RAM);
    end

  // instantiate an object of type authorizePass to check
  AuthorizePass SomeRandomName(Password, Submit, ID, PassAuthorized);

  // instantiate an object of type BalanceView to show the balance
  BalanceView SomeRandomName2(ID, ShowBalance, BalanceValue);
  // wire BalanceValueOut;


  // Update state or reset on every + clock edge
  //
  always @(posedge Clock) begin
    if (Clear)
      State <= DEAD;
    else
      State <= NextState;
    end

  // Next state generation logic
  // OUTPUT generation logic
  always @(State or CardIn or Eject or Submit or ShowBalance or Withdraw or Password or Value) begin
    case (State)

      DEAD: begin
        ErrPass = OFF;
        ErrValue = OFF;
        if (CardIn) begin
          NextState = PASSCHECK;
          Working = ON;
          Ready = OFF;
          end
        else begin
          Ready = ON;
          Working = OFF;
          NextState = DEAD;
          end
        end

      PASSCHECK: begin
        Ready = OFF;
        Working = ON;
        ErrValue = OFF;
        if (Eject) begin
          NextState = DEAD;
          ErrPass = OFF;
          end
        else if (PassAuthorized) begin
          NextState = WORKPLACE;
          ErrPass = OFF;
          end
        else if (~PassAuthorized) begin
          NextState = PASSCHECK;
          ErrPass = ON;
          end
        else begin
          ErrPass = OFF;
          NextState = PASSCHECK;
          end
        end

      WORKPLACE: begin
        Ready = OFF;
        Working = ON;
        ErrPass = OFF;
        ErrValue = OFF;
        if (Eject)
          NextState = DEAD;
        else if (Withdraw)
          NextState = MONEY;
        else
          NextState = WORKPLACE;
        end

      MONEY: begin
        Ready = OFF;
        Working = ON;
        ErrPass = OFF;
        if (Eject) begin
          ErrValue = OFF;
          NextState = DEAD;
          end
        else if (accounts_balance_RAM[ID] >= Value & Submit) begin
          accounts_balance_RAM[ID] = accounts_balance_RAM[ID] - Value;
          ErrValue = OFF;
          NextState = WORKPLACE;
          end
        else if (accounts_balance_RAM[ID] < Value & Submit) begin
          ErrValue = ON;
          NextState = MONEY;
          end
        else begin
          ErrValue = OFF;
          NextState = MONEY;
          end
        end

      endcase
    end


// todo module return authorizepass and module that returns balancevalue and module that doing withdraw

endmodule //ATM module
