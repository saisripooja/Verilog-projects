// FIFO Testbench (Non-SystemVerilog)
module fifo_tb;

    // Parameters (should match FIFO module parameters)
    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH = 8;
    parameter PTR_WIDTH  = 3;

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire full;
    wire empty;

    // Instantiate the FIFO
    fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH),
        .PTR_WIDTH(PTR_WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation: 10 time unit period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize signals
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;
        
        // Apply reset
        #15;
        rst = 0;
        
        // Write three data values into the FIFO
        #10; wr_en = 1; data_in = 8'hA1;
        #10; wr_en = 1; data_in = 8'hB2;
        #10; wr_en = 1; data_in = 8'hC3;
        #10; wr_en = 0;
        
        // Wait a bit and then read two values
        #20; rd_en = 1;
        #15; rd_en = 0;
        
        // Write two more data values
        #20; wr_en = 1; data_in = 8'hD4;
        #10; wr_en = 1; data_in = 8'hE5;
        #10; wr_en = 0;
        
        // Read the remaining data
        #20; rd_en = 1;
        #30; rd_en = 0;
        
        // End simulation
        #50;
        $finish;
    end

endmodule
