module digital_calculator (
    input [7:0] a,        // First operand
    input [7:0] b,        // Second operand
    input [2:0] op,       // Operation select (0=Add, 1=Subtract, 2=Multiply, 3=Divide)
    output reg [15:0] result, // Final result
    output reg add_result,    // Add result indicator
    output reg sub_result,    // Subtract result indicator
    output reg mul_result,    // Multiply result indicator
    output reg div_result     // Divide result indicator
);

    always @(*) begin
        // Default outputs
        add_result = 0;
        sub_result = 0;
        mul_result = 0;
        div_result = 0;
        result = 16'h0000;

        case (op)
            3'b000: begin  // Addition
                result = a + b;
                add_result = 1;
            end
            3'b001: begin  // **Fixed Subtraction using Signed Arithmetic**
                result = $signed({1'b0, a}) - $signed({1'b0, b});
                sub_result = 1;
            end
            3'b010: begin  // Multiplication
                result = a * b;
                mul_result = 1;
            end
            3'b011: begin  // Division
                if (b != 0) begin
                    result = a / b;
                    div_result = 1;
                end else begin
                    result = 16'hFFFF; // Error value for divide by zero
                    div_result = 1;
                end
            end
            default: begin  // Undefined operations return 0
                result = 16'h0000;
            end
        endcase
    end
endmodule
