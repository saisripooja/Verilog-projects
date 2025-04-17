module Router_1x3 (
    input wire [7:0] data_in,  // 8-bit input data
    input wire [1:0] control,  // 2-bit control signal to select the output
    output reg [7:0] data_out1, // 8-bit output data port 1
    output reg [7:0] data_out2, // 8-bit output data port 2
    output reg [7:0] data_out3  // 8-bit output data port 3
);

    always @(*) begin
        // Default values (ensure outputs are 0 when not selected)
        data_out1 = 8'b0;
        data_out2 = 8'b0;
        data_out3 = 8'b0;
        
        case (control)
            2'b00: data_out1 = data_in; // Route data to output 1
            2'b01: data_out2 = data_in; // Route data to output 2
            2'b10: data_out3 = data_in; // Route data to output 3
            2'b11: begin
                data_out1 = data_in;  // Broadcast data to all outputs
                data_out2 = data_in;
                data_out3 = data_in;
            end
        endcase
    end

endmodule
