module tb_Router_1x3;

    // Testbench signals
    reg [7:0] data_in;        // 8-bit input data
    reg [1:0] control;        // 2-bit control signal to select the output
    wire [7:0] data_out1;     // 8-bit output data port 1
    wire [7:0] data_out2;     // 8-bit output data port 2
    wire [7:0] data_out3;     // 8-bit output data port 3

    // Instantiate the Router_1x3 module
    Router_1x3 uut (
        .data_in(data_in),
        .control(control),
        .data_out1(data_out1),
        .data_out2(data_out2),
        .data_out3(data_out3)
    );

    // Stimulus block to generate test cases
    initial begin
        // Test case 1: Send data to output 1
        data_in = 8'b10101010; // Test data
        control = 2'b00;       // Route to output 1
        #10;                   // Wait for 10 time units

        // Test case 2: Send data to output 2
        control = 2'b01;       // Route to output 2
        #10;                   // Wait for 10 time units

        // Test case 3: Send data to output 3
        control = 2'b10;       // Route to output 3
        #10;                   // Wait for 10 time units

        // Test case 4: Default case where no output is selected
        control = 2'b11;       // Invalid control, no data should be routed
        #10;                   // Wait for 10 time units

        $finish;                // End simulation
    end

    // Monitor block to display values
    initial begin
        $monitor("At time %t, control = %b, data_in = %b, data_out1 = %b, data_out2 = %b, data_out3 = %b", 
                  $time, control, data_in, data_out1, data_out2, data_out3);
    end

endmodule
