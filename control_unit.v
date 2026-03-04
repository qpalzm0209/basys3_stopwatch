`timescale 1ns / 1ps

module control_unit(
        input   clk,
        input   reset,
        input   sw_1,
        input   i_mode,
        input   i_run_stop,
        input   i_clear,
        output  o_mode,
        output  reg o_run_stop,
        output  reg o_clear,
        output  reg o_run_stop_t,
        output  reg o_clear_t
    );

    localparam stop  = 2'b00;
    localparam run   = 2'b01;
    localparam clear = 2'b10;

    // reg variable
    reg [1:0]   current_st,   next_st;
    reg [1:0]   current_st_t, next_st_t;

    assign o_mode = i_mode;

    // ✅ 입력 게이팅(내부 신호만 추가, 기존 포트/변수명은 그대로)
    wire i_run_stop_sw = (sw_1 == 1'b0) ? i_run_stop : 1'b0;
    wire i_clear_sw    = (sw_1 == 1'b0) ? i_clear    : 1'b0;

    wire i_run_stop_tg = (sw_1 == 1'b1) ? i_run_stop : 1'b0;
    wire i_clear_tg    = (sw_1 == 1'b1) ? i_clear    : 1'b0;

    // state register SL (✅ 둘 다 항상 업데이트 = 백그라운드 진행)
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            current_st   <= stop;
            current_st_t <= stop;
        end else begin
            current_st   <= next_st;
            current_st_t <= next_st_t;
        end
    end

    // next CL (✅ 두 FSM 모두 항상 계산)
    always @(*) begin
        // 기본값
        next_st       = current_st;
        next_st_t     = current_st_t;

        o_run_stop    = 1'b0;
        o_clear       = 1'b0;
        o_run_stop_t  = 1'b0;
        o_clear_t     = 1'b0;

        // -------------------------
        // 스톱워치 FSM (항상 진행)
        // 버튼은 sw_1=0일 때만 반영(i_run_stop_sw / i_clear_sw)
        // -------------------------
        case (current_st)
            stop: begin
                if      (i_run_stop_sw) next_st = run;
                else if (i_clear_sw)    next_st = clear;
            end
            run: begin
                o_run_stop = 1'b1;
                if (i_run_stop_sw) next_st = stop;
            end
            clear: begin
                o_clear = 1'b1;
                next_st = stop;
            end
            default: next_st = stop;
        endcase

        // -------------------------
        // 시계 FSM (항상 진행)
        // 버튼은 sw_1=1일 때만 반영(i_run_stop_tg / i_clear_tg)
        // -------------------------
        case (current_st_t)
            stop: begin
                if      (i_run_stop_tg) next_st_t = run;
                else if (i_clear_tg)    next_st_t = clear;
            end
            run: begin
                o_run_stop_t = 1'b1;
                if (i_run_stop_tg) next_st_t = stop;
            end
            clear: begin
                o_clear_t = 1'b1;
                next_st_t = stop;
            end
            default: next_st_t = stop;
        endcase
    end

endmodule