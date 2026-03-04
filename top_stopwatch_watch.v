`timescale 1ns / 1ps // branch test A

module top_stopwatch_watch (
    input        clk,
    input        reset,
    input [15:0] sw,         // up/down
    input        btn_r,      // i_run_stop
    input        btn_l,      // i_clear
    input        btn_u,
    input        btn_d,
    output [3:0] fnd_digit,
    output [7:0] fnd_data
);

    wire [13:0] w_counter;
    wire w_run_stop, w_clear, w_run_stop_t, w_clear_t,w_mode;
    wire o_btn_run_stop, o_btn_clear;
    wire [23:0] w_stopwatch_time;
    wire [23:0] w_watch_time;
    wire [7:0] w_fnd_data, w_fnd_data_t;
    wire [3:0] w_fnd_digit, w_fnd_digit_t;
    wire w_ad_hour, w_ad_min, w_ad_sec, w_sub_hour, w_sub_min, w_sub_sec;


    btn_debounce U_BD_RUNSTOP (
        .clk    (clk),
        .reset  (reset),
        .i_btn  (btn_r),
        .o_btn  (o_btn_run_stop)
    );
    btn_debounce U_BD_CLEAR (
        .clk    (clk),
        .reset  (reset),
        .i_btn  (btn_l),
        .o_btn  (o_btn_clear)
    );
    btn_debounce U_BD_BTN_U (
        .clk    (clk),
        .reset  (reset),
        .i_btn  (btn_u),
        .o_btn  (o_btn_u)
    );
    btn_debounce U_BD_BTN_D (
        .clk    (clk),
        .reset  (reset),
        .i_btn  (btn_d),
        .o_btn  (o_btn_d)
    );

    control_unit U_CONTROL_UNIT (
        .clk         (clk),
        .reset       (reset),
        .sw_1        (sw[1]),
        .i_mode      (sw[0]),
        .i_run_stop  (o_btn_run_stop),
        .i_clear     (o_btn_clear),
        .o_mode      (w_mode),
        .o_run_stop  (w_run_stop),
        .o_clear     (w_clear),
        .o_run_stop_t(w_run_stop_t),
        .o_clear_t   (w_clear_t)
    );

    stopwatch_datapath U_STOPWATCH_DATAPATH (
        .clk        (clk),
        .reset      (reset),
        .mode       (w_mode),
        .clear      (w_clear),
        .run_stop   (w_run_stop),
        .msec       (w_stopwatch_time[6:0]),
        .sec        (w_stopwatch_time[12:7]),
        .min        (w_stopwatch_time[18:13]),
        .hour       (w_stopwatch_time[23:19])
    );
    watch_datapath U_WATCH_DATAPATH (
        .clk            (clk),
        .reset          (reset),
        .t_clear        (w_clear_t),
        .t_run_stop     (w_run_stop_t),
        .btn_u          (o_btn_u),
        .btn_d          (o_btn_d),
        .sw_15          (sw[15]),
        .sw_14          (sw[14]),
        .sw_13          (sw[13]),
        .t_msec         (w_watch_time[6:0]),
        .t_sec          (w_watch_time[12:7]),
        .t_min          (w_watch_time[18:13]),
        .t_hour         (w_watch_time[23:19]) 
    );

    fnd_controller U_FND_CNTL_0 (
        .clk        (clk),
        .reset      (reset),
        .sel_display(sw[2]),
        .fnd_in_data(w_stopwatch_time),
        .fnd_digit  (w_fnd_digit),
        .fnd_data   (w_fnd_data)
    );
    watch_fnd_controller U_FND_CNTL_1 (
        .clk          (clk),
        .reset        (reset),
        .sel_display  (sw[2]),
        .fnd_in_data  (w_watch_time),
        .fnd_digit_t  (w_fnd_digit_t),
        .fnd_data_t   (w_fnd_data_t)
    );
    mux_2x1_mode #(
        .IN_DATA(4),
        .OUT_DATA(4)
    ) U_MUX_DIGIT(
        .sel    (sw[1]),
        .i_sel0 (w_fnd_digit),
        .i_sel1 (w_fnd_digit_t),
        .o_mux  (fnd_digit)
    );
    mux_2x1_mode #(
        .IN_DATA(8),
        .OUT_DATA(8)
    ) U_MUX_DATA(
        .sel    (sw[1]),
        .i_sel0 (w_fnd_data),
        .i_sel1 (w_fnd_data_t),
        .o_mux  (fnd_data)
    );

endmodule
