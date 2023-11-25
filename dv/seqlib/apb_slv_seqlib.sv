class apb_slv_basic_seq extends uvm_sequence#(apb_tran);
  `uvm_object_utils(apb_slv_basic_seq)

  function new(string name = "apb_slv_basic_seq");
    super.new(name);
  endfunction

  virtual task pre_body();
    if(starting_phase != null)begin
      starting_phase.raise_objection(this);
    end
  endtask

  virtual task post_body();
    if(starting_phase != null)begin
      starting_phase.drop_objection(this);
    end
  endtask
endclass

class apb_slv_rdy_seq extends apb_slv_basic_seq;
   
   function new(string name = "apb_slv_rdy_seq");
     super.new(name);
   endfunction

   `uvm_object_utils(apb_slv_rdy_seq)

   virtual task body();
     `uvm_do_with(req,{slverr     == 1'b0;
                       nready_num == 0;})
   endtask
endclass

class apb_slv_nrdy_seq extends apb_slv_basic_seq;

  function new(string name="apb_slv_nrdy_seq");
    super.new(name);
  endfunction

  `uvm_object_utils(apb_slv_nrdy_seq)

  virtual task body();
    `uvm_do_with(req,{slverr == 1'b0;
                      nready_num inside {[1:5]};})
  endtask
endclass

class apb_slv_slverr_seq extends apb_slv_basic_seq;
  
  function new(string name = "apb_slv_slverr_seq");
    super.new(name);
  endfunction

  `uvm_object_utils(apb_slv_slverr_seq)

  virtual task body();
    `uvm_do_with(req,{slverr == 1'b1;
                      nready_num inside {[1:5]};})
  endtask
endclass
