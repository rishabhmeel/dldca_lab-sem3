    module bhavesh_traffic_light (
        input clk, rst_n,
        input ped_button,
        input tick_1hz,

        output [1:0] state_out,
        output [7:0] duration_out,
        output red, green, yellow
    );

        // TODO
        wire [1:0] state;
        wire [1:0] next_state;
        wire [7:0] remaining;
        wire do_transition;
        wire [7:0] remaining_next;
        wire ped_request;

        traffic_fsm fsm(
            .clk(clk),
            .rst_n(rst_n),
            .ped_button(ped_button),
            .remaining_next(remaining_next),
            .do_transition(do_transition),
            .current_state(state),
            .next_state(next_state),
            .remaining(remaining),
            .ped_request(ped_request)
            );
        
        duration_datapath asd(
            .current_state(state),
            .next_state(next_state),
            .remaining(remaining),
            .tick_1hz(tick_1hz),
            .ped_button(ped_button),
            .ped_request(ped_request),
            .remaining_next(remaining_next),
            .do_transition(do_transition)
        );

        output_decoder decoder(
            .state(state),
            .red(red),
            .green(green),
            .yellow(yellow)
        );

        assign state_out = state;
        assign duration_out = remaining;


    endmodule


    // -----------------------------------------------------------
    // CONTROL
    // -----------------------------------------------------------
    module traffic_fsm (
        input clk, rst_n,
        input ped_button,
        input [7:0] remaining_next,
        input do_transition,

        output reg [1:0] current_state,
        output    [1:0] next_state,
        output reg [7:0] remaining,
        output reg       ped_request
    );

        localparam GREEN = 2'b00, YELLOW = 2'b01, RED = 2'b10;

        // next-state logic (purely combinational)
        // TODO
    
        assign next_state = (current_state == GREEN) ? YELLOW : (current_state == YELLOW) ? RED : (current_state ==  RED) ? GREEN : GREEN ;
    
        // TODO
        always @(posedge clk or negedge rst_n) begin
            if(!rst_n) begin
                current_state <= GREEN;
                remaining <= 8'd25;
                ped_request <= 1'b0;
            end
            else begin
                if (ped_button)
                    ped_request <= 1'b1;
                
                remaining <= remaining_next;

                if(do_transition) begin
                    current_state <= next_state;
                    if(next_state == GREEN)
                        ped_request <= 1'b0;
                end
            end

        end

    endmodule


    // -----------------------------------------------------------
    // DATAPATH
    // -----------------------------------------------------------
    module duration_datapath (
        input [1:0] current_state,
        input [1:0] next_state,
        input [7:0] remaining,
        input       tick_1hz,
        input       ped_button,
        input       ped_request,

        output reg [7:0] remaining_next,
        output reg       do_transition
    );

        localparam GREEN = 2'b00, YELLOW = 2'b01, RED = 2'b10;

        // TODO: update + modify
        always @(*) begin
            remaining_next = remaining;
            do_transition = 1'b0;
            if(tick_1hz) begin
                if(remaining>1) begin
                    remaining_next = remaining - 8'd1;
                end
                else begin
                    do_transition = 1'b1;
                    case (next_state)
                        GREEN: remaining_next = 8'd25;
                        YELLOW: remaining_next = 8'd5;
                        RED: remaining_next = ped_request ? 8'd40 : 8'd30;
                        default: remaining_next = 8'd25;
                    endcase
                end
            end

            if(ped_button && !ped_request && !do_transition)begin
                if(current_state == GREEN) begin
                    remaining_next = (remaining_next > 8'd10) ? remaining_next -8'd10 : 8'd1;
                end else if(current_state== RED) begin
                    remaining_next = remaining_next + 8'd10;
                end

            end
        end
    endmodule


    // -----------------------------------------------------------
    // OUTPUT DECODE
    // -----------------------------------------------------------
    module output_decoder (
        input [1:0] state,
        output red, green, yellow
    );

        localparam GREEN = 2'b00, YELLOW = 2'b01, RED = 2'b10;

        assign green  = (state == GREEN);
        assign yellow = (state == YELLOW);
        assign red    = (state == RED);

    endmodule