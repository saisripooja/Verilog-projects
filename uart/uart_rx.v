module uart_rx (
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [7:0] data_out,
    output reg data_valid
);
    parameter BAUD_TICK = 5208; // 50MHz clock -> 9600 baud

    reg [12:0] baud_count;
    reg        baud_tick;

    // Simple FSM States (pure Verilog)
    localparam IDLE  = 3'b000;
    localparam START = 3'b001;
    localparam DATA  = 3'b010;
    localparam STOP  = 3'b011;

    reg [2:0] state;
    reg [7:0] shift_reg;
    reg [3:0] bit_index;
    reg       rx_prev;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= IDLE;
            baud_count  <= 13'd0;
            baud_tick   <= 1'b0;
            bit_index   <= 4'd0;
            shift_reg   <= 8'd0;
            data_out    <= 8'd0;
            data_valid  <= 1'b0;
            rx_prev     <= 1'b1;
        end 
        else begin
            // Generate a baud tick
            if (baud_count == BAUD_TICK - 1) begin
                baud_count <= 13'd0;
                baud_tick  <= 1'b1;
            end else begin
                baud_count <= baud_count + 1'b1;
                baud_tick  <= 1'b0;
            end

            // Track previous RX for falling-edge detection
            rx_prev <= rx;

            case (state)
                IDLE: begin
                    data_valid <= 1'b0;
                    // Detect falling edge of start bit
                    if (!rx && rx_prev) begin
                        state       <= START;
                        baud_count  <= 13'd0;
                    end
                end

                START: begin
                    // Sample at the midpoint of the start bit
                    if (baud_tick && (baud_count == (BAUD_TICK >> 1))) begin
                        if (!rx) begin
                            // Valid start bit
                            state     <= DATA;
                            bit_index <= 4'd0;
                        end else begin
                            // False start
                            state <= IDLE;
                        end
                    end
                end

                DATA: begin
                    if (baud_tick) begin
                        // Shift in bits LSB-first
                        shift_reg <= {rx, shift_reg[7:1]};
                        if (bit_index == 7) begin
                            state <= STOP;
                        end else begin
                            bit_index <= bit_index + 1'b1;
                        end
                    end
                end

                STOP: begin
                    if (baud_tick) begin
                        // Check for a valid stop bit (rx == 1)
                        if (rx) begin
                            data_out   <= shift_reg;
                            data_valid <= 1'b1;
                        end
                        state <= IDLE; 
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
