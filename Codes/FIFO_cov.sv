package FIFO_cov_pkg;

import FIFO_transaction_pkg::*;

class FIFO_coverage;
  FIFO_transaction F_cvg_txn;

  covergroup FIFO_cvg_cg;
    write_en : coverpoint F_cvg_txn.wr_en{
        bins WR_EN_0 = {0};
        bins WR_EN_1 = {1};
    }
    read_en : coverpoint F_cvg_txn.rd_en{
        bins RD_EN_0 = {0};
        bins RD_EN_1 = {1};
    }
    full : coverpoint F_cvg_txn.full{
        bins FULL_0 = {0};
        bins FULL_1 = {1};
    }
    empty : coverpoint F_cvg_txn.empty{
        bins EMPTY_0 = {0};
        bins EMPTY_1 = {1};
    }
    almostfull : coverpoint F_cvg_txn.almostfull{
        bins ALMOSTFULL_0 = {0};
        bins ALMOSTFULL_1 = {1};
    }
    almostempty : coverpoint F_cvg_txn.almostempty{
        bins ALMOSTEMPTY_0 = {0};
        bins ALMOSTEMPTY_1 = {1};
    }
    overflow : coverpoint F_cvg_txn.overflow{
        bins OVERFLOW_0 = {0};
        bins OVERFLOW_1 = {1};
    }
    underflow : coverpoint F_cvg_txn.underflow{
        bins UNDERFLOW_0 = {0};
        bins UNDERFLOW_1 = {1};
    }
    wr_ack : coverpoint F_cvg_txn.wr_ack{
        bins WR_ACK_0 = {0};
        bins WR_ACK_1 = {1};
    }
    cross_1 : cross write_en, read_en , full{
        ignore_bins cross_11 = binsof(write_en.WR_EN_1) && binsof(full.FULL_1);
    }
    cross_2 : cross write_en, read_en , empty{
        ignore_bins cross_22 = binsof(read_en.RD_EN_1) && binsof(empty.EMPTY_1);
    }

    cross_3 : cross write_en, read_en , almostfull;
    cross_4 : cross write_en, read_en , almostempty;

    cross_5 : cross write_en, read_en , overflow{
        ignore_bins cross_55 = binsof(write_en.WR_EN_0) && binsof(overflow.OVERFLOW_1);
    }

    cross_6 : cross write_en, read_en , underflow{
        ignore_bins cross_66 = binsof(read_en.RD_EN_0) && binsof(underflow.UNDERFLOW_1);
    }

    cross_7 : cross write_en, read_en , wr_ack{
        ignore_bins cross_77 = binsof(write_en.WR_EN_0) && binsof(wr_ack.WR_ACK_1);
    }
  endgroup : FIFO_cvg_cg

  function new();
    FIFO_cvg_cg = new();
  endfunction : new

  function void sample_data(FIFO_transaction F_txn);
        F_cvg_txn = F_txn;
        FIFO_cvg_cg.sample();
  endfunction : sample_data

endclass : FIFO_coverage
endpackage : FIFO_cov_pkg
