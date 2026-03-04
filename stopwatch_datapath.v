`timescale 1ns / 1ps


module stopwatch_datapath(
    input   clk,
    input   reset,
    input   mode,
    input   clear,
    input   run_stop,
    output  [6:0] msec,
    output  [5:0] sec,
    output  [5:0] min,
    output  [4:0] hour
);

    wire w_tick_100hz, w_sec_tick, w_min_tick, w_hour_tick;

    tick_counter #(
        .BIT_WIDTH(5),
        .TIME(24)
    ) hour_counter(
        .clk        (clk),
        .reset      (reset),
        .i_tick     (w_hour_tick),
        .mode       (mode),
        .clear      (clear),
        .run_stop   (run_stop),
        .o_count    (hour),
        .o_tick     ()
    );


    // tick_counter #(
    //     .BIT_WIDTH(5),
    //     .TIME(24)
    // ) hour_counter(
    //     .clk        (clk),
    //     .reset      (reset),
    //     .i_tick     (w_hour_tick),
    //     .mode       (mode),   
    //     .clear      (clear),
    //     .run_stop   (run_stop),
    //     .btn_u      (1'b0),
    //     .btn_d      (1'b0),
    //     .sw         (1'b0),        
    //     .o_count    (hour),
    //     .o_tick     (1'b0)
    // );

    tick_counter #(
        .BIT_WIDTH(6),
        .TIME(60)
    ) min_counter(
        .clk        (clk),
        .reset      (reset),
        .i_tick     (w_min_tick),
        .mode       (mode),
        .clear      (clear),
        .run_stop   (run_stop),
        .o_count    (min),
        .o_tick     (w_hour_tick)
    );
    tick_counter #(
        .BIT_WIDTH(6),
        .TIME(60)
    ) sec_counter(
        .clk        (clk),
        .reset      (reset),
        .i_tick     (w_sec_tick),
        .mode       (mode),
        .clear      (clear),
        .run_stop   (run_stop),
        .o_count    (sec),
        .o_tick     (w_min_tick)
    );
    tick_counter #(
        .BIT_WIDTH(7),
        .TIME(100)
    ) msec_counter(
        .clk        (clk),
        .reset      (reset),
        .i_tick     (w_tick_100hz),
        .mode       (mode),
        .clear      (clear),
        .run_stop   (run_stop),
        .o_count    (msec),
        .o_tick     (w_sec_tick)
    );
    tick_gen_100hz U_tick_gne_100hz (
        .clk            (clk),
        .reset          (reset),
        .i_run_stop     (run_stop),
        .o_tick_100hz   (w_tick_100hz)
    );

    


endmodule
