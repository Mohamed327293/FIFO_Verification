import FIFO_transaction_pkg::*;
import shared_pkg::*;

module FIFO_tb(FIFO_if.TEST fifo_if);
FIFO_transaction fifo_txn;

initial
  begin
    fifo_txn = new(75,75);
    fifo_if.wr_en = 0;
    fifo_if.rd_en = 0;
    fifo_if.data_in = 16'h0000;
    assert_reset();
    for(int i=0; i<25000; i++) begin
        assert(fifo_txn.randomize());
        fifo_if.rst_n = fifo_txn.rst_n;
        fifo_if.wr_en = fifo_txn.wr_en;
        fifo_if.rd_en = fifo_txn.rd_en;
        fifo_if.data_in = fifo_txn.data_in;
        @(negedge fifo_if.clk);

        -> sample_event;
    end
    test_finished = 1;
  end

  task assert_reset();
    fifo_if.rst_n = 0;
    @(negedge fifo_if.clk);
    fifo_if.rst_n = 1;
    @(negedge fifo_if.clk);
  endtask : assert_reset



endmodule : FIFO_tb