import ahb2apb_pkg::*;

class ahb2apb_base_test extends uvm_test;
  `uvm_component_utils(ahb2apb_base_test)

  virtual reset_if reset_if_i;
  ahb2apb_env env_i;

  function new(string name,uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_i=ahb2apb_env::type_id::create("env_i",this);

    uvm_config_db#(uvm_active_passive_enum)::set(this,"env_i.ahbl_mst_agt_i","is_active",UVM_ACTIVE);
    if(!uvm_config_db#(virtual reset_if)::get(this,"","vif",reset_if_i))
      `uvm_fatal("No reset_if","reset_if_i is not set!")
  endfunction

  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);

    uvm_top.print_topology();
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    reset_if_i.reset_dut;

    phase.phase_done.set_drain_time(this,5us);
  endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if(num_uvm_errors==0)begin
      `uvm_info(get_type_name(),"Simulation PASSED!",UVM_NONE)
    end
    else begin
      `uvm_info(get_type_name(),"SImulation FAILED!",UVM_NONE)
    end
  endfunction
 
  function int num_uvm_errors();
    uvm_report_server server;
    if(server==null) server = get_report_server();
    return server.get_severity_count(UVM_ERROR);
  endfunction
endclass
