module spi_mux(
    input wire cs,
    input wire [7:0] master_data,
    input wire [7:0] slave_data,
    output reg [7:0] data_out
);
    always @(*) begin
        if (cs == 0)
            data_out = master_data;
        else
            data_out = slave_data;
    end
endmodule
