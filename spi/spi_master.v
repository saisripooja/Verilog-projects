module spi_master (
    input wire clk,
    input wire rst,    
    input wire start,
    input wire [7:0] data_in,
    output reg cs,  
    output reg mosi, 
    output reg sclk, 
    output reg [7:0] master_out,  // Changed name to avoid conflicts
    input wire miso,
    output reg done    
);

    reg [2:0] bit_cnt;
    reg shift_enable;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cs <= 1;
            sclk <= 0;
            done <= 0;
            bit_cnt <= 0;
            shift_enable <= 0;
            mosi <= 1'b0;  
            master_out <= 8'b0;
        end 
        else if (start && !shift_enable) begin
            cs <= 0;  
            shift_reg <= data_in;  
            shift_enable <= 1;
            done <= 0;
            bit_cnt <= 0;
            mosi <= data_in[7];  
        end 
        else if (shift_enable) begin
            sclk <= ~sclk;
            if (!sclk) begin  
                mosi <= shift_reg[7];  
                shift_reg <= {shift_reg[6:0], miso};  
                bit_cnt <= bit_cnt + 1;
                
                if (bit_cnt == 7) begin
                    shift_enable <= 0;
                    cs <= 1;  
                    done <= 1;
                    master_out <= shift_reg;  
                end
            end
        end
    end

endmodule
