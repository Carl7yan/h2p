interface apb_if(input pclk,input presetn);

  logic         psel;
  logic         penable;
  logic         pwrite;
  logic [3:0]   pstrb;
  logic [31:0]  paddr;
  logic [31:0]  pwdata;
  logic [2:0]   pprot;
  logic [31:0]  prdata;
  logic         pready;
  logic         pslverr;

  clocking slv_cb @(posedge pclk);
    input presetn;

    input  psel;  
    input  penable;  
    input  pwrite;  
    input  pstrb;  
    input  paddr;  
    input  pwdata;
    input  pprot;
    output prdata;
    output pready;
    output pslverr; 

  endclocking

  clocking mon_cb @(posedge pclk);
    input presetn;

    input  psel;  
    input  penable;  
    input  pwrite;  
    input  pstrb;  
    input  paddr;  
    input  pwdata;
    input  pprot;
    input  prdata;
    input  pready;
    input  pslverr; 

  endclocking
endinterface
