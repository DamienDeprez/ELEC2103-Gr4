
// --------------------------------------------------------------------
// Copyright (c) 2007 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//  Ver  :| Author            	  :| Mod. Date :| Changes Made:
//  V1.0 :| Johnny Fan			     :| 07/06/30  :| Initial Revision
//	 V2.0 :| Charlotte Frenkel      :| 14/08/03  :| Adaptation for ELEC2103 project 
//  V3.0 :| Ludovic Moreau			  :| 17/02/06  :| Adaptation for ELEC2103 project
// --------------------------------------------------------------------

module mtl_display_controller(
	// Host Side
	iCLK, 				// Input LCD control clock
	iRST_n, 				// Input system reset
	oNewFrame,			// Output signal being a pulse when a new frame of the LCD begins
	oEndFrame,			// Output signal being a pulse when a frame of the LCD ends
	// LCD Side
	oHD,					// Output LCD horizontal sync 
	oVD,					// Output LCD vertical sync 
	oLCD_R,				// Output LCD red color data 
	oLCD_G,           // Output LCD green color data  
	oLCD_B,            // Output LCD blue color data  
	
	iX1, iX2, iX3, iX4, iX5, iX6, iX7, iX8, iX9, iX10, iX11,
	iY1, iY2, iY3, iY4, iY5, iY6, iY7, iY8, iY9, iY10, iY11,
	
	player,
	screenType
);
						
//============================================================================
// PARAMETER declarations
//============================================================================

// All these parameters are given in the MTL datasheet, section 3.2,
// available in the project file folder
parameter H_LINE = 1056; 
parameter V_LINE = 525;
parameter Horizontal_Blank = 46;          // H_SYNC + H_Back_Porch
parameter Horizontal_Front_Porch = 210;
parameter Vertical_Blank = 23;      	   // V_SYNC + V_BACK_PORCH
parameter Vertical_Front_Porch = 22;

//===========================================================================
// PORT declarations
//===========================================================================

input				iCLK;   
input				iRST_n;
output			oNewFrame;
output			oEndFrame;
output			oHD;
output			oVD;
output [7:0]	oLCD_R;		
output [7:0]	oLCD_G;
output [7:0]	oLCD_B;

input [9:0] iX1, iX2, iX3, iX4, iX5, iX6, iX7, iX8, iX9, iX10, iX11;
input [8:0] iY1, iY2, iY3, iY4, iY5, iY6, iY7, iY8, iY9, iY10, iY11;

input player;

input [2:0] screenType;

//=============================================================================
// REG/WIRE declarations
//=============================================================================

reg  [10:0] x_cnt, x_correct;  
reg  [9:0]	y_cnt, y_correct; 
wire [7:0]	read_red;
wire [7:0]	read_green;
wire [7:0]	read_blue; 
wire			display_area, display_area_prev;
reg			mhd;
reg			mvd;

wire			q_rom_start, q_rom_wait, q_rom_loading;
wire [15:0]	address_start;
wire [14:0] address_wait;
wire [13:0] address_loading;

logic [7:0] counter;

logic isInCircle1, isInCircle2, isInCircle3, isInCircle4, isInCircle5;
logic isInCircle6, isInCircle7, isInCircle8, isInCircle9, isInCircle10,isInCircle11,isInCircle12,isInCircle13,isInCircle14,isInCircle15,isInCircle16;
logic isInCircle17,isInCircle18,isInCircle19,isInCircle20;
logic isInCircle21,isInCircle22,isInCircle23,isInCircle24;
logic isInRectangle2,isInRectangle3,isInRectangle4,isInRectangle5,isInRectangle6,isInRectangle7,isInRectangle8;

logic isInCircle25, inInCircle26;

logic isInRectangle9;
//=============================================================================
// Structural coding
//=============================================================================


//--- Assigning the right color data as a function -------------------------
//--- of the current pixel position ----------------------------------------
				
// This signal indicates the LCD active display area shifted back from
// 1 pixel in the x direction. This accounts for the 1-cycle delay
// in the sequential logic.

Start	start_img(
	.address(address_start),
	.clock(iCLK),
	.q(q_rom_start)
	);
	
Wait_Text wait_img(
	.address(address_wait),
	.clock(iCLK),
	.q(q_rom_wait)
	);
	
