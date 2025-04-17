module sequence_detector (
    input clk, rst, in,
    output reg detected
);
    // State encoding
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;
    
    reg [2:0] state, next_state;

    // State transition on clock edge
    always @(posedge clk or posedge rst) begin
        if (rst) 
            state <= S0;
        else 
            state <= next_state;
    end

    // Next state logic and output logic
    always @(*) begin
        detected = 0;
        case (state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S1 : S2;
            S2: next_state = (in) ? S3 : S0;
            S3: next_state = (in) ? S4 : S2;
            S4: begin
                detected = 1;
                next_state = (in) ? S1 : S2;
            end
            default: next_state = S0;
        endcase
    end
endmodule
