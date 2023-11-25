class func_cov extends uvm_object;
  
  covergroup cg with function sample(ahbl_tran ahb_pkt,apb_tran apb_pkt);
    option.per_instance = 1;
    haddr:coverpoint ahb_pkt.haddr[15:0] {bins a1    = {16'h0000};
                                          bins a2    = {16'h0001};
                                          bins a3    = {16'h0002};
                                          bins a4    = {16'h0003};
                                          bins a5    = {16'hffff};
                                          bins a6    = {16'hfffe};
                                          bins a7    = {16'hfffd};
                                          bins a8    = {16'hfffc};
                                          bins a9[4] = {[16'h0004:16'hfffb]};
                                          }
    hwrite:coverpoint ahb_pkt.hwrite;
    hburst:coverpoint ahb_pkt.hburst;
    hsize :coverpoint ahb_pkt.hsize;

    cross haddr,hwrite,hburst,hsize;
  endgroup
  
  function new(string name="func_cov");
    super.new(name);
    cg=new();
    cg.set_inst_name({get_full_name,".",name,".cg"});
  endfunction

endclass
