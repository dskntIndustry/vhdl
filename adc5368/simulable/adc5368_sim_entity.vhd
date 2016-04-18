--
-- VHDL Entity ADC.adc5368_sim.arch_name
--
-- Created:
--          by - uadmin.UNKNOWN (WE5182)
--          at - 09:34:10 07.04.2016
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adc5368 is
   generic( 
      shiftRegisterBitNb : positive := 24;
      rampBitNb          : positive := 24;
      wordBitNb          : positive := 32;
      channelBitNb       : positive := 5
   );
   port( 
      clkmode     : in     std_ulogic;
      clock       : in     std_ulogic;
      dif0        : in     std_ulogic;
      dif1        : in     std_ulogic;
      lrck_gen_in : in     std_ulogic;
      m0          : in     std_ulogic;
      m1          : in     std_ulogic;
      mclk        : in     std_ulogic;   -- master clock
      mdiv        : in     std_ulogic;
      rst_n       : in     std_ulogic;
      sclk_gen_in : in     std_ulogic;
      adc_ov_n    : out    std_ulogic;
      sdout1      : out    std_ulogic;
      sdout2      : out    std_ulogic;
      sdout3      : out    std_ulogic;
      sdout4      : out    std_ulogic;
      lrck        : inout  std_ulogic;
      sclk        : inout  std_ulogic
   );

-- Declarations

end adc5368 ;

