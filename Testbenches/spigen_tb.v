`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2025 03:12:07 PM
// Design Name: 
// Module Name: spigen_tb
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


module spitop_tb;
    reg clk, cpol, cpha, start;
    reg [7:0]p_dat;
    wire [7:0]rcvd_p_dat;
    
    spi_top dut(clk, cpol, cpha, start, p_dat, rcvd_p_dat);
    
    initial begin
        clk = 0;
        cpol = 0;
        cpha = 0;
        start = 0;
        p_dat = 8'b01010101;
    end
    
    initial begin
        forever begin
            #5 clk = ~clk;
        end
    end
    
    initial begin
        repeat(5)@(posedge clk);
        start = 1;
        repeat(1)@(posedge clk);
        start = 0;
    end
    initial begin      
        repeat(45)@(posedge clk);
        cpol = 1;
        cpha = 1;
        p_dat = 8'b01000010;
        start = 1;
        repeat(1)@(posedge clk);
        start = 0;
    end
endmodule
