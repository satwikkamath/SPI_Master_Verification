`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

//Environment Class
 
class environment;
 
    generator gen;
    driver drv;
    monitor mon;
    scoreboard sco;
 
    event nextgd; // gen -> drv
    event nextgs; // gen -> sco
 
    mailbox #(transaction) mbxgd; // gen - drv
    mailbox #(bit [11:0]) mbxds; // drv - mon
    mailbox #(bit [11:0]) mbxms; // mon - sco
 
    virtual spi_if vif;
 
  // Constructor
  function new(virtual spi_if vif);
    mbxgd = new();
    mbxms = new();
    mbxds = new();
    gen = new(mbxgd);
    drv = new(mbxds, mbxgd);
 
    mon = new(mbxms);
    sco = new(mbxds, mbxms);
 
    this.vif = vif;
    drv.vif = this.vif;
    mon.vif = this.vif;
 
    gen.sconext = nextgs;
    sco.sconext = nextgs;
 
    gen.drvnext = nextgd;
    drv.drvnext = nextgd;
  endfunction
 
  // Task to perform reset actions
  task pre_test();
    drv.reset();
  endtask
 
  // Task to run the test
  task test();
  fork
    gen.run();
    drv.run();
    mon.run();
    sco.run();
  join_any
  endtask
 
  // Task to perform post-test actions
  task post_test();
    wait(gen.done.triggered);
    $finish();
  endtask
 
  // Task to start the test environment
  task run();
    pre_test();
    test();
    post_test();
  endtask
endclass
 