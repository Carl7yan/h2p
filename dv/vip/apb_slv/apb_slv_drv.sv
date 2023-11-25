class apb_slv_drv extends uvm_driver#(apb_tran);

  `uvm_component_utils(apb_slv_drv)

  virtual apb_if  vif;
  apb_mem#(32,32) mem;
  apb_tran        pkt;

  function new(string name = "apb_slv_drv",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    pkt = apb_tran::type_id::create("pkt",this);
    mem = apb_mem#(32,32)::type_id::create("apb_mem",this);
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))begin
      `uvm_fatal("NO VIF","vif is not found");
    end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    vif.slv_cb.pready  <= 1'b1;
    vif.slv_cb.pslverr <= 1'b0;
    vif.slv_cb.prdata  <= 1'bx; // not essential

    while(1)begin
      @(vif.slv_cb);
      if(!vif.slv_cb.penable & vif.slv_cb.psel)begin
        seq_item_port.get_next_item(pkt);
        drive_one_pkt(pkt);
        seq_item_port.item_done(pkt);
      end
    end
  endtask

  virtual task drive_one_pkt(apb_tran pkt);
    int nready_cnt;
    nready_cnt = pkt.nready_num;
    while(nready_cnt != 0)begin
      vif.slv_cb.pready <= 1'b0;
      nready_cnt--;
      @(vif.slv_cb);
    end
    vif.slv_cb.pready <= 1'b1;
    vif.slv_cb.pslverr<= pkt.slverr; // apb slave's error

    if(vif.slv_cb.pwrite)
      drive_wr_pkt(pkt);
    else
      drive_rd_pkt(pkt);
  endtask
  
  virtual task drive_wr_pkt(apb_tran pkt);
    if(!pkt.slverr)begin
      mem.put_data(vif.slv_cb.paddr,vif.slv_cb.pwdata);
    end
  endtask

  virtual task drive_rd_pkt(apb_tran pkt);
    if(!pkt.slverr)begin
      vif.slv_cb.prdata <= mem.get_data(vif.slv_cb.paddr);
    end
    else begin
      vif.slv_cb.prdata <= pkt.data; // put pkt.data back if error
    end
  endtask

endclass
