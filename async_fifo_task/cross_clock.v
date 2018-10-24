module cross_clock
  #(parameter DATA_WIDTH=32)
  (
  input 		      rst,
  input [DATA_WIDTH-1:0]      bin_in,
  input 		      clk_rec,
  input 		      clk_snd, 
  output reg [DATA_WIDTH-1:0] bin_out
   );
  
  integer 		      i;
  
  // internal //
  reg [DATA_WIDTH-1:0] 	      buff;
  wire [DATA_WIDTH-1:0]       grey_snd;
  reg [DATA_WIDTH-1:0] 	      grey_rec;
  reg [DATA_WIDTH-1:0] 	      flpd_grey_snd;

  // bin2grey //
  assign grey_snd = bin_in ^ {1'b0 , bin_in[DATA_WIDTH-1:1]};

  // flop befor sync //
  always@(posedge clk_snd or negedge rst) begin
    if (~rst) flpd_grey_snd <= {(DATA_WIDTH){1'b0}};
    else flpd_grey_snd <= grey_snd;
  end
  
  // synchronizer // 
  always@(posedge clk_rec or negedge rst) begin
    if (~rst) begin
      grey_rec <= {(DATA_WIDTH){1'b0}};
      buff <= {(DATA_WIDTH){1'b0}};
    end
    else begin 
      buff <= flpd_grey_snd;
      grey_rec <= buff;
    end
  end

  // grey2bin //
  always_comb begin
    bin_out[DATA_WIDTH-1] = grey_rec[DATA_WIDTH-1];
    for (i=DATA_WIDTH-2; i>=0; i=i-1) bin_out[i] = grey_rec[i] ^ bin_out[i+1];
  end

  `ifdef ECIP_SVA_ON   
  // Check : Grey-code works 
    `ASSERTS_GRAY_CODE(GreyCodeOk, grey_snd, clk_snd, ~rst,
		       `ERR_MSG ("ERROR: More than one bit changes between any two consecutive clock ticks."));   
  `endif
  
endmodule // cross_clock