`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2023 12:47:05 PM
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


module timer_ms(
    input clk, // 100 Mhz clock source 
    input reset, // reset
    //input en,
    input BTNL,
    output logic [7:0] an, // anode signals of the 7-segment LED display
    output logic [6:0] sseg// cathode patterns of the 7-segment LED display
    );
    
    logic [26:0] one_second_counter; // counter for generating 1 second clock enable
    logic one_second_enable;// one second enable for counting numbers
    logic [15:0] displayed_number; // counting number to be displayed
    logic [3:0] LED_BCD;
    logic [19:0] refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
             // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
    logic [1:0] LED_activating_counter; 
                 // count     0    ->  1  ->  2  ->  3
              // activates    LED1    LED2   LED3   LED4
             // and repeat
    
    parameter an0  = 8'b11111110;
    parameter an1  = 8'b11111101;
    parameter an2  = 8'b11111011;
    parameter an3  = 8'b11110111;
    
    logic stop = 1'b0;
    
    logic en = 1'b1;
    
    always @(posedge clk or posedge reset)
        if (en == 1'b1)
        begin
            if(reset==1)
                one_second_counter <= 0;
             
            else begin
                if(one_second_counter>=99999) 
                     one_second_counter <= 0;
                else
                    one_second_counter <= one_second_counter + 1;
            end
        end
     
    assign one_second_enable = (one_second_counter==99999)?1:0;
    
    always @(posedge clk or posedge reset or posedge BTNL)
    begin
        if(reset==1)
        begin
            displayed_number <= 0;
            stop <= 0;
        end
        else if(BTNL ==1)
            begin
                displayed_number <= displayed_number;
                stop <=1'b1;
            end
        
        else if(one_second_enable==1)
            if (stop==1)
                displayed_number <= displayed_number;
                
            else if (displayed_number == 1000)
                displayed_number <= displayed_number;
                
            else
                displayed_number <= displayed_number + 1;
    end
    
    
    always @(posedge clk or posedge reset)
    begin 
        if(reset==1)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end 
    assign LED_activating_counter = refresh_counter[19:18];
    // anode activating signals for 4 LEDs, digit period of 2.6ms
    // decoder to generate anode signals 
    always @(*)
    begin
        case(LED_activating_counter)
        2'b00: begin
            an = an3; 
            // activate LED1 and Deactivate LED2, LED3, LED4
            LED_BCD = displayed_number/1000;
            // the first digit of the 16-bit number
              end
        2'b01: begin
            an = an2; 
            // activate LED2 and Deactivate LED1, LED3, LED4
            LED_BCD = (displayed_number % 1000)/100;
            // the second digit of the 16-bit number
              end
        2'b10: begin
            an = an1; 
            // activate LED3 and Deactivate LED2, LED1, LED4
            LED_BCD = ((displayed_number % 1000)%100)/10;
            // the third digit of the 16-bit number
                end
        2'b11: begin
            an = an0; 
            // activate LED4 and Deactivate LED2, LED3, LED1
            LED_BCD = ((displayed_number % 1000)%100)%10;
            // the fourth digit of the 16-bit number    
               end
        endcase
    end
    // Cathode patterns of the 7-segment LED display 
    always @(*)
    begin
        case(LED_BCD)
        4'b0000: sseg = 7'b1000000; // "0"     
        4'b0001: sseg = 7'b1111001; // "1" 
        4'b0010: sseg = 7'b0100100; // "2" 
        4'b0011: sseg = 7'b0110000; // "3" 
        4'b0100: sseg = 7'b0011001; // "4" 
        4'b0101: sseg = 7'b0010010; // "5" 
        4'b0110: sseg = 7'b0000010; // "6" 
        4'b0111: sseg = 7'b1111000; // "7" 
        4'b1000: sseg = 7'b0000000; // "8"     
        4'b1001: sseg = 7'b0010000; // "9" 
        default: sseg = 7'b1000000; // "0"
        endcase
    end

endmodule
