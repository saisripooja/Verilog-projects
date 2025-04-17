// Signed Divider (Combinational)
// This module divides a signed dividend by a signed divisor.
// The algorithm converts the operands to their absolute values,
// performs the division, then applies the appropriate sign corrections.
// Parameter WIDTH sets the bit–width of the operands.
module signed_divider #(parameter WIDTH = 8) (
    input  signed [WIDTH-1:0] dividend,
    input  signed [WIDTH-1:0] divisor,
    output reg   signed [WIDTH-1:0] quotient,
    output reg   signed [WIDTH-1:0] remainder
);

    integer i;
    reg [WIDTH-1:0] abs_dividend, abs_divisor;
    reg [WIDTH:0]   abs_rem;      // One extra bit for the remainder
    reg [WIDTH-1:0] abs_quotient;
    reg             dividend_sign, divisor_sign;

    always @(*) begin
        // Capture the sign bits.
        dividend_sign = dividend[WIDTH-1];
        divisor_sign  = divisor[WIDTH-1];
        
        // Compute absolute values.
        abs_dividend = dividend_sign ? -dividend : dividend;
        abs_divisor  = divisor_sign  ? -divisor  : divisor;
        
        abs_quotient = 0;
        abs_rem      = 0;
        
        // Division loop: process from MSB to LSB.
        for (i = WIDTH-1; i >= 0; i = i - 1) begin
            abs_rem = {abs_rem[WIDTH-1:0], abs_dividend[i]};
            if (abs_rem >= abs_divisor) begin
                abs_rem = abs_rem - abs_divisor;
                abs_quotient[i] = 1'b1;
            end else begin
                abs_quotient[i] = 1'b0;
            end
        end
        
        // The quotient sign is the XOR of the input signs.
        if (dividend_sign ^ divisor_sign)
            quotient = -abs_quotient;
        else
            quotient = abs_quotient;
        
        // The remainder takes the sign of the dividend.
        if (dividend_sign)
            remainder = -abs_rem[WIDTH-1:0];
        else
            remainder = abs_rem[WIDTH-1:0];
    end

endmodule
