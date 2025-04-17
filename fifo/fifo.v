// Sequential FIFO Module (Non-SystemVerilog)
module fifo #(
    parameter DATA_WIDTH = 8,      // Data bit-width
    parameter FIFO_DEPTH = 8,      // Number of FIFO entries (should be a power of 2)
    parameter PTR_WIDTH  = 3       // log2(FIFO_DEPTH)
)(
    input                     clk,     // Clock signal
    input                     rst,     // Asynchronous reset (active high)
    input                     wr_en,   // Write enable
    input                     rd_en,   // Read enable
    input  [DATA_WIDTH-1:0]   data_in, // Data input
    output reg [DATA_WIDTH-1:0] data_out, // Data output
    output                    full,    // FIFO full flag
    output                    empty    // FIFO empty flag
);

    // Memory array to hold FIFO data
    reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];

    // Read and Write pointers
    reg [PTR_WIDTH-1:0] wr_ptr;
    reg [PTR_WIDTH-1:0] rd_ptr;
    
    // Counter to track number of items in FIFO
    reg [PTR_WIDTH:0] count;  // Extra bit needed to count up to FIFO_DEPTH

    // Generate full and empty flags
    assign full  = (count == FIFO_DEPTH);
    assign empty = (count == 0);

    // Sequential logic: update pointers, counter, and memory
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr   <= 0;
            rd_ptr   <= 0;
            count    <= 0;
            data_out <= 0;
        end else begin
            // Write Operation: only when FIFO is not full
            if (wr_en && !full) begin
                mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
                count  <= count + 1;
            end

            // Read Operation: only when FIFO is not empty
            if (rd_en && !empty) begin
                data_out <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count  <= count - 1;
            end
        end
    end

endmodule
