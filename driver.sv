`include "interface.sv"
//Driver Class 
 
class driver;
  
  virtual spi_if vif;
  transaction tr;
  mailbox #(transaction) mbx;  // receive data from generator
  mailbox #(bit [11:0]) mbxds;  // send to scoreboard
  event drvnext;  // to check if driver completed task
  
  bit [11:0] din;
 
  // Constructor
  function new(mailbox #(bit [11:0]) mbxds, mailbox #(transaction) mbx);
    this.mbx = mbx;
    this.mbxds = mbxds;
  endfunction
  
  // Task to reset the driver
  task reset();
     vif.rst <= 1'b1;
     vif.cs <= 1'b1;
     vif.newd <= 1'b0;
     vif.din <= 1'b0;
     vif.mosi <= 1'b0;
    repeat(50) @(posedge vif.clk);  // reset high for 10 clocks
      vif.rst <= 1'b0; 
    repeat(5) @(posedge vif.clk);
 
    $display("[DRV] : RESET DONE");
    $display("-----------------------------------------");
  endtask
  
  // Task to drive transactions
  task run();
    forever begin
      mbx.get(tr);  // from generator
      @(posedge vif.sclk);
      vif.newd <= 1'b1;
      vif.din <= tr.din;
      mbxds.put(tr.din);  // to scoreboard
      @(posedge vif.sclk);
      vif.newd <= 1'b0;
      wait(vif.cs == 1'b1);
      $display("[DRV] : DATA SENT TO MOSI : %0h",tr.din);
      ->drvnext;   // completed task by driver
  end
  endtask
  
endclass