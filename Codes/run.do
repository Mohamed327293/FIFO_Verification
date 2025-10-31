vlib work
vlog shared_pkg.sv FIFO_transaction.sv FIFO_cov.sv FIFO_sb.sv FIFO.sv FIFO_if.sv FIFO_tb.sv monitor.sv top.sv +cover -covercells
vsim -voptargs=+acc work.top -cover 
add wave *
add wave -position insertpoint  \
sim:/top/fifo_if/wr_en \
sim:/top/fifo_if/wr_ack \
sim:/top/fifo_if/underflow \
sim:/top/fifo_if/rst_n \
sim:/top/fifo_if/rd_en \
sim:/top/fifo_if/overflow \
sim:/top/fifo_if/full \
sim:/top/fifo_if/FIFO_WIDTH \
sim:/top/fifo_if/FIFO_DEPTH \
sim:/top/fifo_if/empty \
sim:/top/fifo_if/data_out \
sim:/top/fifo_if/data_in \
sim:/top/fifo_if/clk \
sim:/top/fifo_if/almostfull \
sim:/top/fifo_if/almostempty
coverage save top.ucdb -onexit -du work.ALSU
run -all