Loading_Text loading_img(
	.address(address_loading),
	.clock(iCLK),
	.q(q_rom_loading)
	);

assign	display_area = ((x_cnt>(Horizontal_Blank-2)&&
						(x_cnt<(H_LINE-Horizontal_Front_Porch-1))&&
						(y_cnt>(Vertical_Blank-1))&& 
						(y_cnt<(V_LINE-Vertical_Front_Porch))));

// This signal indicates the same LCD active display area, now shifted
// back from 2 pixels in the x direction, again for sequential delays.
assign	display_area_prev =	((x_cnt>(Horizontal_Blank-3)&&
						(x_cnt<(H_LINE-Horizontal_Front_Porch-2))&&
						(y_cnt>(Vertical_Blank-1))&& 
						(y_cnt<(V_LINE-Vertical_Front_Porch))));
						
						
assign address_start = (223 <= x_cnt && x_cnt <= 669) && (213 <= y_cnt && y_cnt < 313) ? ((x_cnt-223) + 446*(y_cnt-213)) : 16'b0;
assign address_wait = (204 <= x_cnt && x_cnt <= 688) && (239 <= y_cnt && y_cnt < 281) ? ((x_cnt-204) + 484*(y_cnt-239)) : 15'b0;
assign address_loading = (299 <= x_cnt && x_cnt <= 593) && (239 <= y_cnt && y_cnt < 281) ? ((x_cnt-299) + 294*(y_cnt-239)) : 14'b0;
						
assign x_correct = x_cnt;	
assign y_correct = y_cnt;
					
// Check if the current pixel position is in the rectangle
assign isInCircle1 = (iX1-x_correct)*(iX1-x_correct) + (iY1-y_correct)*(iY1-y_correct) < 169; // readius = 13
assign isInCircle2 = (iX2-x_correct)*(iX2-x_correct) + (iY2-y_correct)*(iY2-y_correct) < 169; // readius = 13
assign isInCircle3 = (iX3-x_correct)*(iX3-x_correct) + (iY3-y_correct)*(iY3-y_correct) < 169; // readius = 13
assign isInCircle4 = (iX4-x_correct)*(iX4-x_correct) + (iY4-y_correct)*(iY4-y_correct) < 169; // readius = 13
assign isInCircle5 = (iX5-x_correct)*(iX5-x_correct) + (iY5-y_correct)*(iY5-y_correct) < 169; // readius = 13
assign isInCircle6 = (iX6-x_correct)*(iX6-x_correct) + (iY6-y_correct)*(iY6-y_correct) < 169; // readius = 13
assign isInCircle7 = (iX7-x_correct)*(iX7-x_correct) + (iY7-y_correct)*(iY7-y_correct) < 169; // readius = 13
assign isInCircle8 = (iX8-x_correct)*(iX8-x_correct) + (iY8-y_correct)*(iY8-y_correct) < 169; // readius = 13
assign isInCircle9 = (iX9-x_correct)*(iX9-x_correct) + (iY9-y_correct)*(iY9-y_correct) < 169; // readius = 13
assign isInCircle10 = (iX10-x_correct)*(iX10-x_correct) + (iY10-y_correct)*(iY10-y_correct) < 169; // readius = 13

assign isInCircle11 = (86-x_cnt)*(86-x_cnt) + (63-y_cnt)*(63-y_cnt) < 256; // readius = 16
assign isInCircle12 = (446-x_cnt)*(446-x_cnt) + (63-y_cnt)*(63-y_cnt) < 256; // readius = 16
assign isInCircle13 = (806-x_cnt)*(806-x_cnt) + (63-y_cnt)*(63-y_cnt) < 256; // readius = 16
assign isInCircle14 = (86-x_cnt)*(86-x_cnt) + (463-y_cnt)*(463-y_cnt) < 256; // readius = 16
assign isInCircle15 = (446-x_cnt)*(446-x_cnt) + (463-y_cnt)*(463-y_cnt) < 256; // readius = 16
assign isInCircle16 = (806-x_cnt)*(806-x_cnt) + (463-y_cnt)*(463-y_cnt) < 256; // readius = 16

