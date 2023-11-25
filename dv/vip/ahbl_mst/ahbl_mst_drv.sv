class ahbl_mst_drv extends uvm_driver #(ahbl_tran);
  `uvm_component_utils(ahbl_mst_drv)

  virtual ahbl_if vif;

  protected ahbl_tran pkt_dpha = null;
  protected ahbl_tran pkt_apha = null;

  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual ahbl_if)::get(this,"","vif",vif))
      `uvm_fatal("No vif","vif is not set")
  endfunction
  
  task run_phase(uvm_phase phase);
    while(1) begin
      @(vif.mst_cb);
      if(!vif.mst_cb.hresetn)begin
        vif.mst_cb.hsel   <= 1'b0;
        vif.mst_cb.haddr  <= 32'b0;
        vif.mst_cb.htrans <= 2'b0;
        vif.mst_cb.hsize  <= 3'b0;
        vif.mst_cb.hburst <= 3'b0;
        vif.mst_cb.hprot  <= 4'b0;
        vif.mst_cb.hwrite <= 1'b0;
        vif.mst_cb.hwdata <= 32'b0;
      end
      else begin
        if(pkt_dpha != null)begin
          drive_1cyc_pkt_dpha(pkt_dpha);
          if(vif.mst_cb.hready & ((pkt_dpha.hburst == SINGLE) | pkt_dpha.last_beat()))begin
            seq_item_port.item_done();
            pkt_apha = null;
            pkt_dpha = null;
          end
        end
        
        if(pkt_apha != null)begin
          drive_1cyc_pkt_apha(pkt_apha);
        end
        else begin
          seq_item_port.try_next_item(pkt_apha);
          if(pkt_apha != null)begin
            drive_1cyc_pkt_apha(pkt_apha);
            pkt_apha.print();
          end
          else begin
            drive_1cyc_idle();
          end
        end
      end
    end
  endtask

  task drive_1cyc_pkt_dpha(ref ahbl_tran pkt);
    if(vif.mst_cb.hready)begin
      vif.mst_cb.hwdata <= pkt.hwrite ? pkt.nxt_hrwdata():32'd0;
    end
  endtask

  task drive_1cyc_pkt_apha(ref ahbl_tran pkt);
    if(vif.mst_cb.hready)begin
      vif.mst_cb.hsel   <= pkt.hsel;
      vif.mst_cb.haddr  <= ((pkt.htrans != IDLE) & (pkt.htrans != BUSY))?pkt.nxt_haddr() : vif.haddr;
      vif.mst_cb.htrans <= pkt.nxt_htrans();
      vif.mst_cb.hsize  <= pkt.hsize;
      vif.mst_cb.hburst <= pkt.hburst; 
      vif.mst_cb.hprot  <= pkt.hprot; 
      vif.mst_cb.hwrite <= pkt.hwrite;
      this.pkt_dpha = this.pkt_apha; 
    end
  endtask

  task drive_1cyc_idle();
    vif.mst_cb.hsel   <= 1'b0;
    vif.mst_cb.haddr  <= 32'd0;
    vif.mst_cb.htrans <= IDLE;
    vif.mst_cb.hsize  <= BYTE;
    vif.mst_cb.hburst <= SINGLE;
    vif.mst_cb.hprot  <= 4'h0;
    vif.mst_cb.hwrite <= 1'b0;
  endtask

endclass
