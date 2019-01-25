module PasswordAndIdChecker(Password,ID,IndexOutput,PassAuthorized);
  input [7:0] Password;
  input wire [7:0] ID;
  output reg  PassAuthorized;
  output reg [3:0] IndexOutput;
  reg [7:0] authorized_passwords_ROM [0:9];
  reg [7:0] authorized_id_ROM [0:9];

  parameter OFF = 1'b0;
  parameter ON = 1'b1;
  // loading passwords rom
  //
  initial begin
    $readmemb("authorized_passwordsROM.mem", authorized_passwords_ROM);
    $readmemb("authorized_idROM.mem", authorized_id_ROM);
    end

  // finding out is the pass inputed is in ram
  //
  integer i;
  always @(Password or ID) begin
      PassAuthorized = OFF;
      for(i = 0 ; i<10 ; i = i+1)begin 
          if (ID == authorized_id_ROM[i]) begin
              IndexOutput = i;
          end
          if(Password == authorized_passwords_ROM[i] & ID == authorized_id_ROM[i])begin
              PassAuthorized = ON;
              IndexOutput = i;
          end
         
      end
  end
endmodule // PasswordAndIdChecker




module ATM(Clock, Reset, Password, ID,DestID, Control, Back, Eject, Request, ErrPass,
               ErrBalance, BalanceValue);
               
  input [0:0] Clock, Reset, Back, Eject;
  input [7:0] Password, ID, Request, DestID;
  input [2:0] Control; //
  output reg [0:0] ErrPass, ErrBalance;
  output reg [7:0] BalanceValue;
  
  parameter OFF = 1'b0;
  parameter ON = 1'b1;
  parameter X = 1'bx;
  
  parameter 
              IDLE          = 3'b000,
              CHECKPASS     = 3'b001,
              SHOWBALANCE   = 3'b010,
              WITHDRAW      = 3'b011,
              WITHDRAWSHOW  = 3'b100,
              TRANSFER      = 3'b101,
              DEPOSIT       = 3'b110;
  
  reg [2:0] State, NextState;
  reg [7:0] accounts_balance_ROM [0:9];
  initial begin
    $readmemb("accounts_balanceRAM.mem", accounts_balance_ROM);
  end
  
  wire [3:0] index;
  wire [3:0] destIndex;
  wire PassAuthorized;
  PasswordAndIdChecker SomeRandomName(Password,ID,index,PassAuthorized);
  PasswordAndIdChecker TransferIDChecker(8'b0,DestID,destIndex,);
  always @(posedge Clock or Reset) begin
    if (Reset)
      State = CHECKPASS;
    else
      State = NextState;
  end
  
  always @(State or Password or ID or Control or Back or Eject or Request or PassAuthorized) begin
    case (State)
      CHECKPASS: begin
        if (PassAuthorized == OFF) begin
          NextState = CHECKPASS;
          ErrPass = ON;
        end
        else if (PassAuthorized == ON) begin
          NextState = IDLE;
          ErrPass = OFF;
        end
        else begin
          NextState = CHECKPASS;
          ErrPass = X;
        end
      end
      IDLE:begin
        if (Eject)
          NextState = CHECKPASS;
        else
          case (Control) // control bit is states name
            SHOWBALANCE:
              NextState = SHOWBALANCE; 
            WITHDRAW:
              NextState = WITHDRAW;
            WITHDRAWSHOW:
              NextState = WITHDRAWSHOW;
            TRANSFER:
              NextState = TRANSFER;
            DEPOSIT:
              NextState = DEPOSIT; 
            default
              NextState = IDLE;
          endcase
      end
      SHOWBALANCE: begin
        if (Back) begin
          BalanceValue = 8'bxxxxxxxx;
          NextState = IDLE;
        end
        else if (Eject) begin
          BalanceValue = 8'bxxxxxxxx;
          NextState = CHECKPASS;
        end
        else
          BalanceValue = accounts_balance_ROM[index];
      end
      WITHDRAW: begin
          if (Back) begin
            ErrBalance = OFF;
            NextState = IDLE;
          end
          else if (Eject) begin
            ErrBalance = OFF;
            NextState = CHECKPASS;
          end
          else if (Request <= accounts_balance_ROM[index]) begin
            NextState = IDLE;
            ErrBalance = OFF;
            accounts_balance_ROM[index] = accounts_balance_ROM[index] - Request;
          end
          else if (Request > accounts_balance_ROM[index]) begin
            NextState = IDLE;
            ErrBalance = ON;
          end
          else begin
            ErrBalance = X;
            NextState = WITHDRAW;
          end
      end
      WITHDRAWSHOW: begin
          if (Back) begin
            ErrBalance = OFF;
            NextState = IDLE;
          end
          else if (Eject) begin
            ErrBalance = OFF;
            NextState = CHECKPASS;
          end
          else if (Request <= accounts_balance_ROM[index]) begin
            NextState = SHOWBALANCE;
            ErrBalance = OFF;
            accounts_balance_ROM[index] = accounts_balance_ROM[index] - Request;
          end
          else if (Request > accounts_balance_ROM[index]) begin
            NextState = SHOWBALANCE;
            ErrBalance = ON;
          end
          else begin
            ErrBalance = X;
            NextState = WITHDRAWSHOW;
          end
      end
      TRANSFER: begin
        if (Back) begin
            ErrBalance = OFF;
            NextState = IDLE;
        end
        else if (Eject) begin
            ErrBalance = OFF;
            NextState = CHECKPASS;
        end
        else if ((Request <= accounts_balance_ROM[index]) & (destIndex >= 4'b0000) & (destIndex <= 4'b1111)) begin
            NextState = SHOWBALANCE;
            ErrBalance = OFF;
            accounts_balance_ROM[destIndex] = accounts_balance_ROM[destIndex] + Request;
            accounts_balance_ROM[index] = accounts_balance_ROM[index] - Request;
        end
        else if (Request > accounts_balance_ROM[index]) begin
            NextState = SHOWBALANCE;
            ErrBalance = ON;
        end
        else begin
            ErrBalance = X;
            NextState = TRANSFER;
        end
      end
      DEPOSIT: begin
        if (Eject) begin
          NextState = CHECKPASS;
        end
        else if (Back) begin
          NextState = IDLE;
        end
        else if (Request >= 8'd0 & Request <= 8'b11111111) begin
          NextState = SHOWBALANCE;
          accounts_balance_ROM[index] = accounts_balance_ROM[index] + Request;
        end
        else
          NextState = DEPOSIT;
      end
    endcase 
  end

endmodule // ATM



module PasswordAndIdCheckerTESTBENCH();
  wire PassAuthorized;
  wire [3:0] IndexOutput;
  
  reg [7:0] ID;
  reg [7:0] Password;
  
  PasswordAndIdChecker somerandomname(Password,ID,IndexOutput,PassAuthorized);
  
  initial begin
    // no currect pass no currect id
    ID       = 8'b11110000;
    Password = 8'b10111011;
    #20
    // currect pass no currect id
    ID       = 8'b11110000;
    Password = 8'b10111101;
    #20
    // no currect pass currect id
    ID       = 8'b10111101;
    Password = 8'b11110000;
    #20
    // another no currect pass currect id
    ID       = 8'b10111110;
    Password = 8'b11110000;
    #20
    // currect pass currect id
    ID       = 8'b10111101;
    Password = 8'b10111000;
    #20
    // no currect pass no currect id
    ID       = 8'b10010000;
    Password = 8'b10111011;
    #20
    // another currect pass currect id
    ID       = 8'b11101000;
    Password = 8'b10110010;
    #20 
    $stop;
  end
    
endmodule // PasswordAndIdCheckerTESTBENCH




module ATMTESTBENCH();
  reg Clock, Reset, Back, Eject;
  reg [7:0] Password, ID, DestID, Request;
  reg [2:0] Control;
  wire ErrPass, ErrBalance;
  wire [7:0] BalanceValue;
  
  ATM somerandomname(Clock, Reset, Password, ID,DestID, Control, Back, Eject, Request, ErrPass,
               ErrBalance, BalanceValue);
  
  initial begin
    Clock = 1'b0;
    forever #5 Clock = ~Clock;
  end
  
  initial begin
    Reset = 1;
    
    repeat (1) @(negedge Clock);
    Reset = 0;
    
    repeat (1) @(negedge Clock);
    Password = 8'b11111100;//invalid
    ID = 8'b11111111;//invalid
    
    repeat (1) @(negedge Clock);
    Password = 8'b10101011;//valid
    ID = 8'b10101011;//valid
    
    repeat (1) @(negedge Clock);
    Control = 3'b010;
    
    repeat (1) @(negedge Clock);
    Back = 1'b1;
    Control = 3'b100;
    
    repeat (1) @(negedge Clock);
    Back = 1'b0;
    Request = 8'b11111111;//not possible
    
    repeat (1) @(negedge Clock);
    Request = 8'b00001110;
    
    repeat (1) @(negedge Clock);
    Back = 1'b1;
    Control = 3'bxxx;
    
    repeat (1) @(negedge Clock);
    Back = 1'b0;
    
    $stop;
  end

  
endmodule // ATMTESTBENCH