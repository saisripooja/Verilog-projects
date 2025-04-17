`timescale 1ns / 1ps

module pwm_generator_tb;
    
    reg clk;
    reg rst;
    reg [7:0] duty_cycle;
    wire pwm_out;

    // Instantiate the PWM generator module
    pwm_generator uut (
        .clk(clk),
        .rst(rst),
        .duty_cycle(duty_cycle),
        .pwm_out(pwm_out)
    );

    // Clock generation (50 MHz -> 20ns period)
    always #10 clk = ~clk;

    initial begin
        // Initialize values
        clk = 0;
        rst = 1;
        duty_cycle = 8'd128; // 50% duty cycle

        // Reset the system
        #20 rst = 0;

        // Change duty cycle after some time
        #100 duty_cycle = 8'd64; // 25% duty cycle
        #100 duty_cycle = 8'd192; // 75% duty cycle
        #100 duty_cycle = 8'd255; // 100% duty cycle
        #100 duty_cycle = 8'd0;   // 0% duty cycle

        #100 $stop; // Stop simulation
    end

endmodule
