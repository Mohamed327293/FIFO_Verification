module top();

bit clk;

initial
  begin
    clk = 0;
    forever #1 clk = ~clk;
  end

  FIFO_if fifo_if(clk);
  FIFO DUT(fifo_if);
  FIFO_tb tb(fifo_if);
  monitor mon(fifo_if);

  always_comb begin
    if(!fifo_if.rst_n) begin
        assert final (fifo_if.wr_ack == 0);
        assert final (fifo_if.overflow == 0);
        assert final (fifo_if.underflow == 0);
        assert final (fifo_if.full == 0);
        assert final (fifo_if.empty == 1);
        assert final (fifo_if.almostfull == 0);
        assert final (fifo_if.almostempty == 0);
    end
  end

endmodule