module async_fifo
  #(parameter FIFO_SIZE=8, DATA_SIZE=32)
  (
  input reg [DATA_SIZE-1:0]  data_in,
  input 		     pop,
  input 		     push,
  input 		     clk_rdd,
  input 		     clk_wrd,
  input 		     rst,
  output reg [DATA_SIZE-1:0] data_out,
  output reg 		     empty,
  output reg 		     full
  );
  
  localparam ADD_WIDTH = $clog2(FIFO_SIZE);
  
  // internal //
  wire [ADD_WIDTH:0] 	     nxt_wr_ad, nxt_rd_ad;
  reg [ADD_WIDTH:0] 	     wr_ad_wrd, rd_ad_rdd, wr_ad_rdd, rd_ad_wrd; 
  wire 			     read, write, rep_full, rep_empty;
  reg [DATA_SIZE-1:0] 	     reg_file [FIFO_SIZE-1:0];
  
   // pointers //
  assign nxt_wr_ad = wr_ad_wrd+1;
  assign nxt_rd_ad = rd_ad_rdd+1; 
      
  // states //
  assign read = pop & (~empty);
  assign write = push & (~full);
  
  // reading and writing //
  assign data_out = reg_file[rd_ad_rdd[ADD_WIDTH-1:0]];                  
  always @(posedge clk_wrd)
    if(write) reg_file[wr_ad_wrd[ADD_WIDTH-1:0]] <= data_in;

  // synchronizer //
  cross_clock #(
		.DATA_WIDTH(ADD_WIDTH+1)
		)
  cross_clock_wrd2rdd(
		      .bin_in(wr_ad_wrd),
		      .bin_out(wr_ad_rdd),
		      .clk_rec(clk_rdd),
		      .clk_snd(clk_wrd), 
		      .rst(rst)
		      );

  cross_clock #(
		.DATA_WIDTH(ADD_WIDTH+1)
		)
  cross_clock_rdd2wrd(
		      .bin_in(rd_ad_rdd), 
		      .bin_out(rd_ad_wrd),
		      .clk_rec(clk_wrd), 
		      .clk_snd(clk_rdd), 
		      .rst(rst)
		      );
  
  // full/empty logic //
  assign rep_full = (rd_ad_wrd[ADD_WIDTH] != wr_ad_wrd[ADD_WIDTH]);
  assign full = (rd_ad_wrd[ADD_WIDTH-1:0] == wr_ad_wrd[ADD_WIDTH-1:0])
    & rep_full;
  
  assign rep_empty = (wr_ad_rdd[ADD_WIDTH] == rd_ad_rdd[ADD_WIDTH]);
  assign empty = (wr_ad_rdd[ADD_WIDTH-1:0] == rd_ad_rdd[ADD_WIDTH-1:0])
    & rep_empty;

  // controllers //
  // write //
  always@(posedge clk_wrd or negedge rst) begin 
    if (~rst) wr_ad_wrd <= {(ADD_WIDTH+1){1'b0}};
    else if (write) wr_ad_wrd <= nxt_wr_ad;
  end
  
  // read //   
  always@(posedge clk_rdd or negedge rst) begin 
    if (~rst) rd_ad_rdd <= {(ADD_WIDTH+1){1'b0}};
    else if (read) rd_ad_rdd <= nxt_rd_ad;
  end
    
  // SVA Assertions //
  
  `ifdef ECIP_SVA_ON   
  // Check : write while fifo is full 
    `ASSUMES_NEVER(WriteWhenFull, push & full, posedge clk_rdd, ~rst,
		   `ERR_MSG ("ERROR: Attempting to write to a full FIFO!"));   
  // Check : read while fifo is empty
    `ASSUMES_NEVER(ReadWhenEmpty, pop & empty, posedge clk_wrd, ~rst,
		   `ERR_MSG ("ERROR: Attempting to read from an empty FIFO!"));
  // Check : full and empty are not on together
    `ASSERTC_FORBIDDEN(FullWhenEmpty, full & empty, ~rst,
		       `ERR_MSG ("ERROR: Both flags Empty and full are on!"));
  // Check : empty drops after push  
    `ASSERTS_DELAYED_TRIGGER(EmptyDropsAfterPush, empty & push, 4, ~empty, posedge clk_rdd, ~rst,
			     `ERR_MSG("ERROR: Empty does not drop after pushp!"));
  // Check : full drops after pop  
    `ASSERTS_DELAYED_TRIGGER(FullDropsAfterPop, pop & full, 4, ~full, posedge clk_wrd, ~rst,
			     `ERR_MSG("ERROR: Full does not drop after pop!"));

`endif
  

  // TIRGUL on non-macro Assertions

//  no_push_when_full: assume property
//  (
//   disable iff (~rst) @(posedge clk_wrd) push |-> !full			    
//   );
//  
//  no_pop_when_empty: assume property
//  (
//   disable iff (~rst) @(posedge clk_rdd) pop |-> !empty			    
//   );
//
//  no_full_when_empty_wrd: assert property
//  (
//   disable iff (~rst) @(posedge clk_wrd) full |-> !empty			    
//   );
//  
//  no_full_when_empty_rdd: assert property
//  (
//   disable iff (~rst) @(posedge clk_rdd) empty |-> !full			    
//   );

  
endmodule // async_fifo