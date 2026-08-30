module fourbit_adder (
    input wire [3:0] a,
    input wire [3:0] b,
    input wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire c0,c1,c2;

    adder a0 ( .a(a[0]), .b(b[0]), .cin(cin), .cout(c0), .sum(sum[0]));
    adder a1 ( .a(a[1]), .b(b[1]), .cin(c0), .cout(c1), .sum(sum[1]));
    adder a2 ( .a(a[2]), .b(b[2]), .cin(c1), .cout(c2), .sum(sum[2]));
    adder a3 ( .a(a[3]), .b(b[3]), .cin(c2), .cout(cout), .sum(sum[3]));

endmodule