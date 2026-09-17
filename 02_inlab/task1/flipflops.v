module dFlipFlop (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
    
endmodule

module tFlipFlop (
    input clk,
    input t,
    output reg q
);
    always @(posedge clk) begin
        q <= t ^ q;
    end
endmodule

module buffer (
    input d,
    output wire q
);
    assign q=d;
    // Combinational logic can be written using assign statements
    // The output changes immediately with the input

endmodule