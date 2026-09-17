// TODO: 2-3 sentence written justification goes here.
// Why is `running` a reg? Why is the carry out of sec_ones naturally a
// wire, even though it's computed from values that are themselves regs?

module stopwatch (
    input  wire clk,
    input  wire rst,
    input  wire start_stop,   // one clock-cycle pulse per "button press"
    output reg [3:0] sec_ones,
    output reg [3:0] sec_tens,
    output reg [3:0] min_ones,
    output reg [3:0] min_tens,
    output wire tick_out       // exposes tick_gen's tick for the testbench;
                                // a real stopwatch chip wouldn't need this pin
);
    // Instantiate tick_gen here. Use a small LIMIT (e.g. 4) so the
    // testbench doesn't have to wait forever. Connect its tick output to
    // both your internal logic and to tick_out above.

    // running: a reg that toggles every time start_stop pulses high.
    // This is the only piece of state that decides whether anything
    // else in this module is allowed to change.

    // Combinational logic: for each digit, decide (a) whether it should
    // roll over back to 0 this tick, and (b) whether it should carry
    // into the next digit. sec_ones rolls over at 10 (0-9) and carries
    // into sec_tens; sec_tens rolls over at 6 (seconds only go 0-59) and
    // carries into min_ones; min_ones rolls over at 10 and carries into
    // min_tens; min_tens rolls over at 6, wrapping the whole stopwatch
    // back to 00:00.
    //
    // Sequential logic: on posedge clk, if rst is high, zero everything.
    // Otherwise, if running and tick, apply the next values you computed
    // combinationally above. If not running, or no tick this cycle, hold.
    wire tick;
    reg  running;

    tick_gen #(.LIMIT(4)) tg (
        .clk(clk),
        .rst(rst),
        .tick(tick)
    );

    assign tick_out = tick;

    always @(posedge clk) begin
        if (rst)
            running <= 1'b0;
        else if (start_stop)
            running <= ~running;
    end

    reg [3:0] sec_ones_next;
    wire sec_ones_carry;
    reg [3:0] sec_tens_next;
    wire sec_tens_carry;
    reg [3:0] min_ones_next;
    wire min_ones_carry;
    reg [3:0] min_tens_next;
    wire min_tens_carry;

    assign sec_ones_carry = (sec_ones == 4'd9 );
    assign sec_tens_carry = (sec_tens == 4'd5 );
    assign min_ones_carry = (min_ones == 4'd9 );
    assign min_tens_carry = (min_tens == 4'd5 );

    always @(*) begin
        sec_ones_next = sec_ones;
        sec_tens_next = sec_tens;
        min_ones_next = min_ones;
        min_tens_next = min_tens;
        if(tick && running) begin
            if(sec_ones_carry) begin
                sec_ones_next = 4'd0;
                if(sec_tens_carry) begin
                    sec_tens_next = 4'd0;
                    if(min_ones_carry) begin
                        min_ones_next = 4'd0;
                        if(min_tens_carry) begin
                            min_tens_next = 4'd0;
                        end else begin
                            min_tens_next = min_tens + 4'd1;
                        end
                    end else begin
                        min_ones_next = min_ones +4'd1;
                    end
                end else begin
                    sec_tens_next = sec_tens + 4'd1;
                end
            end else begin
                sec_ones_next = sec_ones + 4'd1;
            end
        end
        
    end


    always @(posedge clk) begin
        if(rst) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else begin
            sec_ones <= sec_ones_next;
            sec_tens <= sec_tens_next;
            min_ones <= min_ones_next;
            min_tens <= min_tens_next;
        end
    end

    // always @(posedge clk) begin
    //     if(rst) begin
    //         sec_ones <= 4'd0;
    //         sec_tens <= 4'd0;
    //         min_ones <= 4'd0;
    //         min_tens <= 4'd0;
    //     end else if(tick && running) begin
    //         if(sec_ones == 4'd9)begin
    //             sec_ones <= 4'd0;
    //             if(sec_tens == 4'd5) begin
    //                 sec_tens <= 4'd0;
    //                 if(min_ones == 4'd9) begin
    //                     min_ones <= 4'd0;
    //                     if(min_tens == 4'd5) begin
    //                         min_tens <= 4'd0;
    //                     end else begin
    //                         min_tens <= min_tens +4'd1;
    //                     end
    //                 end else begin
    //                     min_ones <= min_ones + 4'd1;
    //                 end
    //             end else begin
    //                 sec_tens <= sec_tens + 4'd1;
    //             end
    //         end else begin
    //             sec_ones <= sec_ones + 4'd1;
    //         end
    //     end

    // end
    
    

endmodule
