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
           
           if (Password != authorized_passwords_ROM[i] & ID == authorized_id_ROM[i]) begin
              PassAuthorized = OFF;
              IndexOutput = i;
          end
          else if(Password == authorized_passwords_ROM[i] & ID == authorized_id_ROM[i])begin
              PassAuthorized = ON;
              IndexOutput = i;
          end
         
      end
  end
endmodule // PasswordAndIdChecker



module ATM(Clock, Reset, Password, ID,DestID, Control, Back, Eject, Request, ErrPass,
               ErrBalance, ErrID, ErrTransf, BalanceValue);
               
  input [0:0] Clock, Reset, Back, Eject;
  input [7:0] Password, ID, Request, DestID;
  input [2:0] Control; //
  output reg [0:0] ErrPass, ErrBalance, ErrID, ErrTransf;
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
              wwwwwwww      = 3'b110;
  
  reg [2:0] State, NextState;
  reg [7:0] accounts_balance_ROM [0:9];
  initial begin
    $readmemb("accounts_balanceRAM.mem", accounts_balance_ROM);
  end
  
  wire [3:0] index;
  wire [3:0] destIndex;
  wire PassAuthorized;
  PasswordAndIdChecker SomeRandomName(Password,ID,index,PassAuthorized);
  PasswordAndIdChecker TransferIDChecker(00000000,DestID,destIndex,);
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
          $display("Next state must change");
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
            wwwwwwww:
              NextState = wwwwwwww; 
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
            $display("%b is beforre reduce", accounts_balance_ROM[index]);
            accounts_balance_ROM[index] = accounts_balance_ROM[index] - Request;
            $display("%b is reduce", accounts_balance_ROM[index]);
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
            ErrTransf = OFF;
            NextState = IDLE;
        end
        else if (Eject) begin
            ErrTransf = OFF;
            NextState = CHECKPASS;
          end
        else if (Request <= accounts_balance_ROM[index]) begin
            NextState = SHOWBALANCE;
            ErrBalance = OFF;
            ErrTransf = OFF;
            accounts_balance_ROM[destIndex] = accounts_balance_ROM[index] + Request;
            accounts_balance_ROM[index] = accounts_balance_ROM[index] - Request;
          end
          else if (Request > accounts_balance_ROM[index]) begin
            NextState = SHOWBALANCE;
            ErrBalance = ON;
            ErrTransf = ON;
          end
          else begin
            ErrBalance = X;
            ErrTransf = X;
            NextState = TRANSFER;
          end
      end
    endcase 
  end

endmodule // ATM
      
  