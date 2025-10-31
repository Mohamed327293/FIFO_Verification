interface FIFO_if #(parameter FIFO_DEPTH = 8, parameter FIFO_WIDTH = 16)(clk);
    input bit clk;
    logic rst_n;
    logic wr_en;
    logic rd_en;
    logic [FIFO_WIDTH-1:0] data_in;
    logic [FIFO_WIDTH-1:0] data_out;
    logic full;
    logic empty;
    logic almostfull;
    logic almostempty;
    logic wr_ack;
    logic overflow;
    logic underflow;

    modport DUT(
        input clk,
        input rst_n,
        input wr_en,
        input rd_en,
        input data_in,
        output data_out,
        output full,
        output empty,
        output almostfull,
        output almostempty,
        output wr_ack,
        output overflow,
        output underflow
    );
    modport TEST(
        input clk,
        output rst_n,
        output wr_en,
        output rd_en,
        output data_in,
        input data_out,
        input full,
        input empty,
        input almostfull,
        input almostempty,
        input wr_ack,
        input overflow,
        input underflow
    );
    modport mon(
        input clk,
        input rst_n,
        input wr_en,
        input rd_en,
        input data_in,
        input data_out,
        input full,
        input empty,
        input almostfull,
        input almostempty,
        input wr_ack,
        input overflow,
        input underflow
    );
    
endinterface