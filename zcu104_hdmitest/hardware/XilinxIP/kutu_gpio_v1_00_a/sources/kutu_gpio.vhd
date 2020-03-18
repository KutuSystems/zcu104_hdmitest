--------------------------------------------------------------
--
-- (C) Copyright Kutu Pty. Ltd. 2014.
--
-- file: axi4_lite_tb1.vhd
--
-- author: Greg Smart
--
--------------------------------------------------------------
--------------------------------------------------------------
--
-- This is a simple test bench for testing the the axi4 interface
--
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library kutu_gpio_v1_00_a;
use kutu_gpio_v1_00_a.axi4_lite_controller;
use kutu_gpio_v1_00_a.gpio_control;

entity kutu_gpio is
   generic (
      C_S_AXI_DATA_WIDTH   : integer  range 32 to 32       := 32;
      C_S_AXI_ADDR_WIDTH   : integer  range 4 to 16        := 16;
      C_SYS_ADDR_WIDTH     : integer  range 8 to 24        := 13;
      C_S_AXI_MIN_SIZE     : std_logic_vector(31 downto 0) := X"00001FFF";
      C_USE_WSTRB          : integer := 0;
      C_DPHASE_TIMEOUT     : integer range 0 to 512        := 8;
      C_BASEADDR           : std_logic_vector              := X"7000_0000";
      C_HIGHADDR           : std_logic_vector              := X"7000_FFFF";
      NUM_GPIO             : integer range 1 to 32         := 1
   );
   port (
      -- AXI bus signals
      S_AXI_LITE_ACLK      : in  std_logic;
      S_AXI_LITE_ARESETN   : in  std_logic;
      S_AXI_LITE_AWADDR    : in  std_logic_vector (31 downto 0);
      S_AXI_LITE_AWVALID   : in  std_logic;
      S_AXI_LITE_AWREADY   : out std_logic;
      S_AXI_LITE_WDATA     : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      S_AXI_LITE_WSTRB     : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
      S_AXI_LITE_WVALID    : in  std_logic;
      S_AXI_LITE_WREADY    : out std_logic;
      S_AXI_LITE_BRESP     : out std_logic_vector(1 downto 0);
      S_AXI_LITE_BVALID    : out std_logic;
      S_AXI_LITE_BREADY    : in  std_logic;
      S_AXI_LITE_ARADDR    : in  std_logic_vector(31 downto 0);
      S_AXI_LITE_ARVALID   : in  std_logic;
      S_AXI_LITE_ARREADY   : out std_logic;
      S_AXI_LITE_RDATA     : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      S_AXI_LITE_RRESP     : out std_logic_vector(1 downto 0);
      S_AXI_LITE_RVALID    : out std_logic;
      S_AXI_LITE_RREADY    : in  std_logic;

      -- write interface to system
      gpio                 : inout std_logic_vector(NUM_GPIO-1 downto 0)
   );
end kutu_gpio;

architecture RTL of kutu_gpio is

   signal sys_clk          : std_logic;                                         -- system clk (same as AXI clock
   signal sys_wraddr       : std_logic_vector(C_SYS_ADDR_WIDTH-1 downto 2);      -- address for reads/writes
   signal sys_wrdata       : std_logic_vector(31 downto 0);                     -- data/no. bytes
   signal sys_wr_cmd       : std_logic;                                         -- write strobe

   signal sys_rdaddr       : std_logic_vector(C_SYS_ADDR_WIDTH-1 downto 2);      -- address for reads/writes
   signal sys_rddata       : std_logic_vector(31 downto 0);                      -- input data port for read operation
   signal sys_rd_cmd       : std_logic;                                          -- read strobe
   signal sys_rd_endcmd    : std_logic;                                           -- input read strobe

begin

   AXI4_LITE_CONTROLLER_1 : entity kutu_gpio_v1_00_a.axi4_lite_controller
   generic map
   (
      C_SYS_ADDR_WIDTH     => C_SYS_ADDR_WIDTH,
      C_S_AXI_MIN_SIZE     => C_S_AXI_MIN_SIZE,
      C_USE_WSTRB          => C_USE_WSTRB,
      C_DPHASE_TIMEOUT     => C_DPHASE_TIMEOUT,
      C_BASEADDR           => C_BASEADDR,
      C_HIGHADDR           => C_HIGHADDR
   )
   port map
   (
      S_AXI_LITE_ACLK      => S_AXI_LITE_ACLK,
      S_AXI_LITE_ARESETN   => S_AXI_LITE_ARESETN,
      S_AXI_LITE_AWADDR    => S_AXI_LITE_AWADDR,
      S_AXI_LITE_AWVALID   => S_AXI_LITE_AWVALID,
      S_AXI_LITE_AWREADY   => S_AXI_LITE_AWREADY,
      S_AXI_LITE_WDATA     => S_AXI_LITE_WDATA,
      S_AXI_LITE_WSTRB     => S_AXI_LITE_WSTRB,
      S_AXI_LITE_WVALID    => S_AXI_LITE_WVALID,
      S_AXI_LITE_WREADY    => S_AXI_LITE_WREADY,
      S_AXI_LITE_BRESP     => S_AXI_LITE_BRESP,
      S_AXI_LITE_BVALID    => S_AXI_LITE_BVALID,
      S_AXI_LITE_BREADY    => S_AXI_LITE_BREADY,
      S_AXI_LITE_ARADDR    => S_AXI_LITE_ARADDR,
      S_AXI_LITE_ARVALID   => S_AXI_LITE_ARVALID,
      S_AXI_LITE_ARREADY   => S_AXI_LITE_ARREADY,
      S_AXI_LITE_RDATA     => S_AXI_LITE_RDATA,
      S_AXI_LITE_RRESP     => S_AXI_LITE_RRESP,
      S_AXI_LITE_RVALID    => S_AXI_LITE_RVALID,
      S_AXI_LITE_RREADY    => S_AXI_LITE_RREADY,

      -- write interface to system
      sys_clk              => sys_clk,             -- system clk (same as AXI clock
      sys_wraddr           => sys_wraddr,          -- address for reads/writes
      sys_wrdata           => sys_wrdata,          -- data/no. bytes
      sys_wr_cmd           => sys_wr_cmd,          -- write strobe

      -- read interface to system
      sys_rdaddr           => sys_rdaddr,          -- address for reads/writes
      sys_rddata           => sys_rddata,          -- input data port for read operation
      sys_rd_cmd           => sys_rd_cmd,          -- read strobe
      sys_rd_endcmd        => sys_rd_endcmd        -- input read strobe
   );

   GPIO_CONTROL_1 : entity kutu_gpio_v1_00_a.gpio_control
   generic map (
      C_SYS_ADDR_WIDTH     => C_SYS_ADDR_WIDTH,
      NUM_GPIO            => NUM_GPIO
   )
   port map (
      resetn               => S_AXI_LITE_ARESETN,
      clk                  => sys_clk,             -- system clk (same as AXI clock

      -- write interface from system
      sys_wraddr           => sys_wraddr,          -- address for reads/writes
      sys_wrdata           => sys_wrdata,          -- data/no. bytes
      sys_wr_cmd           => sys_wr_cmd,          -- write strobe

      sys_rdaddr           => sys_rdaddr,          -- address for reads/writes
      sys_rddata           => sys_rddata,          -- input data port for read operation
      sys_rd_cmd           => sys_rd_cmd,          -- read strobe
      sys_rd_endcmd        => sys_rd_endcmd,       -- input read strobe

      -- led output
      gpio                 => gpio
   );

end RTL;
