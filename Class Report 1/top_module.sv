`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2023 09:31:44 PM
// Design Name: 
// Module Name: top_module
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


module top_module(
    input logic clk, rst, en, sel,
    output logic [7:0]sseg,
    output logic [7:0]an
    );
    
   
    clockwise_cycle cycle(
        .clk(clk),
        .rst(rst),
        .en(en),
        .sel(sel),
        
        .sseg(sseg),
        .an(an)
    );
    
    
    
    
    
    
    
    
endmodule
