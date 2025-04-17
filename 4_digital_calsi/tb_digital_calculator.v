module tb_digital_calculator;

    // Testbench signals
    reg [7:0] a, b;          // Input operands
    reg [2:0] op;            // Operation select
    wire [15:0] result;      // Final result
    wire add_result, sub_result, mul_result, div_result; // Operation result indicators

    // Instantiate the digital_calculator module
    digital_calculator uut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .add_result(add_result),
        .sub_result(sub_result),
        .mul_result(mul_result),
        .div_result(div_result)
    );

    // Testbench stimulus
    initial begin
        // Monitor results
        $monitor("a = %d, b = %d, op = %b, result = %d, add_result = %b, sub_result = %b, mul_result = %b, div_result = %b",
                 a, b, op, result, add_result, sub_result, mul_result, div_result);

        // Generate random inputs and apply to the design
        repeat (10) begin
            a = $random % 256;          // Random 8-bit value for operand a (0-255)
            b = $random % 256;          // Random 8-bit value for operand b (0-255)
            op = $random % 4;           // Random operation select (0-3, corresponding to Add, Sub, Mul, Div)
            #10;  // Wait for 10 time units to observe the result
        end
        
        // Test Division by Zero with random inputs
        a = $random % 256; 
        b = 0;                     // Division by zero
        op = 3'b011;               // Division operation
        #10; 

        $finish;
    end

endmodule
