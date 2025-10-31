import FIFO_transaction_pkg::*;
import FIFO_sb_pkg::*;
import FIFO_cov_pkg::*;
import shared_pkg::*;

module monitor(FIFO_if.mon fifo_if);
FIFO_transaction fifo_txn;
FIFO_sb fifo_sb;
FIFO_coverage fifo_cvg;


initial
  begin
    fifo_txn = new(65,65);
    fifo_sb = new();
    fifo_cvg = new();
    forever begin
        // Wait for event triggered by testbench after driving inputs
        wait(sample_event.triggered);
        @(negedge fifo_if.clk);
        fifo_txn.rst_n = fifo_if.rst_n;
        fifo_txn.wr_en = fifo_if.wr_en;
        fifo_txn.rd_en = fifo_if.rd_en;
        fifo_txn.data_in = fifo_if.data_in;
        fifo_txn.data_out = fifo_if.data_out;
        fifo_txn.full = fifo_if.full;
        fifo_txn.empty = fifo_if.empty;
        fifo_txn.almostfull = fifo_if.almostfull;
        fifo_txn.almostempty = fifo_if.almostempty;
        fifo_txn.wr_ack = fifo_if.wr_ack;
        fifo_txn.overflow = fifo_if.overflow;
        fifo_txn.underflow = fifo_if.underflow;
        fork 
            fifo_cvg.sample_data(fifo_txn);
            fifo_sb.check_data(fifo_txn);
        join
        if(test_finished) begin
            $display("Total Errors = %0d, Total Correct = %0d", error_cnt, correct_cnt);
            $stop;
        end
    end
  end

endmodule