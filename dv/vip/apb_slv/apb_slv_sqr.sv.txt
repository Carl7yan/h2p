class apb_slv_sqr extends uvm_sequencer #(apb_tran);
  `uvm_component_utils(apb_slv_sqr)

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

endclass
