module tb_dual_port_ram;

    // Testbench signals
    reg         clk;
    reg         rst;
    reg  [7:0]  din_a;
    reg  [7:0]  din_b;
    reg  [3:0]  addr_a;
    reg  [3:0]  addr_b;
    reg         we_a;
    reg         we_b;
    wire [7:0]  dout_a;
    wire [7:0]  dout_b;
    wire        collision_detected;

    // Instantiate the dual-port RAM
    dual_port_ram uut (
        .clk(clk),
        .rst(rst),
        .din_a(din_a),
        .din_b(din_b),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .we_a(we_a),
        .we_b(we_b),
        .dout_a(dout_a),
        .dout_b(dout_b),
        .collision_detected(collision_detected)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time-unit period
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst   = 0;
        din_a = 8'd0;
        din_b = 8'd0;
        addr_a = 4'd0;
        addr_b = 4'd0;
        we_a = 0;
        we_b = 0;

        // 1) Apply reset
        rst = 1;
        #10;
        rst = 0;
        #10;

        // 2) Write to Port A
        addr_a = 4'd1;
        din_a  = 8'b10101010; // 0xAA
        we_a   = 1;
        #10;
        we_a   = 0;
        #10;

        // 3) Write to Port B
        addr_b = 4'd2;
        din_b  = 8'b01010101; // 0x55
        we_b   = 1;
        #10;
        we_b   = 0;
        #10;

        // 4) Read from Port A and Port B
        addr_a = 4'd1;
        addr_b = 4'd2;
        #10;

        // 5) Collision scenario: both ports write to the same address
        addr_a = 4'd3;
        addr_b = 4'd3;
        din_a  = 8'b11110000; // 0xF0
        din_b  = 8'b00001111; // 0x0F
        we_a   = 1;
        we_b   = 1;
        #10;
        we_a   = 0;
        we_b   = 0;
        #10;

        // Finish simulation
        $finish;
    end

    // Monitor signals for debugging
    initial begin
        $monitor("Time=%0t | A: addr=%0d we=%b din=%0h dout=%0h | B: addr=%0d we=%b din=%0h dout=%0h | collision=%b",
                 $time,
                 addr_a, we_a, din_a, dout_a,
                 addr_b, we_b, din_b, dout_b,
                 collision_detected);
    end

endmodule
