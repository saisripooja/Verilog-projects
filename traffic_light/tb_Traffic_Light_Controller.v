module tb_Traffic_Light_Controller;

    reg clk, rst;          // Clock and reset signals
    wire [2:0] NS, EW;     // Traffic light outputs for North-South and East-West

    // Instantiate the Traffic Light Controller
    Traffic_Light_Controller uut (
        .clk(clk),
        .rst(rst),
        .NS(NS),
        .EW(EW)
    );

    // Generate clock signal (50% duty cycle)
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        clk = 0;
        rst = 1; #10;  // Reset the system
        rst = 0;

        // Run the simulation for 30 clock cycles
        #100;

        $finish;  // End simulation
    end

    // Monitor the outputs
    initial begin
        $monitor("Time=%0t | NS=%b | EW=%b", $time, NS, EW);
    end

endmodule
