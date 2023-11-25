class ahbl_mst_agt extends uvm_agent;
  `uvm_component_utils(ahbl_mst_agt)

  ahbl_mst_drv  drv_i;
  ahbl_mst_sqr  sqr_i;
  ahbl_mst_mon  mon_i;

  virtual ahbl_if vif;

  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual ahbl_if)::get(this,"","vif",vif))
      `uvm_fatal("No vif","vif is not set!")

    mon_i = ahbl_mst_mon::type_id::create("mon_i",this);
    uvm_config_db#(virtual ahbl_if)::set(this,"mon_i","vif",vif);

    if(!(uvm_config_db#(uvm_active_passive_enum)::get(this,"","is_active",is_active)))
      `uvm_fatal("is_active","is_active is not set!")

    if(is_active == UVM_ACTIVE)begin
      sqr_i = ahbl_mst_sqr::type_id::create("sqr_i",this);
      drv_i = ahbl_mst_drv::type_id::create("drv_i",this);
      uvm_config_db#(virtual ahbl_if)::set(this,"drv_i","vif",vif);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE)begin
      drv_i.seq_item_port.connect(sqr_i.seq_item_export);
    end
  endfunction
endclass
