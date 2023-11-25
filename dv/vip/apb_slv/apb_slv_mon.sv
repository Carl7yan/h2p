class apb_slv_mon extends uvm_monitor;
  `uvm_component_utils(apb_slv_mon)
  virtual apb_if vif;
  uvm_analysis_port #(apb_tran) ap;

  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))begin
      `uvm_fatal("No vif","vif is not found")
    end
    ap=new("ap",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_tran pkt;
    while(1)begin
      @(vif.mon_cb);
      if(vif.mon_cb.penable & vif.mon_cb.pready &vif.mon_cb.psel & vif.mon_cb.presetn)begin
        pkt = apb_tran::type_id::create("pkt",this);
        pkt.addr = vif.mon_cb.paddr;
        pkt.prot = vif.mon_cb.pprot;
        pkt.slverr = vif.mon_cb.pslverr;
        pkt.kind = vif.mon_cb.pwrite ? WRITE:READ;
        pkt.data = vif.mon_cb.pwrite ? vif.mon_cb.pwdata : vif.mon_cb.prdata;
        ap.write(pkt);
      end
    end
  endtask
endclass
