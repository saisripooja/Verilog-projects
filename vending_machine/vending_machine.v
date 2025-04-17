module vending_machine (
    input wire clk,
    input wire reset,
    input wire rupee1,  // 1 Rupee Coin
    input wire rupee2,  // 2 Rupee Coin
    input wire rupee5,  // 5 Rupee Coin
    output reg dispense,  // Dispense signal
    output reg [3:0] state // 4-bit state register to represent states
);

    reg [3:0] total;  // To keep track of the total amount
    reg [3:0] next_state;  // For next state transitions

    // Define states
    parameter S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5;
    parameter S6 = 4'd6, S7 = 4'd7, S8 = 4'd8, S9 = 4'd9, S10 = 4'd10;  // Total 10 rupees

    // State machine logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            total <= 4'd0;
            dispense <= 0;
        end else begin
            state <= next_state;
        end
    end

    // State transition based on coin inputs
    always @(*) begin
        next_state = state;
        dispense = 0;  // Default no dispense
        case (state)
            S0: if (rupee1) next_state = S1;
            S1: if (rupee2) next_state = S3;
                else if (rupee1) next_state = S2;
            S2: if (rupee5) next_state = S7;
                else if (rupee1) next_state = S3;
            S3: if (rupee2) next_state = S5;
                else if (rupee1) next_state = S4;
            S4: if (rupee5) next_state = S9;
                else if (rupee1) next_state = S5;
            S5: if (rupee2) next_state = S7;
                else if (rupee1) next_state = S6;
            S6: if (rupee5) next_state = S10;
                else if (rupee1) next_state = S7;
            S7: if (rupee2) next_state = S9;
                else if (rupee1) next_state = S8;
            S8: if (rupee5) next_state = S10;
                else if (rupee1) next_state = S9;
            S9: if (rupee2) next_state = S10;
            S10: begin
                dispense = 1;  // Dispense when 10 rupees are reached
                next_state = S10;  // Stay in dispense state
            end
            default: next_state = S0;
        endcase
    end

    // Logic to handle total amount and stopping condition
    always @(posedge clk) begin
        if (state == S0) total <= 0;
        else if (state == S1) total <= total + 1;
        else if (state == S2) total <= total + 1;
        else if (state == S3) total <= total + 2;
        else if (state == S4) total <= total + 1;
        else if (state == S5) total <= total + 2;
        else if (state == S6) total <= total + 1;
        else if (state == S7) total <= total + 2;
        else if (state == S8) total <= total + 1;
        else if (state == S9) total <= total + 2;
        else if (state == S10) total <= 10;  // Maintain at 10 rupees
    end
endmodule
