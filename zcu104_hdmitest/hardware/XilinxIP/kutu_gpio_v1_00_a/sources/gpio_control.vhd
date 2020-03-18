--------------------------------------------------------------
--
-- (C) Copyright Kutu Pty. Ltd. 2014.
--
-- file: gpio_control.vhd
--
-- author: Greg Smart
--
--------------------------------------------------------------
--------------------------------------------------------------
--
-- This module is a simple gpio interface.
--
--------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- synopsys translate_off
library unisim;
use unisim.vcomponents.all;
-- synopsys translate_on

entity gpio_control is
   generic (
      C_SYS_ADDR_WIDTH     : integer  range 8 to 24        := 13;
      NUM_GPIO            : integer range 1 to 32           := 1
   );
   port (
      resetn               : in std_logic;
      clk                  : in std_logic;

      -- write interface from system
      sys_wraddr           : in std_logic_vector(C_SYS_ADDR_WIDTH-1 downto 2);                      -- address for reads/writes
      sys_wrdata           : in std_logic_vector(31 downto 0);                      -- data/no. bytes
      sys_wr_cmd           : in std_logic;                                          -- write strobe

      sys_rdaddr           : in std_logic_vector(C_SYS_ADDR_WIDTH-1 downto 2);                      -- address for reads/writes
      sys_rddata           : out std_logic_vector(31 downto 0);                     -- input data port for read operation
      sys_rd_cmd           : in std_logic;                                          -- read strobe
      sys_rd_endcmd        : out std_logic;                                         -- input read strobe

      -- led output
      gpio                 : inout std_logic_vector(NUM_GPIO-1 downto 0)
   );
end gpio_control;


architecture RTL of gpio_control is

   constant ZERO_VECTOR    : std_logic_vector(31 downto 0) := X"00000000";

   signal   gpio_output    : std_logic_vector(NUM_GPIO-1 downto 0);
   signal   gpio_input     : std_logic_vector(NUM_GPIO-1 downto 0);
   signal   gpio_tri       : std_logic_vector(NUM_GPIO-1 downto 0);
   signal   sys_rd_end     : std_logic;

   component IOBUF is
      port
      (
         I : in STD_LOGIC;
         O : out STD_LOGIC;
         T : in STD_LOGIC;
         IO : inout STD_LOGIC
      );
   end component;

begin

   sys_rd_endcmd  <= sys_rd_end and sys_rd_cmd;

   IO_BUF_0 : for I in 0 to NUM_GPIO-1 generate
   begin
      tri_iobuf_0: component IOBUF
      port map
      (
         I => gpio_output(I),
         IO => gpio(I),
         O => gpio_input(I),
         T => gpio_tri(I)
      );
   end generate;

   sys_rddata(31 downto NUM_GPIO) <= (others => '0');

   process (clk)
   begin
      if rising_edge(clk) then
         if resetn = '0' then
            sys_rddata   (NUM_GPIO-1 downto 0)  <= (others => '0');
            sys_rd_end                          <= '0';
            gpio_output                         <= (others => '0');
            gpio_tri                            <= (others => '1');
         else
            if sys_wr_cmd = '1' and sys_wraddr(C_SYS_ADDR_WIDTH-1 downto 4) = ZERO_VECTOR(C_SYS_ADDR_WIDTH-1 downto 4) then
               if sys_wraddr(3 downto 2) = "00" then
                  gpio_output <= sys_wrdata(NUM_GPIO-1 downto 0);
               elsif sys_wraddr(3 downto 2) = "01" then
                  gpio_tri    <= sys_wrdata(NUM_GPIO-1 downto 0);
               end if;
            end if;

            if sys_rdaddr(3 downto 2) = "00" then
               sys_rddata(NUM_GPIO-1 downto 0) <= gpio_input;
            elsif sys_rdaddr(3 downto 2) = "01" then
               sys_rddata(NUM_GPIO-1 downto 0) <= gpio_tri;
            else
               sys_rddata(NUM_GPIO-1 downto 0) <= gpio_output;
            end if;

            -- Control read strobe
            if sys_rd_cmd = '1' then
               sys_rd_end <= '1';
            elsif sys_rd_cmd = '0' then
               sys_rd_end <= '0';
            end if;

         end if;
      end if;
   end process;

 end RTL;
