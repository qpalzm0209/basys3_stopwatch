module tick_counter #(
    parameter integer BIT_WIDTH = 7,
    parameter integer TIME      = 100
) (
    input                      clk,
    input                      reset,
    input                      i_tick,
    input                      mode,      // 0:UP, 1:DOWN 
    input                      clear,
    input                      run_stop,
    input                      btn_u,
    input                      btn_d,
    input                      sw,        
    output     [BIT_WIDTH-1:0] o_count,
    output reg                 o_tick
);

    reg [BIT_WIDTH-1:0] counter_reg, counter_next;

    assign o_count = counter_reg;

    // state register
    always @(posedge clk or posedge reset) begin
        if (reset || clear) begin
            counter_reg <= {BIT_WIDTH{1'b0}};
        end else begin
            counter_reg <= counter_next;
        end
    end

    // next-state + tick pulse
    always @(*) begin
        counter_next = counter_reg;
        o_tick       = 1'b0;

    // time up & down
        if (sw) begin
            if (btn_u && !btn_d) begin
                // UP 
                if (counter_reg == (TIME - 1))
                    counter_next = {BIT_WIDTH{1'b0}};
                else
                    counter_next = counter_reg + 1'b1;

            end else if (btn_d && !btn_u) begin
                // DOWN
                if (counter_reg == 0)
                    counter_next = TIME - 1;
                else
                    counter_next = counter_reg - 1'b1;
            end
        end

    // count clk
        else if (i_tick && run_stop) begin
            if (mode) begin
                // DOWN
                if (counter_reg == 0) begin
                    counter_next = TIME - 1;
                    o_tick       = 1'b1;
                end else begin
                    counter_next = counter_reg - 1'b1;
                end
            end else begin
                // UP
                if (counter_reg == (TIME - 1)) begin
                    counter_next = {BIT_WIDTH{1'b0}};
                    o_tick       = 1'b1;
                end else begin
                    counter_next = counter_reg + 1'b1;
                end
            end
        end
    end

endmodule