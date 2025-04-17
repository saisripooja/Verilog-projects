module tb_mux2to1;

    reg A;
    reg B;
    reg sel;
    wire Y;

    mux2to1 uut (
        .A(A),
        .B(B),
        .sel(sel),
        .Y(Y)
    );

    initial begin
        A = 0; B = 0; sel = 0; #10;
        A = 0; B = 1; sel = 0; #10;
        A = 1; B = 0; sel = 0; #10;
        A = 1; B = 1; sel = 0; #10;
        A = 0; B = 0; sel = 1; #10;
        A = 0; B = 1; sel = 1; #10;
        A = 1; B = 0; sel = 1; #10;
        A = 1; B = 1; sel = 1; #10;
        $finish;
    end

    initial begin
        $monitor("At time %t, A = %b, B = %b, sel = %b, Y = %b", $time, A, B, sel, Y);
    end

endmodule
