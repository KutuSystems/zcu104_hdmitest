# XDC for ZCU104_ASE design

# PMOD I/O's
set_property IOSTANDARD LVCMOS33 [get_ports pmod*]
set_property IOSTANDARD LVCMOS33 [get_ports msp_nrst]
set_property PACKAGE_PIN H8  [get_ports msp_nrst]
set_property IOSTANDARD LVCMOS33 [get_ports msp_test]
set_property PACKAGE_PIN G7  [get_ports msp_test]

set_property IOSTANDARD LVCMOS33 [get_ports gpio_led*]
set_property PACKAGE_PIN D5  [get_ports {gpio_led[0]}]
set_property PACKAGE_PIN D6  [get_ports {gpio_led[1]}]
set_property PACKAGE_PIN A5  [get_ports {gpio_led[2]}]
set_property PACKAGE_PIN B5  [get_ports {gpio_led[3]}]

#set_property PACKAGE_PIN G8  [get_ports {pmod_0[0]}]
#set_property PACKAGE_PIN H8  [get_ports {pmod_0[1]}]
#set_property PACKAGE_PIN G7  [get_ports {pmod_0[2]}]
#set_property PACKAGE_PIN H7  [get_ports {pmod_0[3]}]
#set_property PACKAGE_PIN G6  [get_ports {pmod_0[4]}]
#set_property PACKAGE_PIN H6  [get_ports {pmod_0[5]}]
#set_property PACKAGE_PIN J6  [get_ports {pmod_0[6]}]
#set_property PACKAGE_PIN J7  [get_ports {pmod_0[7]}]

set_property PACKAGE_PIN J9  [get_ports {pmod_1[0]}]
set_property PACKAGE_PIN K9  [get_ports {pmod_1[1]}]
set_property PACKAGE_PIN K8  [get_ports {pmod_1[2]}]
set_property PACKAGE_PIN L8  [get_ports {pmod_1[3]}]
set_property PACKAGE_PIN L10 [get_ports {pmod_1[4]}]
set_property PACKAGE_PIN M10 [get_ports {pmod_1[5]}]
set_property PACKAGE_PIN M8  [get_ports {pmod_1[6]}]
set_property PACKAGE_PIN M9  [get_ports {pmod_1[7]}]
