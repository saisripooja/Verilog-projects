module ALU (
    input wire [7:0] A,        
    input wire [7:0] B,        
    input wire [2:0] control,  
    output reg [7:0] result,   
    output reg zero            
);

    always @(*) begin
        case (control)
            3'b000: result = A + B;          
            3'b001: result = A - B;             
            3'b010: result = A & B;             
            3'b011: result = A | B;           
            3'b100: result = A ^ B;          
            3'b101: result = A + B;        
            3'b110: result = A ^ B;             
            3'b111: result = A >> 1;         
            default: result = 8'b0;
        endcase
        
        zero = (result == 8'b0);
    end

endmodule
