module uart_tx (
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0] data_in,
    output reg tx,
    output reg busy
);
    parameter BAUD_RATE_DIV = 5208; // 50MHz clock -> 9600 baud

    reg [12:0] baud_counter;
    reg [3:0] bit_count;
    reg [9:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx           <= 1'b1;    // UART line idle is '1'
            busy         <= 1'b0;
            baud_counter <= 13'd0;
            bit_count    <= 4'd0;
            shift_reg    <= 10'b0;
        end else begin
            // Start a new transmission when tx_start is pulsed and not busy
            if (tx_start && !busy) begin
                busy         <= 1'b1;
                // [Stop bit(1) | Data_in(8 bits) | Start bit(0)]
                // Actually the shift is reversed: LSB is shift_reg[0]
                shift_reg    <= {1'b1, data_in, 1'b0};
                bit_count    <= 4'd0;
                baud_counter <= 13'd0;
                tx           <= 1'b0; // Immediately drive start bit (0)
            end 
            else if (busy) begin
                if (baud_counter == BAUD_RATE_DIV - 1) begin
                    baud_counter <= 13'd0;
                    tx           <= shift_reg[0];        // Send LSB first
                    shift_reg    <= shift_reg >> 1;      // Shift right
                    bit_count    <= bit_count + 1'b1;

                    // After sending 1 start + 8 data + 1 stop = 10 bits total
                    if (bit_count == 9) begin
                        busy <= 1'b0; // Done transmitting
                    end
                end else begin
                    baud_counter <= baud_counter + 1'b1;
                end
            end
        end
    end
endmodule
