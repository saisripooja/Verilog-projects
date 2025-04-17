`timescale 1ns/1ps

module SevenSegmentDisplay_tb;

    reg clk;
    reg reset;
    reg [7:0] bcd_input;
    wire [6:0] seg;
    wire [1:0] an;

    // Instantiate the SevenSegmentDisplay module
    SevenSegmentDisplay uut (
        .clk(clk),
        .reset(reset),
        .bcd_input(bcd_input),
        .seg(seg),
        .an(an)
    );

    // Generate a 10 ns clock (100 MHz)
    always #5 clk = ~clk;

    // Monitor changes for debugging
    initial begin
        $monitor("Time=%t | bcd_input=%h | digit=%b | seg=%b | an=%b",
                 $time, bcd_input, uut.digit, seg, an);
    end

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        bcd_input = 8'h00;  // Display "00" initially
        #20;

        reset = 0;
        #20;

        // Apply different BCD values with delays
        bcd_input = 8'h12;  // Display "1" and "2"
        #100000;

        bcd_input = 8'h34;  // Display "3" and "4"
        #100000;

        bcd_input = 8'h56;  // Display "5" and "6"
        #100000;

        bcd_input = 8'h78;  // Display "7" and "8"
        #100000;

        bcd_input = 8'h90;  // Display "9" and "0"
        #100000;

        // End simulation
        $stop;
    end

endmodule
