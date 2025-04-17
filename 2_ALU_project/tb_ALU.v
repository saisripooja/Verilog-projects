module tb_ALU;

    reg [7:0] A;            
    reg [7:0] B;             
    reg [2:0] control;        
    wire [7:0] result;       
    wire zero;              

    ALU uut (
        .A(A),
        .B(B),
        .control(control),
        .result(result),
        .zero(zero)
    );

    initial begin
        repeat (8) begin
            A = $random;       
            B = $random;       
            control = $random % 8; 
            #10;
        end
        $finish; 
    end

    initial begin
        $monitor("At time %t, A = %0d, B = %0d, control = %0d, result = %0d, zero = %b", 
                  $time, A, B, control, result, zero);
    end

endmodule
