class ahbl_mst_basic_seq extends uvm_sequence#(ahbl_tran);
  `uvm_object_utils(ahbl_mst_basic_seq)

  function new(string name = "ahbl_mst_basic_seq");
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

class ahbl_mst_burst_seq extends ahbl_mst_basic_seq;
 
  function new(string name="ahbl_mst_burst_seq");
    super.new(name);
  endfunction

  `uvm_object_utils(ahbl_mst_burst_seq)

  virtual task body();
    `uvm_do_with(req,{hsel == 1'b1;
                      //htrans == ahbl_mst_pkg::NSEQ;
                     // hsize  == ahbl_mst_pkg::WORD;
                      //hburst == ahbl_mst_pkg::SINGLE;
                      //hwrite == 1'b1;
                      })
  endtask
endclass

class ahbl_mst_single_write32_seq extends ahbl_mst_basic_seq;
  
  function new(string name = "ahbl_mst_single_write32_seq");
    super.new(name);
  endfunction

  `uvm_object_utils(ahbl_mst_single_write32_seq)

  virtual task body();
    `uvm_do_with(req,{hsel   == 1'b1;
                      htrans == ahbl_mst_pkg::NSEQ;
                      hsize  == ahbl_mst_pkg::WORD;
                      hburst == ahbl_mst_pkg::SINGLE;
                      hwrite == 1'b1;})
  endtask
endclass


class ahbl_mst_single_read32_seq extends ahbl_mst_basic_seq;
  
  function new(string name="ahbl_mst_single_read32_seq");
    super.new(name);
  endfunction

  `uvm_object_utils(ahbl_mst_single_read32_seq)

  virtual task body();
    `uvm_do_with(req,{hsel   == 1'b1;
                      htrans == ahbl_mst_pkg::NSEQ;
                      hsize  == ahbl_mst_pkg::WORD;
                      hburst == ahbl_mst_pkg::SINGLE;
                      hwrite == 1'b0;})
  endtask
endclass
