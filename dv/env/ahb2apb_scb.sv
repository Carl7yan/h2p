class ahb2apb_scb extends uvm_scoreboard;

  uvm_tlm_analysis_fifo #(apb_tran) apb_fifo;
  uvm_blocking_get_port #(apb_tran) apb_port;

  uvm_tlm_analysis_fifo #(ahbl_tran) ahb_fifo;
  uvm_blocking_get_port #(ahbl_tran) ahb_port;

  func_cov  fcov;
  `uvm_component_utils(ahb2apb_scb)

  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb_fifo = new("apb_fifo",this);
    apb_port = new("apb_port",this);
    ahb_fifo = new("ahb_fifo",this);
    ahb_port = new("ahb_port",this);
    fcov     = new("fcov");
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    apb_port.connect(apb_fifo.blocking_get_export);
    ahb_port.connect(ahb_fifo.blocking_get_export);
  endfunction

  virtual task run_phase(uvm_phase phase);
    check_pkt();
  endtask

  virtual task check_pkt();
    apb_tran  apb_pkt;
    ahbl_tran ahb_pkt;
    bit       err_flag;

    while(1)begin
      err_flag = 0;
      ahb_port.get(ahb_pkt);
      apb_port.get(apb_pkt);

      fcov.cg.sample(ahb_pkt,apb_pkt);

      if(ahb_pkt.haddr[15:2] != apb_pkt.addr[15:2])begin
        `uvm_error(get_type_name(),$sformatf("AHB-packet and APB-packet address mismatch! ahb-addr[15:2][%0h],apb-addr[15:2][0%h]",ahb_pkt.haddr[15:2],apb_pkt.addr[15:2]))
        err_flag = 1;
      end

      if(ahb_pkt.hrwdata != apb_pkt.data)begin
        `uvm_error(get_type_name(),$sformatf("AHB-packet and APB-packet rw-data mismatch! ahb-data[%0h],apb-data[0%h]",ahb_pkt.hrwdata,apb_pkt.data))
        err_flag = 1;
      end

      if(ahb_pkt.hwrite & (apb_pkt.kind == apb_slv_pkg::READ ))begin
        `uvm_error(get_type_name(),"AHB-packet and APB-packet read/write mismatch! ahb-'write',apb-'read'")
        err_flag = 1;
      end

      if(!ahb_pkt.hwrite & (apb_pkt.kind == apb_slv_pkg::WRITE ))begin
        `uvm_error(get_type_name(),"AHB-packet and APB-packet read/write mismatch! ahb-'read',apb-'write'")
        err_flag = 1;
      end

      if(apb_pkt.prot[0] != ahb_pkt.hprot[1])begin
        `uvm_error(get_type_name(),$sformatf("AHB-packet and APB-packet 'hprot[1]/prot[0]' mismatch! ahb:[%0d],apb:[%0d]",ahb_pkt.hprot[1],apb_pkt.prot[0]))
        err_flag = 1;
      end

      if(apb_pkt.prot[2] == ahb_pkt.hprot[0])begin
        `uvm_error(get_type_name(),$sformatf("AHB-packet and APB-packet 'hport[0]/prot[2]' mismatch! ahb:[%0d],apb:[%0d]",ahb_pkt.hprot[0],apb_pkt.prot[2]))
        err_flag = 1;
      end

      if(ahb_pkt.hwrite)begin
        if((ahb_pkt.hsize==WORD) & (apb_pkt.strb != 4'b1111))begin
          `uvm_error(get_type_name(),$sformatf("AHB-packet and APB-packet hsize/haddr/pstrb mismatch! ahb-hsize:WORD,apb-pstrb:%4b.",apb_pkt.strb))
          err_flag = 1;
        end
        if(((ahb_pkt.hsize==HWORD) & !ahb_pkt.haddr[1] & (apb_pkt.strb!=4'b0011)) | ((ahb_pkt.hsize==HWORD) & ahb_pkt.haddr[1] &(apb_pkt.strb != 4'b1100)))begin
           `uvm_error(get_type_name(),$sformatf("AHB-packet and APB-packet hsize/haddr/pstrb mismatch! ahb-hsize:HWORD,ahb-haddr[1]:%d,apb-pstrb:%4b.",ahb_pkt.haddr[1],apb_pkt.strb))
          err_flag = 1;
        end
        if(((ahb_pkt.hsize==BYTE) & (ahb_pkt.haddr[1:0]==2'b00) &(apb_pkt.strb != 4'b0001)) | ((ahb_pkt.hsize==BYTE) & (ahb_pkt.haddr[1:0]==2'b01) &(apb_pkt.strb != 4'b0010)) | ((ahb_pkt.hsize==BYTE) & (ahb_pkt.haddr[1:0]==2'b10) &(apb_pkt.strb != 4'b0100)) | ((ahb_pkt.hsize==BYTE) & (ahb_pkt.haddr[1:0]==2'b11) &(apb_pkt.strb != 4'b1000)))begin
          `uvm_error(get_type_name(),$sformatf("AHB-packet and APB-packet hsize/haddr/pstrb mismatch! ahb-hsize:BYTE,ahb-haddr[1:0]:%2b,apb-pstrb:%4b.",ahb_pkt.haddr[1:0],apb_pkt.strb))
          err_flag = 1;
        end
      end
      
      if(ahb_pkt.hresp != apb_pkt.slverr)begin
        `uvm_error(get_type_name(),$sformatf("AHB-packet and APB-packet hresp/pslverr mismatch! ahb:[%0d],apb:[%0d].",ahb_pkt.hresp,apb_pkt.slverr))
         err_flag = 1;
      end

      if(err_flag)begin
        `uvm_error(get_type_name(),"Pkt comparing FAILED!")
      end else begin
        `uvm_info(get_type_name(),"Pkt comparing correct!",UVM_LOW)
      end
      # 20ns;
    end
  endtask

endclass
