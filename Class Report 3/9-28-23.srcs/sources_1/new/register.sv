`timescale 1ns / 1ps

module register #(N = 16)(
    input  logic clk,
    input  logic rst,
    input  logic [N-1:0] in,
    output logic [N-1:0] out
    );
    
    always_ff @(posedge(clk), posedge(rst)) begin
        if(rst)
            out <= 0;
        else
            out <= in;
    end
endmodule
