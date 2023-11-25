class ahbl_mst_mon extends uvm_monitor;
  `uvm_component_utils(ahbl_mst_mon)

  virtual ahbl_if vif;

  uvm_analysis_port #(ahbl_tran) ap;
  ahbl_tran                      pkt;

  function new(string name,uvm_component parent);
    super.new(name,parent);
    ap = new("ap",this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual ahbl_if)::get(this,"","vif",vif))
      `uvm_fatal("No vif","vif is not set!")
  endfunction

  virtual task run_phase(uvm_phase phase);
    while(1)begin
      @(vif.mon_cb)
      if(!vif.mon_cb.hresetn)begin  
        pkt = null;
      end
      else begin
        if(vif.mon_cb.hready)begin
          if(pkt != null)begin
            samp_dpha(pkt);
            ap.write(pkt);
            pkt = null;
          end

          if(vif.mon_cb.hsel & vif.mon_cb.htrans[1])begin
            samp_apha(pkt);
          end
        end
      end
    end
  endtask

  virtual task samp_dpha(ref ahbl_tran pkt);
    pkt.hrwdata = pkt.hwrite ? vif.mon_cb.hwdata : vif.mon_cb.hrdata;
    pkt.hresp = vif.mon_cb.hresp;
  endtask

  virtual task samp_apha(ref ahbl_tran pkt);
    pkt = ahbl_tran::type_id::create("pkt");

    pkt.hsel    = vif.mon_cb.hsel;
    pkt.haddr   = vif.mon_cb.haddr;
    pkt.htrans  = htrans_t'(vif.mon_cb.htrans);
    pkt.hsize   = hsize_t'(vif.mon_cb.hsize);
    pkt.hburst  = hburst_t'(vif.mon_cb.hburst);
    pkt.hprot   = vif.mon_cb.hprot;
    pkt.hwrite  = vif.mon_cb.hwrite;

  endtask
endclass
