`timescale 1ns / 1ps

module time_adder(
    input         clk,
    input         reset,
    input         btn_u,
    input         btn_d,
    input         sw_15,
    input         sw_14,
    input         sw_13,
    output reg    ad_hour,
    output reg    ad_min,
    output reg    ad_sec,
    output reg    sub_hour,
    output reg    sub_min,
    output reg    sub_sec
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin 
            ad_hour  <= 1'b0;
            ad_min   <= 1'b0;
            ad_sec   <= 1'b0;
            sub_hour <= 1'b0;
            sub_min  <= 1'b0;
            sub_sec  <= 1'b0;
        end else begin 
            ad_hour  <= 1'b0;
            ad_min   <= 1'b0;
            ad_sec   <= 1'b0;
            sub_hour <= 1'b0;
            sub_min  <= 1'b0;
            sub_sec  <= 1'b0;

            // add
            if (btn_u && !btn_d) begin
                if (sw_15) ad_hour <= 1'b1;
                if (sw_14) ad_min  <= 1'b1;
                if (sw_13) ad_sec  <= 1'b1;
            end

            // sub
            if (btn_d && !btn_u) begin
                if (sw_15) sub_hour <= 1'b1;
                if (sw_14) sub_min  <= 1'b1;
                if (sw_13) sub_sec  <= 1'b1;
            end
        end
    end

endmodule