module comparator (
    input wire a,
    input wire b,
    output wire eq,
    output wire gt,
    output wire lt
);
    assign eq = ~(a ^ b);
    assign gt = a & (~b);
    assign lt = (~a) & b;
endmodule
