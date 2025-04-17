`timescale 1ns/1ps

module SevenSegmentDisplay(
    input wire clk,            // System clock
    input wire reset,          // Reset signal
    input wire [7:0] bcd_input,// Two-digit BCD input (each 4-bit)
    output reg [6:0] seg,      // 7-segment display output (gfedcba)
    output reg [1:0] an        // Active-low digit select
);

    // We'll select which digit (LSD or MSD) to display based on counter[15]
    reg [3:0] digit;      // Current 4-bit digit to display
    reg [15:0] counter;   // Refresh-rate counter for multiplexing

    // Clock divider for multiplexing
    always @(posedge clk or posedge reset) begin
        if (reset)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    // Multiplexer: select between LSD (bcd_input[3:0]) and MSD (bcd_input[7:4])
    always @(*) begin
        case (counter[15])  // Slow toggle for display refresh
            1'b0: begin
                digit = bcd_input[3:0]; // Least Significant Digit
                an = 2'b10;             // Activate LSD (assuming active-low)
            end
            1'b1: begin
                digit = bcd_input[7:4]; // Most Significant Digit
                an = 2'b01;             // Activate MSD (assuming active-low)
            end
        endcase
    end

    // BCD to 7-segment decoder (Common Cathode, gfedcba)
    // For a common anode display, invert these bits.
    always @(*) begin
        case (digit)
            4'd0: seg = 7'b0111111; // 0
            4'd1: seg = 7'b0000110; // 1
            4'd2: seg = 7'b1011011; // 2
            4'd3: seg = 7'b1001111; // 3
            4'd4: seg = 7'b1100110; // 4
            4'd5: seg = 7'b1101101; // 5
            4'd6: seg = 7'b1111101; // 6
            4'd7: seg = 7'b0000111; // 7
            4'd8: seg = 7'b1111111; // 8
            4'd9: seg = 7'b1101111; // 9
            default: seg = 7'b0000000; // Turn all segments off for invalid digits
        endcase
    end

endmodule
