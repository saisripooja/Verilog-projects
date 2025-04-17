module tb_sequence_detector;
    reg clk, rst, in;
    wire detected;

    // Instantiate the sequence detector
    sequence_detector uut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .detected(detected)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        in = 0;
        
        // Apply reset
        #10 rst = 0;
        
        // Apply test sequence: 1011011 (should detect at the last 1011)
        #10 in = 1;  // 1
        #10 in = 0;  // 10
        #10 in = 1;  // 101
        #10 in = 1;  // 1011 (Detected)
        #10 in = 0;  // 0
        #10 in = 1;  // 1
        #10 in = 1;  // 11
        #10 in = 0;  // 110
        #10 in = 1;  // 1101
        #10 in = 1;  // 1011 (Detected)

        // Finish simulation
        #20 $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t | in=%b | detected=%b", $time, in, detected);
    end
endmodule
