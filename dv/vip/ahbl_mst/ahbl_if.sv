interface ahbl_if(input hclk,input hresetn);
  logic         hsel;
  logic [31:0]  haddr;
  logic [ 1:0]  htrans;
  logic [ 2:0]  hsize; 
  logic [ 2:0]  hburst;   
  logic [ 3:0]  hprot;
  logic         hwrite;
  logic [31:0]  hwdata;

  logic [31:0]  hrdata;
  logic         hready;
  logic         hresp;

  clocking mst_cb @(posedge hclk);
    input   hresetn;

    output  hsel;
    output  htrans;
    output  haddr;
    output  hburst;
    output  hprot;
    output  hsize;
    output  hwdata;
    output  hwrite;

    input   hrdata;
    input   hready;
    input   hresp;
  endclocking

  clocking mon_cb @(posedge hclk);
    input   hresetn;

    input   hsel;
    input   htrans;
    input   haddr;
    input   hburst;
    input   hprot;
    input   hsize;
    input   hwdata;
    input   hwrite;

    input   hrdata;
    input   hready;
    input   hresp;
  endclocking

endinterface
