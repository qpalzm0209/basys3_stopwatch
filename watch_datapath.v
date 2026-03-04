`timescale 1ns / 1ps

module watch_datapath(
    input   clk,
    input   reset,
    input   t_clear,
    input   t_run_stop,
    input   btn_u,
    input   btn_d,
    input   sw_15,
    input   sw_14,
    input   sw_13,
    output  [6:0] t_msec,
    output  [5:0] t_sec,
    output  [5:0] t_min,
    output  [4:0] t_hour
);

    wire w_tick_100hz, w_sec_tick, w_min_tick, w_hour_tick;

    tick_counter #(
        .BIT_WIDTH(5),
        .TIME(24)
    ) hour_counter(
        .clk        (clk),
        .reset      (reset),
        .i_tick     (w_hour_tick),
        .mode       (1'b0),
        .clear      (t_clear),
        .run_stop   (t_run_stop),
        .btn_u      (btn_u),
        .btn_d      (btn_d),
        .sw         (sw_15),   
        .o_count    (t_hour),
        .o_tick     ()
    );
    tick_counter #(
        .BIT_WIDTH(6),
        .TIME(60)
    ) min_counter(
        .clk        (clk),
        .reset      (reset),
        .i_tick     (w_min_tick),
        .mode       (1'b0),
        .clear      (t_clear),
        .run_stop   (t_run_stop),
        .btn_u      (btn_u),
        .btn_d      (btn_d),
        .sw         (sw_14),
        .o_count    (t_min),
        .o_tick     (w_hour_tick)
    );
    tick_counter #(
        .BIT_WIDTH(6),
        .TIME(60)
    ) sec_counter(
        .clk        (clk),
        .reset      (reset),
        .i_tick     (w_sec_tick),
        .mode       (1'b0),
        .clear      (t_clear),
        .run_stop   (t_run_stop),
        .btn_u      (btn_u),
        .btn_d      (btn_d),
        .sw         (sw_13),
        .o_count    (t_sec),
        .o_tick     (w_min_tick)
    );
    tick_counter #(
        .BIT_WIDTH(7),
        .TIME(100)
    ) msec_counter(
        .clk        (clk),
        .reset      (reset),
        .i_tick     (w_tick_100hz),
        .mode       (1'b0),
        .clear      (t_clear),
        .run_stop   (t_run_stop),
        .btn_u      (1'b0),
        .btn_d      (1'b0),
        .sw         (1'b0),
        .o_count    (t_msec),
        .o_tick     (w_sec_tick)
    );
    tick_gen_100hz U_tick_gne_100hz (
        .clk            (clk),
        .reset          (reset),
        .i_run_stop     (t_run_stop),
        .o_tick_100hz   (w_tick_100hz)
    );

    


endmodule

