//Monitor Class
class monitor;
  transaction tr;
  mailbox #(bit [11:0]) mbx;  // scoreboard
  bit [11:0] srx; // Received data
 
  virtual spi_if vif;
 
  // Constructor
  function new(mailbox #(bit [11:0]) mbx);
    this.mbx = mbx;
  endfunction
 
  // Task to monitor the bus
  task run();
    forever begin
      @(posedge vif.sclk);
      wait(vif.cs == 1'b0); // Start of transaction
      @(posedge vif.sclk);
 
      for (int i = 0; i <= 11; i++) begin
        @(posedge vif.sclk);
        srx[i] = vif.mosi;   // storing all the serial data in srx to compare in scoreboard
      end
 
      wait(vif.cs == 1'b1); // End of transaction
 
      $display("[MON] : DATA SENT : %0h", srx);
      mbx.put(srx);  // scoreboard
    end
  endtask
 
endclass
 