assign isInRectangle2 = (46 < x_cnt && x_cnt < 846) && (23 < y_cnt && y_cnt < 513);
assign isInRectangle3 = (56 < x_cnt && x_cnt < 836) && (33 < y_cnt && y_cnt < 496);
assign isInRectangle4 = (86 < x_cnt && x_cnt < 806) && (63 < y_cnt && y_cnt < 463);

//External Rounded Rectangle

assign isInRectangle5 = (46 < x_cnt && x_cnt < 846) && (53 < y_cnt && y_cnt < 473);
assign isInRectangle6 = (76 < x_cnt && x_cnt < 816) && (23 < y_cnt && y_cnt < 513);

assign isInCircle17 = (76-x_cnt)*(76-x_cnt) + (53-y_cnt)*(53-y_cnt) < 900; // readius = 30
assign isInCircle18 = (816-x_cnt)*(816-x_cnt) + (53-y_cnt)*(53-y_cnt) < 900; // readius = 30
assign isInCircle19 = (76-x_cnt)*(76-x_cnt) + (473-y_cnt)*(473-y_cnt) < 900; // readius = 30
assign isInCircle20 = (816-x_cnt)*(816-x_cnt) + (473-y_cnt)*(473-y_cnt) < 900; // readius = 30

//Internal Rounded Rectangle

assign isInRectangle7 = (56 < x_cnt && x_cnt < 836) && (58 < y_cnt && y_cnt < 468);
assign isInRectangle8 = (81 < x_cnt && x_cnt < 811) && (33 < y_cnt && y_cnt < 493);

assign isInCircle21 = (81-x_cnt)*(81-x_cnt) + (58-y_cnt)*(58-y_cnt) < 625; // readius = 30
assign isInCircle22 = (811-x_cnt)*(811-x_cnt) + (58-y_cnt)*(58-y_cnt) < 625; // readius = 30
assign isInCircle23 = (81-x_cnt)*(81-x_cnt) + (468-y_cnt)*(468-y_cnt) < 625; // readius = 30
assign isInCircle24 = (811-x_cnt)*(811-x_cnt) + (468-y_cnt)*(468-y_cnt) < 625; // readius = 30

//assign isInRectangle3 = (iX3+20 < x_cnt && x_cnt < iX3+60) && (iY3 < y_cnt && y_cnt < iY3 + 40);
// active player bar
assign isInRectangle9 = (60 < x_cnt && x_cnt < 80) && (162 < y_cnt && y_cnt < 362);

// effect screen
assign isInCircle25 = (446-x_cnt)*(446-x_cnt) + (263-y_cnt)*(263-y_cnt) < 22500;
assign isInCircle26 = (iX11-x_correct)*(iX11-x_correct) + (iY11-y_correct)*(iY11-y_correct) < 169; // readius = 13
						

