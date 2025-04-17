module dual_port_ram (
    input             clk,                // Clock signal
    input             rst,                // Asynchronous reset (active high)
    input      [8:0]  din_a,              // Data input for Port A
    input      [8:0]  din_b,              // Data input for Port B
    input      [3:0]  addr_a,             // Address for Port A
    input      [3:0]  addr_b,             // Address for Port B
    input             we_a,               // Write enable for Port A
    input             we_b,               // Write enable for Port B
    output reg [8:0]  dout_a,             // Data output for Port A
    output reg [8:0]  dout_b,             // Data output for Port B
    output reg        collision_detected  // Collision flag output
);

    // Declare RAM memory (16 locations, 8 bits wide)
    reg [8:0] ram [15:0];
    
    integer i; // Loop variable for reset

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all RAM locations to 0
            for (i = 0; i < 16; i = i + 1) begin
                ram[i] <= 8'd0;
            end
            // Clear outputs and collision flag
            dout_a            <= 8'd0;
            dout_b            <= 8'd0;
            collision_detected <= 1'b0;
        end else begin
            // Collision Handling: Port A gets priority if both try to write to the same address
            if ((addr_a == addr_b) && we_a && we_b) begin
                ram[addr_a]      <= din_a;  // Port A wins
                collision_detected <= 1'b1;
            end else begin
                collision_detected <= 1'b0;

                // Write operations
                if (we_a) begin
                    ram[addr_a] <= din_a;
                end
                if (we_b && !(we_a && addr_a == addr_b)) begin
                    ram[addr_b] <= din_b;
                end
            end

            // Read operations
            dout_a <= ram[addr_a];
            dout_b <= ram[addr_b];
        end
    end
endmodule
