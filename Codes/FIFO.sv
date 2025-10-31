////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT fifo_if);

localparam max_fifo_addr = $clog2(fifo_if.FIFO_DEPTH);

reg [fifo_if.FIFO_WIDTH-1:0] mem [fifo_if.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

`ifdef SIM
always_comb begin //FIFO_13
	if(!fifo_if.rst_n) begin
		count_rst : assert final(count == 0);
		wr_ptr_rst : assert final(wr_ptr == 0);
		rd_ptr_rst : assert final(rd_ptr == 0);
	end
	if(count ==1) begin
		almostempty_assert : assert final(fifo_if.almostempty == 1'b1);
	end
	else if (count == 0) begin
		empty_assert_comb : assert final(fifo_if.empty == 1'b1);
	end
	else if (count == fifo_if.FIFO_DEPTH) begin
		full_assert_comb : assert final(fifo_if.full == 1'b1);
	end
	else if (count == fifo_if.FIFO_DEPTH-1) begin
		almostfull_assert : assert final(fifo_if.almostfull == 1'b1);
	end
end

property reset_behavior;
  @(posedge fifo_if.clk) (fifo_if.rst_n == 0) |-> (wr_ptr == 0 && rd_ptr == 0 && count == 0);
endproperty

property write_ack;
  @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) (fifo_if.wr_en && !fifo_if.full)
   |=> (fifo_if.wr_ack == 1);
endproperty

property overflow_detection;
  @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
   (fifo_if.wr_en && fifo_if.full) |=> (fifo_if.overflow == 1);
endproperty

property underflow_detection;
  @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
   (fifo_if.rd_en && fifo_if.empty) |=> (fifo_if.underflow == 1);
endproperty

property empty_flag;
  @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
   (count == 0) |-> (fifo_if.empty == 1);
endproperty

property full_flag;
  @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
   (count == fifo_if.FIFO_DEPTH) |-> (fifo_if.full == 1);
endproperty

property almostempty_flag;
  @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
   (count == 1) |-> (fifo_if.almostempty == 1);
endproperty

property almostfull_flag;
  @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
   (count == fifo_if.FIFO_DEPTH-1) |-> (fifo_if.almostfull == 1);
endproperty

property write_ptr_wrap;
  @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
  (fifo_if.wr_en && !fifo_if.full && wr_ptr == fifo_if.FIFO_DEPTH-1) |-> (wr_ptr == 0);
endproperty

property read_ptr_wrap;
  @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
  (fifo_if.rd_en && !fifo_if.empty && rd_ptr == fifo_if.FIFO_DEPTH-1) |-> (rd_ptr == 0);
endproperty

property pointer_threshold;
  @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
   (wr_ptr < fifo_if.FIFO_DEPTH && rd_ptr < fifo_if.FIFO_DEPTH);
endproperty
property count_threshold;
  @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
   (count <= fifo_if.FIFO_DEPTH);
endproperty

FIFO_1 : assert property(reset_behavior);
FIFO_2 : assert property(write_ack);
FIFO_3 : assert property(overflow_detection);
FIFO_4 : assert property(underflow_detection);
FIFO_5 : assert property(empty_flag);
FIFO_6 : assert property(full_flag);
FIFO_7 : assert property(almostempty_flag);
FIFO_8 : assert property(almostfull_flag);
FIFO_9_0 : assert property(write_ptr_wrap);
FIFO_9_1 : assert property(read_ptr_wrap);
FIFO_10_0 : assert property(pointer_threshold);
FIFO_10_1 : assert property(count_threshold);

`endif

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		wr_ptr <= 0;
		fifo_if.wr_ack <= 0;
		fifo_if.overflow <= 0; //improve
	end
	else if (fifo_if.wr_en && count < fifo_if.FIFO_DEPTH) begin
		mem[wr_ptr] <= fifo_if.data_in;
		fifo_if.wr_ack <= 1;
		fifo_if.overflow <= 0; //improve
		if(wr_ptr == fifo_if.FIFO_DEPTH-1) //improve
			wr_ptr <= 0; 
		else
			wr_ptr <= wr_ptr + 1; 
	end
	else begin 
		fifo_if.wr_ack <= 0; 
		if (fifo_if.full & fifo_if.wr_en)
			fifo_if.overflow <= 1;
		else
			fifo_if.overflow <= 0;
	end
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		rd_ptr <= 0;
		fifo_if.underflow <= 0; //improve
		fifo_if.data_out <= 0;  //improve
	end
	else if (fifo_if.rd_en && count != 0) begin
		fifo_if.data_out <= mem[rd_ptr];
		if(rd_ptr == fifo_if.FIFO_DEPTH-1) //improve
			rd_ptr <= 0; 
		else
			rd_ptr <= rd_ptr + 1;
	end

    //improve
	if (fifo_if.empty & fifo_if.rd_en && fifo_if.rst_n)
		fifo_if.underflow <= 1;
	else
		fifo_if.underflow <= 0;
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		count <= 0;
	end
	else begin // improve
        case ({fifo_if.wr_en, fifo_if.rd_en})
            2'b10: if (!fifo_if.full) count <= count + 1;
            2'b01: if (!fifo_if.empty) count <= count - 1;
            2'b11: begin
                if (fifo_if.empty) count <= count + 1;
                else if (fifo_if.full) count <= count - 1;
            end
            default: count <= count;
        endcase
    end
end

assign fifo_if.full = (count == fifo_if.FIFO_DEPTH)? 1 : 0;
assign fifo_if.empty = (count == 0)? 1 : 0;
assign fifo_if.almostfull = (count == fifo_if.FIFO_DEPTH-1)? 1 : 0; //improve
assign fifo_if.almostempty = (count == 1)? 1 : 0;

endmodule