`ifndef _APB_SLAVE_PKG_
`define _APB_SLVAE_PKG_

`include "apb_if.sv"
package apb_slv_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  typedef enum {READ,WRITE} kind_t;
  
  `include "apb_tran.sv"
  `include "apb_mem.sv"
  `include "apb_slv_drv.sv"
  `include "apb_slv_mon.sv"
  `include "apb_slv_sqr.sv"
  `include "apb_slv_agt.sv"
endpackage

`endif
