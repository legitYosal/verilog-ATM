// usefss
// password checker


module AuthorizePass(Password,          // inputed password
                     Submit,           // if submit is on then password check
                     ID,               // id pass of the password for next actions
                     PassAuthorized);  // if password was in the rom

  input [3:0] Password;
  input Submit;
  output reg [3:0] ID;
  output reg  PassAuthorized;
  reg [9:0] authorized_passwords_ROM [0:3];

  parameter OFF = 1'b0;
  parameter ON = 1'b1;
  // loading passwords rom
  //
  initial begin
    $readmemb("authorized_passwordsROM", authorized_passwords_ROM);
    end

  // finding out is the pass inputed is in ram
  //
  always @(posedge Submit or Password) begin
    PassAuthorized = OFF;
    if (Submit)
      case (Password)
        authorized_passwords_ROM[0]: begin
          PassAuthorized = ON;
          ID = 4'd0;
          end
        authorized_passwords_ROM[1]: begin
          PassAuthorized = ON;
          ID = 4'd1;
          end
        authorized_passwords_ROM[2]: begin
          PassAuthorized = ON;
          ID = 4'd2;
          end
        authorized_passwords_ROM[3]: begin
          PassAuthorized = ON;
          ID = 4'd3;
          end
        authorized_passwords_ROM[4]: begin
          PassAuthorized = ON;
          ID = 4'd4;
          end
        authorized_passwords_ROM[5]: begin
          PassAuthorized = ON;
          ID = 4'd5;
          end
        authorized_passwords_ROM[6]: begin
          PassAuthorized = ON;
          ID = 4'd6;
          end
        authorized_passwords_ROM[7]: begin
          PassAuthorized = ON;
          ID = 4'd7;
          end
        authorized_passwords_ROM[8]: begin
          PassAuthorized = ON;
          ID = 4'd8;
          end
        authorized_passwords_ROM[9]: begin
          PassAuthorized = ON;
          ID = 4'd9;
          end
        endcase
    end
  endmodule // AuthorizePass module
