module universal_shift_reg (
    input clk,
    input rst,
    input [1:0] mode,
    input serial_in,
    input [3:0] parallel_in,
    output [3:0] q
);
    // TODO: Implement the universal shift register.
    reg [3:0] shiftReg;

    assign q = shiftReg;

    always @(posedge clk) begin
        if(rst) 
            shiftReg <= 4'b0000;
        else 
            case (mode)
                2'b11: begin
                    shiftReg <= parallel_in;
                end
                2'b10: begin 
                    shiftReg <= {shiftReg[2:0],serial_in};
                end
                2'b01: begin
                    shiftReg <= {serial_in,shiftReg[3:1]};
                end
                default: begin
                // statements executed if select_signal matches nothing above
                    shiftReg <= shiftReg;
                end
            endcase
    end
endmodule