--
-- VHDL Entity ADC.adc5368_tdm_controller.arch_name
--
-- Created:
--          by - uadmin.UNKNOWN (WE5182)
--          at - 14:33:49 08.04.2016
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adc5368_tdm_controller is
   generic( 
      signalBitNb : positive := 24
   );
   port( 
      adc_ovfl_n   : in     std_ulogic;
      clock        : in     std_ulogic;
      enable       : in     std_ulogic;
      lrck         : in     std_ulogic;
      reset        : in     std_ulogic;
      sclk         : in     std_ulogic;
      sdout1       : in     std_ulogic;
      sdout2       : in     std_ulogic;
      sdout3       : in     std_ulogic;
      sdout4       : in     std_ulogic;
      clkmode      : out    std_ulogic;
      dif0         : out    std_ulogic;
      dif1         : out    std_ulogic;
      m0           : out    std_ulogic;
      m1           : out    std_ulogic;
      mclk         : out    std_ulogic;
      mdiv         : out    std_ulogic;
      rst_n        : out    std_ulogic;
      sample1      : out    signed (signalBitNb-1 downto 0);
      sample2      : out    signed (signalBitNb-1 downto 0);
      sample3      : out    signed (signalBitNb-1 downto 0);
      sample4      : out    signed (signalBitNb-1 downto 0);
      sample5      : out    signed (signalBitNb-1 downto 0);
      sample6      : out    signed (signalBitNb-1 downto 0);
      sample7      : out    signed (signalBitNb-1 downto 0);
      sample8      : out    signed (signalBitNb-1 downto 0);
      sample_valid : out    std_ulogic;
      audio_clock  : in     std_ulogic
   );

-- Declarations

end adc5368_tdm_controller ;

