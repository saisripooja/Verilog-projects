module Traffic_Light_Controller (
    input wire clk,        // Clock signal
    input wire rst,        // Reset signal
    output reg [2:0] NS,   // North-South traffic light (Red, Yellow, Green)
    output reg [2:0] EW    // East-West traffic light (Red, Yellow, Green)
);

    // State encoding using local parameters (Verilog-style)
    localparam S_RED    = 2'b00;  // North-South Red, East-West Green
    localparam S_GREEN  = 2'b01;  // North-South Green, East-West Red
    localparam S_YELLOW = 2'b10;  // North-South Yellow, East-West Red

    reg [1:0] current_state, next_state;
    integer timer;  // Timer counter

    // Define traffic light colors
    localparam RED    = 3'b100;
    localparam YELLOW = 3'b010;
    localparam GREEN  = 3'b001;

    // State transition logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= S_RED;  // Reset to initial state
            timer <= 0;
        end else begin
            if (timer == 5) begin  // Change state every 5 clock cycles
                current_state <= next_state;
                timer <= 0;
            end else begin
                timer <= timer + 1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S_RED: next_state = S_GREEN;
            S_GREEN: next_state = S_YELLOW;
            S_YELLOW: next_state = S_RED;
            default: next_state = S_RED;
        endcase
    end

    // Output logic (Traffic light control)
    always @(*) begin
        case (current_state)
            S_RED: begin
                NS = RED;
                EW = GREEN;
            end
            S_GREEN: begin
                NS = GREEN;
                EW = RED;
            end
            S_YELLOW: begin
                NS = YELLOW;
                EW = RED;
            end
            default: begin
                NS = RED;
                EW = RED;
            end
        endcase
    end

endmodule
