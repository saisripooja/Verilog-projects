module spi_slave (
    input wire clk,      
    input wire cs,      
    input wire mosi,    
    input wire sclk,    
    output reg miso,    
    output reg [7:0] slave_out  // Changed name to avoid conflicts
);

    reg [7:0] shift_reg;  
    reg [2:0] bit_cnt;    

    initial begin
        slave_out = 8'b0;  
    end

    always @(posedge sclk or posedge cs) begin
        if (cs) begin
            bit_cnt <= 0;
            shift_reg <= 8'b0;  
            miso <= 1'b0;  
            slave_out <= shift_reg;  
        end else begin
            miso <= shift_reg[7];  
            shift_reg <= {shift_reg[6:0], mosi};  
            bit_cnt <= bit_cnt + 1;

            if (bit_cnt == 7) begin
                slave_out <= shift_reg;  
            end
        end
    end

endmodule
