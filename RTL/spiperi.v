`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2025 09:00:32 PM
// Design Name: 
// Module Name: spiperi
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


module spiperi(sclk, mosi, mode, cs, rcvd_p_dat);
    input sclk, mosi, cs;
    input [1:0] mode = 0;
    output [7:0]rcvd_p_dat;
    reg [7:0]mosi_p_dat;
    reg [3:0]count;
    //mode 0 and mode 3 logic
    always @(posedge sclk)begin
        if((cs == 0) && (mode == 0 || mode == 3))begin
            count <= 0;
            mosi_p_dat <= 0;
            if(count <8)begin
                mosi_p_dat <= {mosi_p_dat[6:0],mosi};
                count <= count + 1'b1;
            end
            else begin
                count <= 0;
            end
        end
    end
    //mode 1 and mode 2 logic
    always @(negedge sclk)begin
        if((cs == 0) && (mode == 1 || mode == 2))begin
            count <= 0;
            mosi_p_dat <= 0;
            if(count <8)begin
                mosi_p_dat <= {mosi_p_dat[6:0],mosi};
                count <= count + 1'b1;
            end
            else begin
                count <= 0;
            end
        end
    end
       
    assign rcvd_p_dat = mosi_p_dat;
endmodule
