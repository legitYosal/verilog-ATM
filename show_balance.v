// usefss
// showing account balance every time showbalance bit is on

module BalanceView(ID,             // id of person who register
                   ShowBalance,    // bit on out put must be exact true
                   BalanceValue);  // specific id account balance

  input [3:0] ID;
  input ShowBalance;
  output [4:0] BalanceView;
  reg [9:0] accounts_balance_RAM [0:4];

  // inputing .mem file
  //
  initial begin
    $readmemb("accounts_balanceRAM.mem", accounts_balance_RAM);
    end
  always @(ShowBalance) begin
    if (ShowBalance)
      BalanceValue = accounts_balance_RAM[ID];
    else
      BalanceValue = 5'bxxxxx;
    end
  endmodule
