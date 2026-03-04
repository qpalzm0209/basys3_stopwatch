`timescale 1ns / 1ps

module watch_fnd_controller (
    input clk,
    input reset,
    input sel_display,
    input [23:0] fnd_in_data,
    output [3:0] fnd_digit_t,
    output [7:0] fnd_data_t
);
    wire [3:0] w_digit_msec_1, w_digit_msec_10;
    wire [3:0] w_digit_sec_1, w_digit_sec_10;
    wire [3:0] w_digit_min_1, w_digit_min_10;
    wire [3:0] w_digit_hour_1, w_digit_hour_10;
    wire [3:0] w_mux_hour_min_out, w_mux_sec_msec_out;
    wire [3:0] w_mux_2x1_out;
    wire [2:0] w_digit_sel;
    wire w_1khz;
    wire w_dot_onoff;

    //hour
    digit_splitter #(
        .BIT_WIDTH(5)
    ) U_HOUR_DS (
        .in_data (fnd_in_data[23:19]),
        .digit_1 (w_digit_hour_1),
        .digit_10(w_digit_hour_10)
    );
    //min
    digit_splitter #(
        .BIT_WIDTH(6)
    ) U_MIN_DS (
        .in_data (fnd_in_data[18:13]),
        .digit_1 (w_digit_min_1),
        .digit_10(w_digit_min_10)
    );
    //sec
    digit_splitter #(
        .BIT_WIDTH(6)
    ) U_SEC_DS (
        .in_data (fnd_in_data[12:7]),
        .digit_1 (w_digit_sec_1),
        .digit_10(w_digit_sec_10)
    );
    //msec
    digit_splitter #(
        .BIT_WIDTH(6)
    ) U_MSEC_DS (
        .in_data (fnd_in_data[6:0]),
        .digit_1 (w_digit_msec_1),
        .digit_10(w_digit_msec_10)
    );
    dot_onoff_comp U_DOT_COMP (
        .msec       (fnd_in_data[6:0]),
        .dot_onoff  (w_dot_onoff)
    );
    mux_8x1 U_MUX_HOUR_MIN (
        .sel           (w_digit_sel),
        .digit_1       (w_digit_min_1),
        .digit_10      (w_digit_min_10),
        .digit_100     (w_digit_hour_1),
        .digit_1000    (w_digit_hour_10),
        .digit_dot_1   (4'hf),
        .digit_dot_10  (4'hf),
        .digit_dot_100 ({3'b111, w_dot_onoff}),
        .digit_dot_1000(4'hf),
        .mux_out       (w_mux_hour_min_out)
    );
    mux_8x1 U_MUX_SEC_MSEC (
        .sel           (w_digit_sel),
        .digit_1       (w_digit_msec_1),
        .digit_10      (w_digit_msec_10),
        .digit_100     (w_digit_sec_1),
        .digit_1000    (w_digit_sec_10),
        .digit_dot_1   (4'hf),
        .digit_dot_10  (4'hf),
        .digit_dot_100 ({3'b111, w_dot_onoff}),
        .digit_dot_1000(4'hf),
        .mux_out       (w_mux_sec_msec_out)
    );
    mux_2x1 U_MUX_2x1 (
        .sel   (sel_display),
        .i_sel0(w_mux_sec_msec_out),
        .i_sel1(w_mux_hour_min_out),
        .o_mux (w_mux_2x1_out)
    );
    clk_div U_CLK_DIV (
        .clk   (clk),
        .reset (reset),
        .o_1khz(w_1khz)
    );
    counter_8 U_COUNTER_8 (
        .clk      (w_1khz),
        .reset    (reset),
        .digit_sel(w_digit_sel)
    );
    decoder_2x4 U_DECODER_2x4 (
        .digit_sel(w_digit_sel[1:0]),
        .fnd_digit (fnd_digit_t)        //
    );
    bcd U_BCD (
        .bcd     (w_mux_2x1_out),
        .fnd_data(fnd_data_t)           //
    );

endmodule