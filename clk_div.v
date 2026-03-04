`timescale 1ns / 1ps

module clk_div (
    input      clk,
    input      reset,
    output reg o_1khz
    
);
    reg [$clog2(100_000):0] counter_r;  // log2(100_000) = 16
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_r <= 0;
            o_1khz      <= 1'b0;
        end else begin
            if (counter_r == 99_999) begin
                counter_r   <= 0;
                o_1khz      <= 1'b1;
            end else begin
                counter_r <= counter_r + 1;
                o_1khz      <= 1'b0;
            end
        end
    end

endmodule