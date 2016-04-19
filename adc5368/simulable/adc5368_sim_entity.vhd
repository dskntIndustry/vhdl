-----------------------------------------------------------------------------
--  _   _ _____ ____       ____   ___   __     __    _       _
-- | | | | ____/ ___|     / ___| / _ \  \ \   / /_ _| | __ _(_)___
-- | |_| |  _| \___ \ ____\___ \| | | |  \ \ / / _` | |/ _` | / __|
-- |  _  | |___ ___) |_____|__) | |_| |   \ V / (_| | | (_| | \__ \
-- |_| |_|_____|____/     |____/ \___/     \_/ \__,_|_|\__,_|_|___/
--
-----------------------------------------------------------------------------
-- File        : ADC.adc5368_sim.entity
-- Author      : Mikael Follonier
-- Date        : 20160408
-- Brief       : ADC5368 simulator entity
--
-----------------------------------------------------------------------------
--
-- Features    :  
--             
--             
--
-- Limitations :  
--                
--
-----------------------------------------------------------------------------
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
      enable      : in     std_ulogic;
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

