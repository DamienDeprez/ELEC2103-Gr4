
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

								
module mtl_controller (
	input 		 iCLK_50,				 // System clock (50MHz)
	input 		 iRST,					 // System sync reset
	input [9:0] iX1, iX2, iX3, iX4, iX5,
	input [8:0] iY1, iY2, iY3, iY4, iY5,
	output       oCLK_33,				 // MTL Clock (33 MHz, 0°)
	// MMU 
	input 		 iLoading,				 // Control signal telling in which loading state is the system
	input [31:0] iREAD_DATA1, 			 // Data 1 (RGB)from SDRAM to MTL
	input [31:0] iREAD_DATA2,			 // Data 2 (RGB)from SDRAM to MTL
	output       oREAD_SDRAM_EN,		 // SDRAM read control signal
	output		 oNew_Frame,			 // Control signal being a pulse when a new frame of the LCD begins
	output		 oEnd_Frame,			 // Control signal being a pulse when a frame of the LCD ends
	output		 oGest_W,				 // Detected gesture pulse (sliding towards West)
	output 		 oGest_E,				 // Detected gesture pulse (sliding towards East)
	// MTL
	output		 oMTL_DCLK,				 // LCD Display clock (to MTL)
	output		 oMTL_HSD,				 // LCD horizontal sync (to MTL) 
	output		 oMTL_VSD,				 // LCD vertical sync (to MTL)
	output		 oMTL_TOUCH_I2C_SCL,  // I2C clock pin of Touch IC (to MTL)
	inout			 ioMTL_TOUCH_I2C_SDA, // I2C data pin of Touch IC (from/to MTL)
	input			 iMTL_TOUCH_INT_n,	 // Interrupt pin of Touch IC (from MTL)
	output [7:0] oMTL_R,					 // LCD red color data  (to MTL)
	output [7:0] oMTL_G,					 // LCD green color data (to MTL)
	output [7:0] oMTL_B 					 // LCD blue color data (to MTL)
);

	//=============================================================================
	// REG/WIRE declarations
	//=============================================================================

	logic       CLK_33, iCLK_33;						// 33MHz clocks for the MTL 

	//=============================================================================
	// Structural coding
	//=============================================================================

	/************************/
	/*  Display management  */
	/************************/

	mtl_display mtl_display_inst (
		// Host Side
		.iCLK(CLK_33),											// Input LCD control clock
		.iRST_n(~iRST),										// Input system reset
		.iX1(iX1),
		.iX2(iX2),
		.iX3(iX3),
		.iX4(iX4),
		.iX5(iX5),
		.iY1(iY1),
		.iY2(iY2),
		.iY3(iY3),
		.iY4(iY4),
		.iY5(iY5),
		// MMU
		.iLoading(iLoading),									// Control signal telling in which loading state is the system
		.iREAD_DATA1(iREAD_DATA1),							// Input data from SDRAM (RGB)
		.iREAD_DATA2(iREAD_DATA2),
		.oREAD_SDRAM_EN(oREAD_SDRAM_EN),					// SDRAM read control signal
		.oNew_Frame(oNew_Frame),							// Output signal being a pulse when a new frame of the LCD begins
		.oEnd_Frame(oEnd_Frame),							// Output signal being a pulse when a frame of the LCD ends
		// LCD Side
		.oLCD_R(oMTL_R),										// Output LCD horizontal sync 
		.oLCD_G(oMTL_G),										// Output LCD vertical sync
		.oLCD_B(oMTL_B),										// Output LCD red color data 
		.oHD(oMTL_HSD),										// Output LCD green color data 
		.oVD(oMTL_VSD)											// Output LCD blue color data  
	);

	assign oMTL_DCLK = iCLK_33;


	/**********************/
	/*  Touch management  */
	/**********************/

	mtl_touch mtl_touch_inst (
		.iCLK(iCLK_50),
		.iRST(iRST),
		// MTL TOUCH
		.iMTL_TOUCH_INT_n(iMTL_TOUCH_INT_n),			// Interrupt pin of Touch IC (from MTL)
		.ioMTL_TOUCH_I2C_SDA(ioMTL_TOUCH_I2C_SDA),	// I2C data pin of Touch IC (from/to MTL)
		.oMTL_TOUCH_I2C_SCL(oMTL_TOUCH_I2C_SCL),		// I2C clock pin of Touch IC (from MTL)
		// Gestures
		.oGest_W(oGest_W),									// Detected gesture pulse (sliding towards West)
		.oGest_E(oGest_E)										// Detected gesture pulse (sliding towards East)
	);
				

	/**********************/
	/*  Clock management  */ 
	/**********************/

	// This PLL generates 33 MHz for the LCD screen. CLK_33 is used to generate the controls 
	// while iCLK_33 is connected to the screen. Its phase is 120 so as to meet the setup and 
	// hold timing constraints of the screen.
	MTL_PLL	MTL_PLL_inst (
		.inclk0 (iCLK_50),
		.c0 (CLK_33),										//33MHz clock, phi=0
		.c1 (iCLK_33)										//33MHz clock, phi=120
	);
	
	assign  oCLK_33 = CLK_33;

	// Note: a critical warning is generated for the MTL_PLL:
	// "input clock is not fully compensated because it is fed by
	// a remote clock pin". In fact, each PLL can compensate the
	// input clock on a set of dedicated pins.
	// The input clock iCLK_50 (50MHz) should be available on other pins
	// than PIN_R8 so that it can be compensated on each PLL, it is
	// not the case in the DE0-Nano board.
	// Hopefully, it is not important here.
	//
	// You might as well see three other critical warnings about 
	// timing requirements. They are about communication between 
	// iCLK (50MHz) and CLK_33. It is impossible to completely get 
	// rid of them. They can be safely ignored as they aren't
	// related to signals whose timing is critical. 
 
endmodule // mtl_controller


