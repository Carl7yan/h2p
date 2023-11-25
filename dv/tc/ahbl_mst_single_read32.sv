class ahbl_mst_single_read32 extends ahb2apb_base_test;
  
  ahbl_mst_single_read32_seq  ahbl_mst_seq_i;
  apb_slv_rdy_seq   apb_slv_seq_i;

  `uvm_component_utils(ahbl_mst_single_read32)

  function new(string name,uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ahbl_mst_seq_i = ahbl_mst_single_read32_seq::type_id::create("ahbl_mst_seq_i",this);
    apb_slv_seq_i = apb_slv_rdy_seq::type_id::create("apb_slv_seq_i",this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    super.run_phase(phase);

    #100us;
    ahbl_mst_seq_i.start(env_i.ahbl_mst_agt_i.sqr_i);
    apb_slv_seq_i.start(env_i.apb_slv_agt_i.sqr_i);

    phase.drop_objection(this);
  endtask
endclass
