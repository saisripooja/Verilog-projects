module spi_tb;
    reg clk;
    reg rst;
    wire miso;
    reg start;
    reg [7:0] data_in;  // Changed from wire to reg
    wire cs, mosi, sclk;
    wire [7:0] master_out, slave_out;
    wire done;
    wire [7:0] data_out;  

    // Instantiate SPI Master
    spi_master master (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),  // Corrected
        .cs(cs),
        .mosi(mosi),
        .sclk(sclk),
        .master_out(master_out),
        .miso(miso),
        .done(done)
    );

    // Instantiate SPI Slave
    spi_slave slave (
        .clk(clk),
        .miso(miso),
        .mosi(mosi),
        .cs(cs),
        .sclk(sclk),
        .slave_out(slave_out)
    );

    // Multiplexer Module to Select Data Output
    spi_mux output_mux (
        .cs(cs),
        .master_data(master_out),
        .slave_data(slave_out),
        .data_out(data_out)
    );

    // Testbench Logic
    initial begin
        clk = 0;
        rst = 1;  
        #10 rst = 0;
        data_in = 8'hA5;  // ✅ Now valid
        start = 1;
        #10 start = 0;
    end

    // Clock generation
    always #5 clk = ~clk; 
endmodule
