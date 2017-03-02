

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

module mtl_touch_controller(
	input 	iCLK,
	input 	iRST,
	// MTL TOUCH
	input    MTL_TOUCH_INT_n,		// Interrupt pin of Touch IC (from MTL)
	inout 	MTL_TOUCH_I2C_SDA,	// I2C data pin of Touch IC (from/to MTL)
	output   MTL_TOUCH_I2C_SCL,	// I2C clock pin of Touch IC (from MTL)
	// Gestures
	output	Gest_Custom1,
	// Position
	
	output logic [9:0] x1_1i, x2_1i, x2_1f,
	output logic [8:0] y1_1i, y2_1i, y2_1f
);

//=============================================================================
// REG/WIRE declarations
//=============================================================================

logic [9:0] reg_x1, reg_x2, reg_x3, reg_x4, reg_x5;
logic [8:0] reg_y1, reg_y2, reg_y3, reg_y4, reg_y5;
logic [3:0] reg_touch_count;
logic [7:0] reg_gesture;
logic			touch_ready;

logic isGestCustom1; // set to 1 if the gesture is correct

reg [9:0] x1_initial, x2_initial, x2_final;
reg [8:0] y1_initial, y2_initial, y2_final;

logic [31:0] current_distance, initial_distance;

logic pulse1, pulse2;

assign current_distance = (x1_initial - reg_x2)*(x1_initial - reg_x2) + (y1_initial - reg_y2)*(y1_initial - reg_y2);
assign initial_distance = (x1_initial - x2_initial)*(x1_initial - x2_initial) + (y1_initial - y2_initial)*(y1_initial - y2_initial);

assign x1_1i = x1_initial;
assign y1_1i = y1_initial;

assign x2_1i = x2_initial;
assign y2_1i = y2_initial;

assign x2_1f = x2_final;
assign y2_1f = y2_final;

pulseGenerator generator(
	.clk(iCLK),
	.reset(iRST),
	.touch_count(reg_touch_count),
	.pulse1to2(pulse1),
	.pulse2to1(pulse2)
	);
	
// set the initial point of the gesture
always_ff @(posedge pulse1) begin
	x1_initial <= reg_x1;
	y1_initial <= reg_y1;
	
	x2_initial <= reg_x2;
	y2_initial <= reg_y2;
end

 // set the final point of the gesture if it's correct
always_ff @(posedge pulse2) begin
	if(isGestCustom1) begin
		x2_final <= reg_x2;
		y2_final <= reg_y2;
	end else begin
		x2_final <= 10'b0;
		y2_final <= 9'b0;
	end
end

always_ff @(posedge touch_ready, posedge pulse1) begin
	if(pulse1) 
		isGestCustom1 <= 1'b1;
	else
		isGestCustom1 <= (x1_initial - 10'd30 <= reg_x1 && reg_x1 <= x1_initial + 10'd30) && // verifie que x1 ne bouge pas 
						 (y1_initial - 9'd30 <= reg_y1 && reg_y1 <= y1_initial + 9'd30); // &&  // verifie que y1 ne bouge pas
						 //(initial_distance - 32'd400 <= current_distance && current_distance <= initial_distance + 32'd400);
end

//=============================================================================
// Structural coding
//=============================================================================

// This touch controller, provided by Terasic, is encrypted.
// To be able to use it, a license must be added to the Quartus
// project (Tools > License Setup...).
// The license file 'license_multi_touch.dat' is given
// in the folder DE0_Nano/License.
// For details about the inputs and outputs, you can refer to
// section 3.3 of the MTL datasheet available in the project
// file folder.
i2c_touch_config  i2c_touch_config_inst (
	.iCLK(iCLK),
	.iRSTN(~iRST),
	.INT_n(~MTL_TOUCH_INT_n),
	.oREADY(touch_ready),
	.oREG_X1(reg_x1),								
	.oREG_Y1(reg_y1),								
	.oREG_X2(reg_x2),								
	.oREG_Y2(reg_y2),
	.oREG_X3(reg_x3),								
	.oREG_Y3(reg_y3),	
	.oREG_X4(reg_x4),								
	.oREG_Y4(reg_y4),
	.oREG_X5(reg_x5),								
	.oREG_Y5(reg_y5),
	.oREG_TOUCH_COUNT(reg_touch_count),								
	.oREG_GESTURE(reg_gesture),								
	.I2C_SCLK(MTL_TOUCH_I2C_SCL),
	.I2C_SDAT(MTL_TOUCH_I2C_SDA)
);



// These two modules are small buffers for the touch
// controller outputs.
// The first one is for the sliding "West" gesture,
// the second one for the sliding "East" gesture.
// More details are given while defining the module, please see below.

/*touch_buffer	touch_buffer_west (
	.clk (iCLK),
	.rst (iRST),
	.trigger (touch_ready && (reg_touch_count == 4'd1)),
	.pulse (Gest_W)
);

touch_buffer	touch_buffer_east (
	.clk (iCLK),
	.rst (iRST),
	.trigger (touch_ready && (reg_touch_count == 4'd2)),
	.pulse (Gest_E)
);

touch_buffer 	touch_buffer_north (
	.clk (iCLK),
	.rst (iRST),
	.trigger (touch_ready && (reg_touch_count == 4'd3)),
	.pulse (Gest_N)
);

touch_buffer 	touch_buffer_south (
	.clk (iCLK),
	.rst (iRST),
	.trigger (touch_ready && (reg_touch_count == 4'd4)),
	.pulse (Gest_S)
);*/


endmodule // mtl_touch_controller


///////////////////////////////////////////////////////////////////////////


/*
 * This small counting module generates a one-cycle
 * pulse 0.2 secs after the rising edge of a trigger.
 * This module cannot be reactivated until 0.5 secs
 * have passed.
 * The time values are given for a 50 MHz input clock.
 * - 0.2 secs is short enough to bufferize the input of
 *   the touch controller while giving a fast response,
 * - 0.5 secs is for avoiding to skip two slides with
 *   a single touch.
 */
module touch_buffer (
	input  logic	clk,
	input  logic	rst,
	input  logic	trigger,
	output logic	pulse
	);

	logic active;
	logic [31:0] count;
	
	always_ff @ (posedge clk) begin
	
		if (rst) begin
			active <= 1'b0;
			count <= 32'd0;
		end else begin
			if (trigger && !active)
				active <= 1'b1;
			else if (active && (count < 32'd25000000))
				count <= count + 32'b1;
			else if (count >= 32'd25000000) begin
				active <= 1'b0;
				count <= 32'd0;
			end
		end
		
	end

	assign pulse = (count==32'd10000000); 
	
endmodule // touch_buffer

module pulseGenerator(
	input clk,
	input reset,
	input [3:0] touch_count,
	output pulse1to2, // pulse when touch_count go from 1 to 2
	output pulse2to1 // pulse when touch_count go down from 2 to 1
	);
	reg [3:0] touch_count_old;
	reg [3:0] touch_count_actual;
	
	always_ff @(posedge clk) begin
		touch_count_old <= touch_count_actual;
		touch_count_actual <= touch_count;
		if(touch_count_old == 4'd1 && touch_count_actual == 4'd2)
			pulse1to2 <= 1;
		else
			pulse1to2 <= 0;
		if(touch_count_old == 4'd2 && touch_count_actual == 4'd1)
			pulse2to1 <= 1;
		else
			pulse2to1 <= 0;
	end
endmodule 