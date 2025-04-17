// Unsigned Divider (Combinational)
// This module divides an unsigned dividend by an unsigned divisor.
// Parameter WIDTH sets the bit–width of the operands.
module unsigned_divider #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] dividend,
    input  [WIDTH-1:0] divisor,
    output reg [WIDTH-1:0] quotient,
    output reg [WIDTH-1:0] remainder
);

    integer i;
    // rem is one bit wider than the operands.
    reg [WIDTH:0] rem;  

    always @(*) begin
        quotient = 0;
        rem      = 0;
        // Process each bit from MSB to LSB
        for(i = WIDTH-1; i >= 0; i = i - 1) begin
            // Shift left the current remainder and bring in the next dividend bit.
            rem = {rem[WIDTH-1:0], dividend[i]};
            // If the shifted remainder is greater than or equal to divisor,
            // subtract the divisor and set the quotient bit.
            if (rem >= divisor) begin
                rem = rem - divisor;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end
        remainder = rem[WIDTH-1:0];
    end

endmodule
