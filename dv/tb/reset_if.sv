interface reset_if(input clk);
  logic reset;

  task reset_dut;
  begin
    reset = 1'b0;
    #5ns; 
    reset = 1'b1; // async reset
    repeat (100) @(negedge clk);
    #2ns;
    reset = 1'b0; // sync DEreset
  end
  endtask
endinterface
