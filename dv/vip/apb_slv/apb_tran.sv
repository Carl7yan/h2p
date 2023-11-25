class apb_tran extends uvm_sequence_item;

  rand logic [31:0]   addr;
  rand logic [31:0]   data;
  rand logic [2:0]    prot;
  rand kind_t         kind; // write or read
  rand logic [3:0]    strb;
  rand bit            slverr;
  rand int  unsigned  nready_num;


  `uvm_object_utils_begin(apb_tran)
    `uvm_field_int(addr,UVM_DEFAULT)    
    `uvm_field_int(data,UVM_DEFAULT)    
    `uvm_field_int(prot,UVM_DEFAULT)    
    `uvm_field_int(strb,UVM_DEFAULT)    
    `uvm_field_enum(kind_t,kind,UVM_DEFAULT)    
    `uvm_field_int(slverr,UVM_DEFAULT)    
    `uvm_field_int(nready_num,UVM_DEFAULT)    
  `uvm_object_utils_end

  function new(string name = "apb_tran");
    super.new(name);
  endfunction

endclass
