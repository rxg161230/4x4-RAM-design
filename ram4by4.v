`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:16:59 09/02/2017 
// Design Name: 
// Module Name:    ram4by4 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module decoder(output reg [3:0]DO,input [1:0]DI);
	always @(DI)
//Based on DI,DO is selected	
	case (DI)                         
		2'b00:DO<=4'b1000;
		2'b01:DO<=4'b0100;
		2'b10:DO<=4'b0010;
		2'b11:DO<=4'b0001;
	endcase
endmodule
 //Memory unit module with I as input and O as output
module ram4by4(input cs, input clk, input RW,input [1:0]DI,input [3:0]I, output reg [3:0]O);
	wire [3:0]DO;
	reg [15:0]D;
	integer i;
	decoder dec(DO,DI);
	
//function that defines dff.
		function dff;
			input x,reset,wr;
			begin
			   if(reset==0)
				dff=0;
				if(wr) dff=x;
			end
		endfunction
//Change in WRclk or data input or decoder input triggers the process of writing and reading
		always @(cs or RW or DI or I)
			begin
		#10	if (~cs&RW&DO[0])                   
				begin
					D[0]=dff(I[0],~cs&RW&DO[0],clk);
					D[1]=dff(I[1],~cs&RW&DO[0],clk);
					D[2]=dff(I[2],~cs&RW&DO[0],clk);
					D[3]=dff(I[3],~cs&RW&DO[0],clk);
				end
				else if (~cs&RW&DO[1])
				begin
					D[4]=dff(I[0],~cs&RW&DO[1],clk);
					D[5]=dff(I[1],~cs&RW&DO[1],clk);
					D[6]=dff(I[2],~cs&RW&DO[1],clk);
					D[7]=dff(I[3],~cs&RW&DO[1],clk);
				end
				else if (~cs&RW&DO[2])
				begin
					D[8]=dff(I[0],~cs&RW&DO[2],clk);
					D[9]=dff(I[1],~cs&RW&DO[2],clk);
					D[10]=dff(I[2],~cs&RW&DO[2],clk);
					D[11]=dff(I[3],~cs&RW&DO[2],clk);
				end
				else if (~cs&RW&DO[3])
				begin
					D[12]=dff(I[0],~cs&RW&DO[3],clk);
					D[13]=dff(I[1],~cs&RW&DO[3],clk);
					D[14]=dff(I[2],~cs&RW&DO[3],clk);
					D[15]=dff(I[3],~cs&RW&DO[3],clk);
				end
				else if (~RW)
				begin
					for (i=0;i<4;i=i+1)				
						O[i]=(((D[i]&DO[0])|(D[i+4]&DO[1])|(D[i+8]&DO[2])|(D[i+12]&DO[3])));
				end
	end
endmodule
