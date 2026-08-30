module fourbit_comparator (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire eq,
    output wire gt,
    output wire lt
);
    wire eq3, gt3, lt3;
    wire eq2, gt2, lt2;
    wire eq1, gt1, lt1;
    wire eq0, gt0, lt0;

    comparator c3 ( .a(a[3]), .b(b[3]), .eq(eq3), .gt(gt3), .lt(lt3) );
    comparator c2 ( .a(a[2]), .b(b[2]), .eq(eq2), .gt(gt2), .lt(lt2) );
    comparator c1 ( .a(a[1]), .b(b[1]), .eq(eq1), .gt(gt1), .lt(lt1) );    
    comparator c0 ( .a(a[0]), .b(b[0]), .eq(eq0), .gt(gt0), .lt(lt0) );

    assign eq = eq3 & eq2 & eq1 & eq0;
    assign gt = gt3 | (eq3 & gt2) | (eq3 & eq2 & gt1) | (eq3 & eq2 & eq1 & gt0);
    assign lt = lt3 | (eq3 & lt2) | (eq3 & eq2 & lt1) | (eq3 & eq2 & eq1 & lt0);   
endmodule