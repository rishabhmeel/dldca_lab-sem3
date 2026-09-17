module loadable_reg (
    input wire clk,
    input wire rst,
    input wire load,
    input wire d,
    output reg q
);
    // Hint: instantiate mux_behavioral to compute the next value of q
    // (hold q if load is low, take d if load is high), then register
    // that value on the clock edge.
    wire old_q;
    wire new_q;
    assign old_q = q ;

    mux_behavioral m1(.a(old_q),.sel(load),.b(d),.y(new_q));

    always @(posedge clk) begin
        if(rst)
            q <= 1'b0;
        else 
            q <= new_q;
     
    end

endmodule
