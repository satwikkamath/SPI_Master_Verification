`include "transaction.sv"
//Generator Class
class generator;
  
  transaction tr;
  mailbox #(transaction) mbx; // transmit data to driver
  int count = 0;

  event done; // to check if stimuli generation is completed
  event drvnext; //to check if driver completed the process
  event sconext; //to check if scoreboard completed the process
  
  // Constructor
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
    tr = new();
  endfunction
  
  // Task to generate transactions
  task run();
    repeat(count) begin
      assert(tr.randomize) else $error("[GEN] :Randomization Failed");
      mbx.put(tr.copy);  //send to driver with the help of mailbox
      tr.display("GEN");
      @(drvnext); // wait till driver completes its operation
      @(sconext); // wait till scoreboard completes its operation
    end 
    -> done;  // to stop simulation
  endtask
  
endclass
 