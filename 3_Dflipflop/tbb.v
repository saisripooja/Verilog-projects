module tb_dff;

  reg clk, rst_n, d;
  wire q;

  D_flipflopB uut (
    .clk(clk),
    .rst_n(rst_n),
    .d(d),
    .q(q)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst_n = 0; d = 0; #10; 
    rst_n = 1; d = 1; #10; 
    d = 0; #10;  
    d = 1; #10;  
    rst_n = 0; #10; 
    rst_n = 1; #10; 
    $finish;
  end

  initial begin
    $monitor("Time: %t | clk: %b | rst_n: %b | d: %b | q: %b", 
             $time, clk, rst_n, d, q);
  end

endmodule
