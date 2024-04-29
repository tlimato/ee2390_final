## Basys3_lab08.xdc
## Adapted from Basys3_Master.xdc provided by Digilent
## Jerry C. Hamann
## UWYO EE 2390 Fall 2016
## For Lab #08
##
## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal (JCH This is for the 100 MHz clock on-board the Basys3, won't use this in Lab #08, see button below).
# set_property PACKAGE_PIN W5 [get_ports clk]							
	# set_property IOSTANDARD LVCMOS33 [get_ports clk]
	# create_clock -add -name sys_clk_pin -period 1.00 -waveform {0 5} [get_ports clk]
 
## Switches  JCH Provide A inputs at rightmost two switches
set_property PACKAGE_PIN V17 [get_ports {countdown}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {countdown}]
set_property PACKAGE_PIN W2 [get_ports {stop}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {stop}]
set_property PACKAGE_PIN U1 [get_ports {start}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {start}]
set_property PACKAGE_PIN T1 [get_ports {sw[clear]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[clear]}]
set_property PACKAGE_PIN R2 [get_ports {reset}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {reset}]

##7 segment display
#set_property PACKAGE_PIN W7 [get_ports {seg[0]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
#set_property PACKAGE_PIN W6 [get_ports {seg[1]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
#set_property PACKAGE_PIN U8 [get_ports {seg[2]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
#set_property PACKAGE_PIN V8 [get_ports {seg[3]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
#set_property PACKAGE_PIN U5 [get_ports {seg[4]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
#set_property PACKAGE_PIN V5 [get_ports {seg[5]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
#set_property PACKAGE_PIN U7 [get_ports {seg[6]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

#set_property PACKAGE_PIN V7 [get_ports dp]							
	#set_property IOSTANDARD LVCMOS33 [get_ports dp]
#set_property PACKAGE_PIN U2 [get_ports {an[0]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
#set_property PACKAGE_PIN U4 [get_ports {an[1]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
#set_property PACKAGE_PIN V4 [get_ports {an[2]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
#set_property PACKAGE_PIN W4 [get_ports {an[3]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]


##Buttons  JCH Provide initial clk on center pushbutton
set_property PACKAGE_PIN U18 [get_ports clk]						
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
## JCH Doing this requires the following "over-ride" in order to synthesize
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_IBUF]
