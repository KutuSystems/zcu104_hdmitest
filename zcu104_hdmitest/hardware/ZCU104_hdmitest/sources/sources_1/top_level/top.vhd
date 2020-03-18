--------------------------------------------------------------
--
-- (C) Copyright Kutu Pty. Ltd. 2018.
--
-- file: top.vhd
--
-- author: Greg Smart
--
--------------------------------------------------------------
--------------------------------------------------------------
--
-- This module is the top level module
-- running on a ZCU104 board.
--
--------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library xil_defaultlib;
use xil_defaultlib.system_top_wrapper;

entity top_ZCU104_hdmitest is
port (
    msp_nrst   : inout std_logic;
    msp_test   : inout std_logic;
    gpio_led   : out   std_logic_vector(3 downto 0);
    pmod_1     : inout std_logic_vector(7 downto 0)
);
end top_ZCU104_hdmitest;

architecture RTL of top_ZCU104_hdmitest is
begin

   system_top_wrapper_1 : entity xil_defaultlib.system_top_wrapper
   port map
   (
      msp_nrst => msp_nrst,
      msp_test => msp_test,
      msp430_debug_led => gpio_led,
      PMOD_1  => pmod_1
   );

end RTL;
