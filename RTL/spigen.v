`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2025 02:48:50 PM
// Design Name: 
// Module Name: spigen
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


module spigen(clk, cpol, cpha, start, p_dat, mosi, sclk, cs, mode);
    input clk, cpol, cpha, start;
    input [7:0]p_dat;
    output[1:0]mode;
    output reg mosi = 0;
    output reg cs = 1;
    output sclk;
    
    reg [4:0]spi_edges = 0; 
    reg [1:0]clk_cnt = 0;
    reg spi_l, spi_t = 0;
    reg buf_clk = 0;
    reg ready = 1;
    reg buf_start = 0;
    reg [1:0]count = 0; 
    reg [2:0]bit_cnt = 3'b111;
    reg [2:0]state = 0;
    //start signal buffer
    always @(posedge clk)begin
        buf_start <= start;
    end
    //cpol based sclk generation logic
    always @(posedge clk)begin
        if(buf_start == 1'b1)begin
            ready <= 1'b0;
            spi_edges <= 16;
            buf_clk <= cpol;
        end
        else if(spi_edges > 0)begin
            spi_l <= 1'b0;
            spi_t <= 1'b0;
            
            if(clk_cnt == 1)begin
                spi_l <= 1'b1;
                buf_clk <= ~buf_clk;
                spi_edges <= spi_edges - 1;
                clk_cnt <= clk_cnt + 1'b1;
            end
            else if(clk_cnt == 3)begin
                spi_t <= 1'b1;
                buf_clk <= ~buf_clk;
                spi_edges <= spi_edges - 1;
                clk_cnt <= clk_cnt + 1;
            end
            else begin
                clk_cnt <= clk_cnt + 1;
            end
        end
        else begin
            ready <= 1'b1;
            spi_l <= 1'b0;
            spi_t <= 1'b0;
            buf_clk <= cpol;
        end
    end
    
    assign sclk = buf_clk;
    //cpha based sampling logic
    always @(posedge clk)begin
        case(state)
            0 : begin
                if(start)begin
                    if(!cpha)begin
                        state <= 1;
                        cs <= 1'b0;
                    end
                    else begin
                        state <= 3;
                        cs <= 1'b0;
                    end
                end
                else begin
                    state <= 0;
                end
            end
            1 : begin
                if(count < 3)begin
                    mosi <= p_dat[bit_cnt];
                    count <= count + 1;
                    state <= 1;
                end
                else begin
                    count <= 0;
                    if(bit_cnt != 0)begin
                        bit_cnt <= bit_cnt - 1;
                        state <= 1;
                    end
                    else
                        state <= 2;
                end
            end
            2 : begin
                cs <= 1'b1;
                bit_cnt <= 3'b111;
                mosi <= 1'b0;
                state <= 0;
            end
            3: begin                                //delay generating states
                state <= 4;
            end
            4: begin
                state <= 1;
            end
        endcase
    end
    
    assign mode = {cpol,cpha};
endmodule
