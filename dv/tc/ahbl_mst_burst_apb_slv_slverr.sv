class ahbl_mst_burst_apb_slv_slverr extends ahb2apb_base_test;
  
  ahbl_mst_burst_seq ahbl_mst_seq_i;
  apb_slv_slverr_seq apb_slv_seq_i;

  `uvm_component_utils(ahbl_mst_burst_apb_slv_slverr)

  function new(string name,uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ahbl_mst_seq_i = ahbl_mst_burst_seq::type_id::create("ahbl_mst_seq_i",this);
    apb_slv_seq_i = apb_slv_slverr_seq::type_id::create("apb_slv_seq_i",this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    int num_apb_seq;
    phase.raise_objection(this);
    super.run_phase(phase);

    #100us;
    fork
      begin
        ahbl_mst_seq_i.start(env_i.ahbl_mst_agt_i.sqr_i);
      end
      begin
        num_apb_seq = 0;
        while(1)begin
          apb_slv_seq_i.start(env_i.apb_slv_agt_i.sqr_i);
          num_apb_seq++;
          if(num_apb_seq >= ahbl_mst_seq_i.req.get_bst_beats())begin
            break;
          end
        end
      end
    join
    phase.drop_objection(this);
  endtask

endclass
