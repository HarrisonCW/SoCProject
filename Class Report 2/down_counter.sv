`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2023 12:02:31 PM
// Design Name: 
// Module Name: down_counter
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


module down_counter(
    input clk,
    input en,
    input stop,
    output countdone,
    output [6:0] sseg,
    output [7:0] an,
    );
    
    logic [4:0]randint;
    
    assign randint = urandom(2,15);
    
    always @(posedge clk or posedge stop)
        begin
            if(reset==1)
                one_second_counter <= 0;
             
            else begin
                if(one_second_counter>=99999999) 
                     one_second_counter <= 0;
                else
                    one_second_counter <= one_second_counter + 1;
            end
        end
     
    assign one_second_enable = (one_second_counter==99999999)?1:0;
    
    
    always @(posedge clk)
    begin
        if(one_second_enable)
            randint  <= randint - 1'b1;
        else
            randint <= randint;
    end
    
    always @(posedge clk)
    begin
        if(randint == 0)
            countdone = 1'b1; 
        else
            randint <= randint;
    end
    
endmodule
