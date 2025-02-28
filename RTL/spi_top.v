`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2025 10:06:55 PM
// Design Name: 
// Module Name: spi_top
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


module spi_top(clk, cpol, cpha, start, p_dat, rcvd_p_dat);
    input clk, cpol, cpha, start;
    input [7:0]p_dat;
    output [7:0]rcvd_p_dat;

    wire mosi, sclk, cs;
    wire [2:0]mode;
    
    spigen spg(clk, cpol, cpha, start, p_dat, mosi, sclk, cs, mode);
    spiperi spp(sclk, mosi, mode, cs, rcvd_p_dat);
endmodule
