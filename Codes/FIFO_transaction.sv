package FIFO_transaction_pkg;

class FIFO_transaction;
  parameter FIFO_WIDTH = 8;
  bit clk;
  rand logic rst_n;
  rand logic wr_en;
  rand logic rd_en;
  rand logic [FIFO_WIDTH-1:0] data_in;
  logic [FIFO_WIDTH-1:0] data_out;
  logic full;
  logic empty;
  logic almostfull;
  logic almostempty;
  logic wr_ack;
  logic overflow;
  logic underflow;

  integer RD_EN_ON_DIST;
  integer WR_EN_ON_DIST;

  function new(integer RD_EN_ON_DIST = 30, integer WR_EN_ON_DIST = 70);
    this.RD_EN_ON_DIST = RD_EN_ON_DIST;
    this.WR_EN_ON_DIST = WR_EN_ON_DIST;
  endfunction : new

  constraint reset_c { rst_n dist{0:=10, 1:=90};}
  constraint wr_en_c { wr_en dist{0:=100-WR_EN_ON_DIST, 1:=WR_EN_ON_DIST};}
  constraint rd_en_c { rd_en dist{0:=100-RD_EN_ON_DIST, 1:=RD_EN_ON_DIST};}

endclass : FIFO_transaction
endpackage : FIFO_transaction_pkg