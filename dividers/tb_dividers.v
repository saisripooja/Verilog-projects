module tb_dividers;

  // Parameters
  parameter WIDTH = 8;

  // Signals for unsigned divider
  reg  [WIDTH-1:0] u_dividend;
  reg  [WIDTH-1:0] u_divisor;
  wire [WIDTH-1:0] u_quotient;
  wire [WIDTH-1:0] u_remainder;
  
  // Signals for signed divider
  reg  signed [WIDTH-1:0] s_dividend;
  reg  signed [WIDTH-1:0] s_divisor;
  wire signed [WIDTH-1:0] s_quotient;
  wire signed [WIDTH-1:0] s_remainder;

  // Instantiate unsigned divider
  unsigned_divider #(.WIDTH(WIDTH)) udiv_inst (
    .dividend(u_dividend),
    .divisor(u_divisor),
    .quotient(u_quotient),
    .remainder(u_remainder)
  );

  // Instantiate signed divider
  signed_divider #(.WIDTH(WIDTH)) sdiv_inst (
    .dividend(s_dividend),
    .divisor(s_divisor),
    .quotient(s_quotient),
    .remainder(s_remainder)
  );

  initial begin
    // Display header for output
    $display("Time\t| u_dividend u_divisor u_quotient u_remainder || s_dividend s_divisor s_quotient s_remainder");
    $monitor("%0t\t| %d\t   %d\t   %d\t    %d   || %d\t    %d\t   %d\t    %d",
             $time, u_dividend, u_divisor, u_quotient, u_remainder,
             s_dividend, s_divisor, s_quotient, s_remainder);

    // Test Case 1: Simple division
    u_dividend = 8'd100; u_divisor = 8'd3;
    s_dividend = 8'sd100; s_divisor = 8'sd3;
    #10;

    // Test Case 2: Larger dividend, different values
    u_dividend = 8'd255; u_divisor = 8'd10;
    s_dividend = -8'sd100; s_divisor = 8'sd3;
    #10;

    // Test Case 3: Different values, negative signed divisor
    u_dividend = 8'd50; u_divisor = 8'd7;
    s_dividend = 8'sd100; s_divisor = -8'sd3;
    #10;

    // Test Case 4: Both operands negative for signed division (unsigned remains positive)
    u_dividend = 8'd75; u_divisor = 8'd8;
    s_dividend = -8'sd100; s_divisor = -8'sd3;
    #10;

    $finish;
  end

endmodule
