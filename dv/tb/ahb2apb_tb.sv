`include "uvm_macros.svh"
import uvm_pkg::*;
import ahbl_mst_pkg::*;
import apb_slv_pkg::*;

module ahb2apb_tb();

parameter HCLK_PERIOD = 100ns;//10MHz
bit[1:0] tmp_var;
int HCLK_PCLK_RATIO;
initial begin
  tmp_var = $urandom_range(0,3);
  case(tmp_var)
    0:HCLK_PCLK_RATIO = 1;
    1:HCLK_PCLK_RATIO = 2;
    2:HCLK_PCLK_RATIO = 4;
    3:HCLK_PCLK_RATIO = 8;
  endcase
end

reg       hclk;
wire      hresetn;

wire      pclk;
wire      presetn;
reg [3:0] hclk_cnt;
reg       pclken;
wire      apbactive;

ahbl_if   ahbl_if_i(hclk,hresetn);
apb_if    apb_if_i(pclk,presetn);
reset_if  reset_if_i(hclk);

initial begin
  hclk = 1'b0;

  forever begin
    #(HCLK_PERIOD/2);
    hclk = !hclk;
  end
end

assign hresetn = !reset_if_i.reset;

always @(posedge hclk or negedge hresetn)
  if(!hresetn)
    hclk_cnt <= 4'd0;
  else if(hclk_cnt == (HCLK_PCLK_RATIO - 1'b1))
    hclk_cnt <= 4'd0;
  else
    hclk_cnt <= hclk_cnt + 1'd1;

always @(negedge hclk or negedge hresetn)
  if(!hresetn)
    pclken  <= 1'b0;
  else if(hclk_cnt == (HCLK_PCLK_RATIO - 1'b1))
    pclken  <= 1'b1;
  else
    pclken  <= 1'b0;

reg pclken_r;
always @(*)begin
  #1ns;
  pclken_r = pclken;
end

assign pclk    = pclken_r & hclk;
assign presetn = hresetn;

cmsdk_ahb_to_apb #(
    .ADDRWIDTH      (16),
    .REGISTER_RDATA (1),
    .REGISTER_WDATA (0)) dut(
    .HCLK           (hclk),
    .HRESETn        (hresetn),
    .PCLKEN         (pclken),

    .HSEL           (ahbl_if_i.hsel),
    .HADDR          (ahbl_if_i.haddr[15:0]),
    .HTRANS         (ahbl_if_i.htrans),
    .HSIZE          (ahbl_if_i.hsize),
    .HPROT          (ahbl_if_i.hprot),
    .HWRITE         (ahbl_if_i.hwrite),
    .HREADY         (ahbl_if_i.hready),
    .HWDATA         (ahbl_if_i.hwdata),

    .HREADYOUT      (ahbl_if_i.hready),
    .HRDATA         (ahbl_if_i.hrdata),
    .HRESP          (ahbl_if_i.hresp),

    .PADDR          (apb_if_i.paddr[15:0]),
    .PENABLE        (apb_if_i.penable),
    .PWRITE         (apb_if_i.pwrite),
    .PSTRB          (apb_if_i.pstrb),
    .PPROT          (apb_if_i.pprot),
    .PWDATA         (apb_if_i.pwdata),
    .PSEL           (apb_if_i.psel),
    .PRDATA         (apb_if_i.prdata),
    .PREADY         (apb_if_i.pready),
    .PSLVERR        (apb_if_i.pslverr),

    .APBACTIVE      (apbactive)
    );

  assign apb_if_i.paddr[31:16] = 16'd0;

  initial begin
    uvm_config_db#(virtual apb_if)::set(null,"uvm_test_top.env_i.apb_slv_agt_i","vif",apb_if_i);
    uvm_config_db#(virtual ahbl_if)::set(null,"uvm_test_top.env_i.ahbl_mst_agt_i","vif",ahbl_if_i);
    uvm_config_db#(virtual reset_if)::set(null,"uvm_test_top","vif",reset_if_i);
    run_test();
  end 
  
  property p_psel_high_then_apbactive_high;
    @(posedge pclk) disable iff(!hresetn)
    apb_if_i.psel |-> apbactive;
  endproperty

  property p_apbactive_high_then_psel_high;
    @(posedge pclk) disable iff(!hresetn)
    $rose(apbactive) |=> apb_if_i.psel;
  endproperty

  property p_hresp_hready;
    @(posedge hclk) disable iff(!hresetn)
    ahbl_if_i.hresp |-> ahbl_if_i.hready && !$past(ahbl_if_i.hready);
  endproperty

  a_psel_high_then_apbactive_high: assert property(p_psel_high_then_apbactive_high);
  a_apbactive_high_then_psel_high: assert property(p_apbactive_high_then_psel_high);
  a_hresp_hready                 : assert property(p_hresp_hready);

  covergroup cg_clk_ratio();
    option.per_instance = 1;
    option.name = "cg_clk_ratio";

    clk_ratio:coverpoint HCLK_PCLK_RATIO;
  endgroup

  cg_clk_ratio cg_clk_ratio_i = new();

  always @(posedge hresetn)begin
    cg_clk_ratio_i.sample();
  end

  initial begin
    reg [511:0] WAVE_FILENAME;
    if($test$plusargs("DUMP_VPD")) begin
      if($value$plusargs("VPD_FILENAME=%s",WAVE_FILENAME)) begin
        $vcdplusfile(WAVE_FILENAME);
        $vcdpluson();
      end
    end
  end

endmodule
