class ahb2apb_env extends uvm_env;
  `uvm_component_utils(ahb2apb_env)

  apb_slv_agt   apb_slv_agt_i;
  ahbl_mst_agt  ahbl_mst_agt_i;

  ahb2apb_scb   ahb2apb_scb_i;

  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    apb_slv_agt_i = apb_slv_agt::type_id::create("apb_slv_agt_i",this);
    ahbl_mst_agt_i = ahbl_mst_agt::type_id::create("ahbl_mst_agt_i",this);
    ahb2apb_scb_i = ahb2apb_scb::type_id::create("ahb2apb_scb_i",this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    apb_slv_agt_i.mon_i.ap.connect(ahb2apb_scb_i.apb_fifo.analysis_export);
    ahbl_mst_agt_i.mon_i.ap.connect(ahb2apb_scb_i.ahb_fifo.analysis_export);
  endfunction

endclass
