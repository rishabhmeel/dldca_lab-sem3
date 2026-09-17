module mux_behavioral (
    input wire a,
    input wire b,
    input wire sel,
    output reg y
);
    wire x ;

    mux_dataflow m1 (.a(a),.b(b),.sel(sel),.y(x));

    always @(*) begin
        y <= x;
    end

endmodule
