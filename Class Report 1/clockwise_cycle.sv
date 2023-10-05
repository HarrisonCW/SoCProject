`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2023 04:26:18 PM
// Design Name: 
// Module Name: clockwise_cycle
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clockwise_cycle(
    input logic clk,
    input logic rst,
    input logic en,
    input logic sel,
    
    output logic [7:0] an,
    output logic [7:0] sseg
    );
    
    parameter top  = 8'b10011100;
    parameter bot  = 8'b10100011;
    parameter none = 8'b11111111;
    
    parameter anOff= 8'b11111111;
    parameter an0  = 8'b11111110;
    parameter an1  = 8'b11111101;
    parameter an2  = 8'b11111011;
    parameter an3  = 8'b11110111;
    
    logic [2:0] state;
    
    count_n#(.N(28), .M(3)) counter(
        .clk(clk),
        .rst(rst),
        .en(en),
        .up(sel),
        
        .count(state)
    );
    
    always_comb
    
    if(en)
        case(state)
            0:begin
                sseg = top;
                an   = an0;
             end
             1:begin
                sseg = top;
                an   = an1;
             end
             2:begin
                sseg = top;
                an   = an2;
             end
             3:begin
                sseg = top;
                an   = an3;
             end
             4:begin
                sseg = bot;
                an   = an3;
             end
             5:begin
                sseg = bot;
                an   = an2;
             end
             6:begin
                sseg = bot;
                an   = an1;
             end
             7:begin
                sseg = bot;
                an   = an0;
             end
        endcase
    else begin
        sseg = none;
        an   = anOff;
    end
 
endmodule
