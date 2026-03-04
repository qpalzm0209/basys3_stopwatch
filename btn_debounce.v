`timescale 1ns / 1ps

module btn_debounce(
    input   clk,
    input   reset,
    input   i_btn,
    output  o_btn
);
    reg [7:0]   q_reg, q_next;
    wire debounce;

    always @(posedge clk, posedge reset) begin
        if (reset)  begin q_reg <= 0;       end
        else        begin q_reg <= q_next;  end
    end

    always @(*)     begin q_next = {i_btn, q_reg[7:1]}; end

    // debounce, 8input and
    assign debounce =& q_reg;

    reg edge_reg;
    //edge detection
    always@(posedge clk, posedge reset) begin
        if (reset)  begin edge_reg <= 1'b0;     end
        else        begin edge_reg <= debounce; end            
    end

    assign o_btn = debounce & (~edge_reg);


endmodule