// Assigns the right color data.
always_ff @(posedge iCLK) begin
	// If the screen is reset, put at zero the color signals.
	if (!iRST_n) begin
		read_red 	<= 8'b0;
		read_green 	<= 8'b0;
		read_blue 	<= 8'b0;
		counter <= 8'd0;
	// If we are in the active display area...
	end else if (display_area) begin
		case(screenType)
		// display the table with all ball
		3'b000: begin
			if(isInCircle1 && iX1 != 0 && iY1 !=0 ) begin
				read_red <= 8'hFF;
				read_blue <= 8'h00;
				read_green <= 8'h00;
			end
			else if(isInCircle2 && iX2 != 0 && iY2 !=0) begin
				read_red <= 8'h00;
				read_blue <= 8'hCC;
				read_green <= 8'h55;
			end
			else if(isInCircle3 && iX3 != 0 && iY3 !=0) begin
				read_red <= 8'hD0;
				read_blue <= 8'h7C;
				read_green <= 8'hB7;
			end
			else if(isInCircle4 && iX4 != 0 && iY4 !=0) begin
				read_red <= 8'hD6;
				read_blue <= 8'hC5;
				read_green <= 8'h85;
			end
			else if(isInCircle5 && iX5 != 0 && iY5 !=0) begin
				read_red <= 8'hD0;
				read_blue <= 8'h7C;
				read_green <= 8'hB7;
			end
			else if(isInCircle6 && iX6 != 0 && iY6 !=0) begin
				read_red <= 8'hD6;
				read_blue <= 8'hC5;
				read_green <= 8'h85;
			end
			else if(isInCircle7 && iX7 != 0 && iY7 !=0) begin
				read_red <= 8'hD0;
				read_blue <= 8'h7C;
				read_green <= 8'hB7;
			end
			else if(isInCircle8 && iX8 != 0 && iY8 !=0) begin
				read_red <= 8'hD6;
				read_blue <= 8'hC5;
				read_green <= 8'h85;
			end
			else if(isInCircle9 && iX9 != 0 && iY9 !=0) begin
				read_red <= 8'hD0;
				read_blue <= 8'h7C;
				read_green <= 8'hB7;
			end
			else if(isInCircle10 && iX10 != 0 && iY10 !=0) begin
				read_red <= 8'hD6;
				read_blue <= 8'hC5;
				read_green <= 8'h85;
			end
			else if(isInCircle11 ) begin
				read_red <= 8'h0;
				read_blue <= 8'h0;
				read_green <= 8'h0;
			end
			else if(isInCircle12 ) begin
				read_red <= 8'h0;
				read_blue <= 8'h0;
				read_green <= 8'h0;
			end
			else if(isInCircle13 ) begin
				read_red <= 8'h0;
				read_blue <= 8'h0;
				read_green <= 8'h0;
			end
			else if(isInCircle14 ) begin
				read_red <= 8'h0;
				read_blue <= 8'h0;
				read_green <= 8'h0;
			end
			else if(isInCircle15 ) begin
				read_red <= 8'h0;
				read_blue <= 8'h0;
				read_green <= 8'h0;
			end
			else if(isInCircle16) begin
				read_red <= 8'h0;
				read_blue <= 8'h0;
				read_green <= 8'h0;
			end		
			else if(isInRectangle9 && player) begin
				read_red <= 8'hFF;
				read_blue <= 8'h0;
				read_green <= 8'hFF;
			end
			else if(isInRectangle4)begin
				read_red <= 8'd00;
				read_blue <= 8'd96;
				read_green <= 8'd418;
			end
			else if(isInRectangle7 ||isInRectangle8 || isInCircle21 || isInCircle22 || isInCircle23 || isInCircle24)begin
				read_red <= 8'd12;
				read_blue <= 8'd30;
				read_green <= 8'd53;
			end
			else
			if( isInRectangle5 ||isInRectangle6 || isInCircle17 || isInCircle18 || isInCircle19 || isInCircle20)begin
				read_red <= 8'd67;
				read_blue <= 8'd14;
				read_green <= 8'd46;
			end
			else begin
				read_red <= 8'd0;
				read_blue <= 8'd0;
				read_green <= 8'd0;
			end
		end
		// Choose the effect
		3'b001: begin
					if(isInCircle26) begin
						read_red <= 8'h23;
						read_blue <= 8'h70;
						read_green <= 8'h14;
					end
					else if(isInCircle25) begin
						read_red <= 8'hFF;
						read_blue <= 8'hFF;
						read_green <= 8'hFF;
					end
					else begin
						read_red <= 8'd00;
						read_blue <= 8'd96;
						read_green <= 8'd418;
					end
				 end
		3'b010: begin
			if (oNewFrame) begin counter <= counter + 8'd1; end
			if (counter == 8'd255) begin counter <= 8'd0; end
			if((223 < x_cnt && x_cnt < 669) && (213 <= y_cnt && y_cnt < 313) && !q_rom_start) begin
				read_red <= counter[7:0];
				read_green <= counter[7:0];
				read_blue <= counter[7:0];
			end
			else if(isInRectangle4)begin
				read_red <= 8'd00;
				read_blue <= 8'd96;
				read_green <= 8'd418;
			end
			else if(isInRectangle7 ||isInRectangle8 || isInCircle21 || isInCircle22 || isInCircle23 || isInCircle24)begin
				read_red <= 8'd12;
				read_blue <= 8'd30;
				read_green <= 8'd53;
			end
			else if( isInRectangle5 ||isInRectangle6 || isInCircle17 || isInCircle18 || isInCircle19 || isInCircle20)begin
				read_red <= 8'd67;
				read_blue <= 8'd14;
				read_green <= 8'd46;
			end
			else begin
				read_red <= 8'd0;
				read_blue <= 8'd0;
				read_green <= 8'd0;
			end
		end
		3'b011: begin
			if((204 < x_cnt && x_cnt < 688) && (239 <= y_cnt && y_cnt < 281) && !q_rom_wait) begin
				read_red <= 8'b0;
				read_green <= 8'b0;
				read_blue <= 8'b0;
			end
			else if(isInRectangle4)begin
				read_red <= 8'd00;
				read_blue <= 8'd96;
				read_green <= 8'd418;
			end
			else if(isInRectangle7 ||isInRectangle8 || isInCircle21 || isInCircle22 || isInCircle23 || isInCircle24)begin
				read_red <= 8'd12;
				read_blue <= 8'd30;
				read_green <= 8'd53;
			end
			else if( isInRectangle5 ||isInRectangle6 || isInCircle17 || isInCircle18 || isInCircle19 || isInCircle20)begin
				read_red <= 8'd67;
				read_blue <= 8'd14;
				read_green <= 8'd46;
			end
			else begin
				read_red <= 8'd0;
				read_blue <= 8'd0;
				read_green <= 8'd0;
			end
		end
		3'b100: begin
			if((253 < x_cnt && x_cnt < 593) && (239 <= y_cnt && y_cnt < 281) && !q_rom_loading) begin
				read_red <= 8'b0;
				read_green <= 8'b0;
				read_blue <= 8'b0;
			end
			else if(isInRectangle4)begin
				read_red <= 8'd00;
				read_blue <= 8'd96;
				read_green <= 8'd418;
			end
			else if(isInRectangle7 ||isInRectangle8 || isInCircle21 || isInCircle22 || isInCircle23 || isInCircle24)begin
				read_red <= 8'd12;
				read_blue <= 8'd30;
				read_green <= 8'd53;
			end
			else if( isInRectangle5 ||isInRectangle6 || isInCircle17 || isInCircle18 || isInCircle19 || isInCircle20)begin
				read_red <= 8'd67;
				read_blue <= 8'd14;
				read_green <= 8'd46;
			end
			else begin
				read_red <= 8'd0;
				read_blue <= 8'd0;
				read_green <= 8'd0;
			end
		end
		endcase
	// If we aren't in the active display area, put at zero
	// the color signals.
	end else begin
		read_red 	<= 8'b0;
		read_green 	<= 8'b0;
		read_blue 	<= 8'b0;
	end
end

//--- Keeping track of x and y positions of the current pixel ------------------
//--- and generating the horiz. and vert. sync. signals ------------------------

always@(posedge iCLK or negedge iRST_n) begin
	if (!iRST_n)
	begin
		x_cnt <= 11'd0;	
		mhd  <= 1'd0;  
	end	
	else if (x_cnt == (H_LINE-1))
	begin
		x_cnt <= 11'd0;
		mhd  <= 1'd0;
	end	   
	else
	begin
		x_cnt <= x_cnt + 11'd1;
		mhd  <= 1'd1;
	end	
end

always@(posedge iCLK or negedge iRST_n) begin
	if (!iRST_n)
		y_cnt <= 10'd0;
	else if (x_cnt == (H_LINE-1))
	begin
		if (y_cnt == (V_LINE-1))
			y_cnt <= 10'd0;
		else
			y_cnt <= y_cnt + 10'd1;	
	end
end

always@(posedge iCLK  or negedge iRST_n) begin
	if (!iRST_n)
		mvd  <= 1'b1;
	else if (y_cnt == 10'd0)
		mvd  <= 1'b0;
	else
		mvd  <= 1'b1;
end	

assign oNewFrame = ((x_cnt == 11'd0)   && (y_cnt == 10'd0)  );	
assign oEndFrame = ((x_cnt == 11'd846) && (y_cnt == 10'd503));	
	
//--- Assigning synchronously the color and sync. signals ------------------

always@(posedge iCLK or negedge iRST_n) begin
	if (!iRST_n)
		begin
			oHD	<= 1'd0;
			oVD	<= 1'd0;
			oLCD_R <= 8'd0;
			oLCD_G <= 8'd0;
			oLCD_B <= 8'd0;
		end
	else
		begin
			oHD	<= mhd;
			oVD	<= mvd;
			oLCD_R <= read_red;
			oLCD_G <= read_green;
			oLCD_B <= read_blue;
		end		
end

							
endmodule




