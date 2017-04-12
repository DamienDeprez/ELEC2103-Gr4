// new_component.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module new_component (
		input  wire        clock_clk,  //      clock.clk
		input  wire        SPI_CLK,    //    SPI_CLK.export
		input  wire        SPI_CS,     //     SPI_CS.export
		input  wire        SPI_MOSI,   //   SPI_MOSI.export
		output wire        SPI_MISO,   //   SPI_MISO.export
		output wire        Data_WE,    //    Data_WE.export
		output wire [6:0]  Data_Addr,  //  Data_Addr.export
		output wire [31:0] Data_Write, // Data_Write.export
		input  wire [31:0] Data_Read   //  Data_Read.export
	);

	spi_slave spi_slave_instance(
		.SPI_CLK    (SPI_CLK),
		.SPI_CS     (SPI_CS),
		.SPI_MOSI   (SPI_MOSI),
		.SPI_MISO   (SPI_MISO),
		.Data_WE    (Data_WE),
		.Data_Addr  (Data_Addr),
		.Data_Write (Data_Write),
		.Data_Read  (Data_Read),
		.Clk        (clock_clk)
	);

	
	
	
	
	
	
	
	

endmodule

