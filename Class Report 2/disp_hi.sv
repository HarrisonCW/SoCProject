`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2023 07:47:38 PM
// Design Name: 
// Module Name: disp_hi
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


module disp_hi(
    input clk,
    input BTNC,
    input BTNR,
    output [6:0] sseg,
    output [7:0] an,
    output ready
    );
    
    parameter an0  = 8'b11111110;
    parameter an1  = 8'b11111101;
    
    
    
    assign ready = BTNR;
    
endmodule
