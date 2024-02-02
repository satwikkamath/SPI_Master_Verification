 module spi(
input clk, newd,rst,
input [11:0] din, 
output reg sclk,cs,mosi
    );
  
  typedef enum bit  {
    idle = 0, 

    send = 1

    } state_type;
  state_type state = idle;  // default value
  
  int countc = 0;   // no. of clk cycles
  int count = 0;    // no. of bits
 
// sclk generation 
// Fsclk = Fclk/20

 always@(posedge clk)
  begin
    if(rst == 1'b1) begin
      countc <= 0;
      sclk <= 1'b0;
      cs <= 1'b1;   // default value of cs
      mosi <= 1'b0;
    end
    else begin 
      if(countc < 10 )  // first 10 clk cycles, sclk will be low. then next 10 clk cycles, sclk will be high.
          countc <= countc + 1;
      else
          begin
          countc <= 0;
          sclk <= ~sclk;
          end
    end
  end
  
    //state machine
    reg [11:0] temp;  // temporary variable
    
    
  always@(posedge sclk)
  begin
    if(rst == 1'b1) 
    begin
      cs <= 1'b1;   // default value of cs
      mosi <= 1'b0;  // default value of mosi
    end 
    else 
    begin
     case(state)
         idle:
             begin
               if(newd == 1'b1) 
               begin
                 state <= send;
                 temp <= din; 
                 cs <= 1'b0;
               end
               else 
               begin
                 state <= idle;
                 temp <= 8'h00;
               end
             end
       
       
       send : 
       begin
         if(count <= 11) 
         begin
           mosi <= temp[count]; // sending data serially
           count <= count + 1;
         end
         else
             begin
               count <= 0;
               state <= idle;
               cs <= 1'b1;
               mosi <= 1'b0;
             end
       end
       
                
      default : state <= idle; 
       
   endcase
  end 
 end
  
endmodule

