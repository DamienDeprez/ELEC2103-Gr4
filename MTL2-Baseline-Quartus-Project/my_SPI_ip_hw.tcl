# TCL File Generated by Component Editor 16.1
# Fri Mar 10 09:25:22 CET 2017
# DO NOT MODIFY


# 
# my_SPI_ip "my_SPI_ip" v1.0
#  2017.03.10.09:25:22
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module my_SPI_ip
# 
set_module_property DESCRIPTION ""
set_module_property NAME my_SPI_ip
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME my_SPI_ip
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL new_component
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file new_component.v VERILOG PATH new_component.v TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clock_clk clk Input 1


# 
# connection point SPI_CLK
# 
add_interface SPI_CLK conduit end
set_interface_property SPI_CLK associatedClock clock
set_interface_property SPI_CLK associatedReset ""
set_interface_property SPI_CLK ENABLED true
set_interface_property SPI_CLK EXPORT_OF ""
set_interface_property SPI_CLK PORT_NAME_MAP ""
set_interface_property SPI_CLK CMSIS_SVD_VARIABLES ""
set_interface_property SPI_CLK SVD_ADDRESS_GROUP ""

add_interface_port SPI_CLK SPI_CLK export Input 1


# 
# connection point SPI_CS
# 
add_interface SPI_CS conduit end
set_interface_property SPI_CS associatedClock clock
set_interface_property SPI_CS associatedReset ""
set_interface_property SPI_CS ENABLED true
set_interface_property SPI_CS EXPORT_OF ""
set_interface_property SPI_CS PORT_NAME_MAP ""
set_interface_property SPI_CS CMSIS_SVD_VARIABLES ""
set_interface_property SPI_CS SVD_ADDRESS_GROUP ""

add_interface_port SPI_CS SPI_CS export Input 1


# 
# connection point SPI_MOSI
# 
add_interface SPI_MOSI conduit end
set_interface_property SPI_MOSI associatedClock clock
set_interface_property SPI_MOSI associatedReset ""
set_interface_property SPI_MOSI ENABLED true
set_interface_property SPI_MOSI EXPORT_OF ""
set_interface_property SPI_MOSI PORT_NAME_MAP ""
set_interface_property SPI_MOSI CMSIS_SVD_VARIABLES ""
set_interface_property SPI_MOSI SVD_ADDRESS_GROUP ""

add_interface_port SPI_MOSI SPI_MOSI export Input 1


# 
# connection point SPI_MISO
# 
add_interface SPI_MISO conduit end
set_interface_property SPI_MISO associatedClock clock
set_interface_property SPI_MISO associatedReset ""
set_interface_property SPI_MISO ENABLED true
set_interface_property SPI_MISO EXPORT_OF ""
set_interface_property SPI_MISO PORT_NAME_MAP ""
set_interface_property SPI_MISO CMSIS_SVD_VARIABLES ""
set_interface_property SPI_MISO SVD_ADDRESS_GROUP ""

add_interface_port SPI_MISO SPI_MISO export Output 1


# 
# connection point Data_WE
# 
add_interface Data_WE conduit end
set_interface_property Data_WE associatedClock clock
set_interface_property Data_WE associatedReset ""
set_interface_property Data_WE ENABLED true
set_interface_property Data_WE EXPORT_OF ""
set_interface_property Data_WE PORT_NAME_MAP ""
set_interface_property Data_WE CMSIS_SVD_VARIABLES ""
set_interface_property Data_WE SVD_ADDRESS_GROUP ""

add_interface_port Data_WE Data_WE export Output 1


# 
# connection point Data_Addr
# 
add_interface Data_Addr conduit end
set_interface_property Data_Addr associatedClock clock
set_interface_property Data_Addr associatedReset ""
set_interface_property Data_Addr ENABLED true
set_interface_property Data_Addr EXPORT_OF ""
set_interface_property Data_Addr PORT_NAME_MAP ""
set_interface_property Data_Addr CMSIS_SVD_VARIABLES ""
set_interface_property Data_Addr SVD_ADDRESS_GROUP ""

add_interface_port Data_Addr Data_Addr export Output 7


# 
# connection point Data_Write
# 
add_interface Data_Write conduit end
set_interface_property Data_Write associatedClock clock
set_interface_property Data_Write associatedReset ""
set_interface_property Data_Write ENABLED true
set_interface_property Data_Write EXPORT_OF ""
set_interface_property Data_Write PORT_NAME_MAP ""
set_interface_property Data_Write CMSIS_SVD_VARIABLES ""
set_interface_property Data_Write SVD_ADDRESS_GROUP ""

add_interface_port Data_Write Data_Write export Output 32


# 
# connection point Data_Read
# 
add_interface Data_Read conduit end
set_interface_property Data_Read associatedClock clock
set_interface_property Data_Read associatedReset ""
set_interface_property Data_Read ENABLED true
set_interface_property Data_Read EXPORT_OF ""
set_interface_property Data_Read PORT_NAME_MAP ""
set_interface_property Data_Read CMSIS_SVD_VARIABLES ""
set_interface_property Data_Read SVD_ADDRESS_GROUP ""

add_interface_port Data_Read Data_Read export Input 32

