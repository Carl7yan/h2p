class apb_slv_agt extends uvm_agent;

  `uvm_component_utils(apb_slv_agt)

  apb_slv_sqr sqr_i;
  apb_slv_drv drv_i;
  apb_slv_mon mon_i;

  virtual apb_if vif;

  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
      `uvm_fatal("no vif","vif is not set!")

    mon_i = apb_slv_mon::type_id::create("mon_i",this);
    uvm_config_db#(virtual apb_if)::set(this,"mon_i","vif",vif);

    void'(uvm_config_db#(uvm_active_passive_enum)::get(this,"","is_active",is_active));

    if(is_active == UVM_ACTIVE)begin
      sqr_i = apb_slv_sqr::type_id::create("sqr_i",this);
      drv_i = apb_slv_drv::type_id::create("drv_i",this);
      uvm_config_db#(virtual apb_if)::set(this,"drv_i","vif",vif);
    end

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE)begin
      drv_i.seq_item_port.connect(sqr_i.seq_item_export);
    end
  endfunction

endclass
