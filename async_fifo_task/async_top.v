module async_top;

  reg clk_rdd, clk_wrd, rst, pop, push;
  reg [31:0] data_in;
  reg [31:0] data_out;
  reg 	     empty, full;

  initial begin // initial pop domain clock
    clk_rdd = 1'b0;
  end

  always begin // pop domain clock application
    #9 clk_rdd = ~clk_rdd;
  end
  
  initial begin // initial push domain clock
    clk_wrd = 1'b0;
  end

  always begin // push domain clock application
    #5 clk_wrd = ~clk_wrd;
  end
  
  task push_t;
    input reg [31:0] num;
    begin
      data_in <= num;
      push <= 1'b1;
      #10 push <= 1'b0;
    end
  endtask // pop_t
  
  task pop_t;
    begin
      pop <= 1'b1;
      #18 pop <= 1'b0;
    end
  endtask // pop_t
 
  initial begin
    rst = 1'b1;
    #100
    rst = 1'b0;
    #40
    rst = 1'b1;
    pop_t();
    #18
    #18
    pop_t();
    #18
    #18
    pop_t(); 
    pop_t();
    pop_t();
    pop_t();
    #18
    pop_t(); 
    pop_t();
    #18
    #18
    #18
    #18
    pop_t(); 
    pop_t();
    #18
    #18
    #18
    pop_t(); 
    pop_t();
    pop_t();
    pop_t();
    pop_t(); 
    pop_t();
    pop_t();
    pop_t();
    #200
    pop_t();
    #200
    pop_t();
  end // initial begin
  
  initial begin
    #100
    #40
    push_t(1);
    push_t(2);
    #10
    #10
    push_t(3); 
    push_t(4);
    push_t(5); 
    push_t(6);
    #10
    #10
    #10
    #10
    #10
    #10 
    push_t(7);
    push_t(8);
    push_t(9);
    #10
    push_t(10);
    #10
    push_t(11);
    #10
    #10
    push_t(12);
    #10
    #10
    #10
    push_t(13); 
    push_t(14);
    push_t(15);
    push_t(1);
    push_t(2);
    push_t(3);
    #10
    push_t(4);
    push_t(5);
    push_t(6);
    push_t(7); 
    push_t(8); 
    push_t(9);
    push_t(10);
    push_t(11);
    push_t(12);
    #200
    push_t(13);
    #200
    push_t(14);
    push_t(15);
    push_t(16);
    push_t(17); 
    push_t(18); 
    push_t(19);
    push_t(20);
    push_t(21);
  end // initial begin
  
  
  async_fifo async_fifo(.clk_wrd(clk_wrd), .clk_rdd(clk_rdd), .rst(rst), .pop(pop), .push(push),
		    .data_in(data_in), .data_out(data_out), .empty(empty),
		    .full(full));
 
    
endmodule // top