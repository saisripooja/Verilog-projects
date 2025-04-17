module uart_tb;

    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] data_in;
    wire tx;
    wire rx;
    wire busy;
    wire [7:0] data_out;
    wire data_valid;

    // Instantiate UART Transmitter
    uart_tx #(.BAUD_RATE_DIV(5208)) u_tx (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .data_in(data_in),
        .tx(tx),
        .busy(busy)
    );

    // Instantiate UART Receiver
    uart_rx #(.BAUD_TICK(5208)) u_rx (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data_out(data_out),
        .data_valid(data_valid)
    );

    // Connect TX to RX
    assign rx = tx;

    // Generate 50MHz clock (period = 20ns)
    always #10 clk = ~clk;

    initial begin
        // Initial values
        clk      = 1'b0;
        rst      = 1'b1;
        tx_start = 1'b0;
        data_in  = 8'hA5; // Example data to send

        // Release reset after some time
        #100 rst = 1'b0;

        // Wait, then start transmission
        #200 tx_start = 1'b1;
        #20  tx_start = 1'b0; // Single-cycle pulse

        // Wait for TX to finish
        wait (!busy);

        // Let simulation run a bit longer, then finish
        #1000000 $finish;
    end
endmodule
