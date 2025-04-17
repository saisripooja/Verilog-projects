module vending_machine_tb;
    reg clk;
    reg reset;
    reg rupee1, rupee2, rupee5;
    wire dispense;
    wire [3:0] state;

    vending_machine vm (
        .clk(clk),
        .reset(reset),
        .rupee1(rupee1),
        .rupee2(rupee2),
        .rupee5(rupee5),
        .dispense(dispense),
        .state(state)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        rupee1 = 0;
        rupee2 = 0;
        rupee5 = 0;

        // Apply reset
        #10 reset = 0;

        // Insert random coins
        repeat (10) begin
            #10;
            case ($random % 3)  // Randomly insert 1, 2, or 5 rupees
                0: begin
                    rupee1 = 1; rupee2 = 0; rupee5 = 0;
                end
                1: begin
                    rupee1 = 0; rupee2 = 1; rupee5 = 0;
                end
                2: begin
                    rupee1 = 0; rupee2 = 0; rupee5 = 1;
                end
            endcase
            #10;
            rupee1 = 0; rupee2 = 0; rupee5 = 0;  // Clear inputs
        end

        // Check dispense
        #10;
        if (dispense) begin
            $display("Dispense occurred at total: 10 rupees");
            $stop; // Stop simulation after dispensing
        end
    end
endmodule
